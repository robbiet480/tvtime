/******************************************************************************
 *
 * SonarrSeriesViewController
 *
 ******************************************************************************/

import UIKit
import TVTimeSDK

final class SonarrSeriesViewController: CollectionViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "TV Series"
        
        refreshControl.addTarget(self, action: #selector(loadSeries), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Media.allSeriesProfiles.count == 0 {
            if Networking.areUserDefaultsSet() {
                MyHUD.sharedHUD.show()
                
            }
            NotificationCenter.default.addObserver(self, selector: #selector(loadSeries), name: Networking.DoneConfiguringSonarr, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(hide), name: Networking.ErrorConfiguringSonarr, object: nil)
        } else {
            loadSeries()
        }
        
    }
    
    func loadSeries() {
        if !refreshControl.isRefreshing {
            MyHUD.sharedHUD.show()
        }
        
        Networking.series(Media.SeriesSortType.airDate, success: { (series) in
            self.refreshControl.endRefreshing()
            self.items = series
            self.collectionView?.reloadData()
            MyHUD.sharedHUD.hide()
        }) { (error) in
            MyHUD.sharedHUD.hide()
            self.refreshControl.endRefreshing()
            self.showAlert(message: error.localizedDescription)
        }
    }
    
    func delete(series: Series, indexPath: IndexPath) {
        MyHUD.sharedHUD.show()
        Networking.delete(series, success: { (success) in
            MyHUD.sharedHUD.hide()
            if success {
                self.items.remove(at: indexPath.row)
                self.collectionView?.deleteItems(at: [indexPath])
                
            } else {
                self.navigationController?.toast(title: "Unable to delete"  )
            }
        }, failure: { (error) in
            self.showAlert(message: error.localizedDescription)
        })
    }
    
    func update(series: SeriesMutable, indexPath: IndexPath) {
        MyHUD.sharedHUD.show()
        Networking.update(series.id, putBody: series, success: { (series) in
            MyHUD.sharedHUD.hide()
            self.items[indexPath.row] = series
            self.navigationController?.toast(title: "Quality updated")
            self.collectionView?.reloadItems(at: [indexPath])
            
        }, failure: { (error) in
            MyHUD.sharedHUD.hide()
            self.showAlert(message: error.localizedDescription)
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let tvShow = items[indexPath.row] as? Series else {
            fatalError()
        }
        
        if isTableViewMode {
            let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! MediaCollectionViewCell
            
            let deleteButton = SwipeButton(title: "Delete", backgroundColor: UIColor.red, callback: {
                self.delete(series: tvShow, indexPath: indexPath)
            })
            
            let qualityButton = SwipeButton(title: "Quality", backgroundColor: UIColor.orange, callback: {
                let completionBlock: ((SeriesQualityProfile) -> Void) = { qualityProfile in
                    
                    let updatedSeries = SeriesMutable(series: tvShow, profile: qualityProfile)
                    self.update(series: updatedSeries, indexPath: indexPath)
                }
                
                guard let profile = tvShow.profile else {
                    return
                }
                
                let vc = UIAlertController.qualityActionSheet("Choose Quality", selectedProfileId: String(profile.id), qualityProfiles: Media.allSeriesProfiles, completion: completionBlock)
                
                self.present(vc, animated: true, completion: nil)
            })
                        
            cell.config(withItem: tvShow, buttons: [qualityButton, deleteButton])
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MediaCollectionViewPosterCell.self), for: indexPath) as? MediaCollectionViewPosterCell else {
                fatalError()
            }
            
            cell.config(withItem: tvShow)
            cell.buttonHandler = {
                let alert = UIAlertController.changeItemActionSheet(qualityCompletion: {
                    let completionBlock: ((SeriesQualityProfile) -> Void) = { qualityProfile in
                        
                        let updatedSeries = SeriesMutable(series: tvShow, profile: qualityProfile)
                        self.update(series: updatedSeries, indexPath: indexPath)
                    }
                    
                    guard let profile = tvShow.profile else {
                        return
                    }
                    
                    let vc = UIAlertController.qualityActionSheet("Choose Quality", selectedProfileId: String(profile.id), qualityProfiles: Media.allSeriesProfiles, completion: completionBlock)
                    
                    self.present(vc, animated: true, completion: nil)
                    
                }, deleteCompletion: {
                    self.delete(series: tvShow, indexPath: indexPath)
                })
                
                self.present(alert, animated: true, completion: nil )
            }
            
            return cell
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showSeriesDetail" {
            guard let indexPath = sender as? IndexPath, let vc = segue.destination as? DetailsViewController, let series = items[indexPath.row] as? Series else {
                fatalError()
            }
            
            vc.item = series
        }
    }
    
    //MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, didSelectItemAt: indexPath)
        
        performSegue(withIdentifier: "showSeriesDetail", sender: indexPath)
    }
}
