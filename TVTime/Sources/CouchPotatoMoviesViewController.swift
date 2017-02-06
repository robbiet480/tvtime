/******************************************************************************
 *
 * CouchPotatoMoviesViewController
 *
 ******************************************************************************/

import UIKit
import TVTimeSDK

final class CouchPotatoMoviesViewController: CollectionViewController {
    
    var snatchedAndAvailable = [Movie]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "Movies"
        
        refreshControl.addTarget(self, action: #selector(loadMovies), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Media.allMovieProfiles.count == 0 {
            MyHUD.sharedHUD.show()
            NotificationCenter.default.addObserver(self, selector: #selector(loadMovies), name: Networking.DoneConfiguringCouchPotato, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(hide), name: Networking.ErrorConfiguringCouchPotato, object: nil)
        } else {
            loadMovies()
        }
    }
    
    func loadMovies() {
        
        if !refreshControl.isRefreshing {
            MyHUD.sharedHUD.show()
        }
        
        Networking.movies(.active, sortType: .name, success: { (movies) in
            self.items = movies
            MyHUD.sharedHUD.hide()
            self.refreshControl.endRefreshing()
            self.collectionView?.reloadData()
        }) { (error) in
            MyHUD.sharedHUD.hide()
            self.showAlert(message: error.localizedDescription)
            self.refreshControl.endRefreshing()
        }
        
        Networking.movies(.active, sortType: .name, expandSnatchedAndAvailable: true, success: { (movies) in
            self.snatchedAndAvailable = movies
            self.collectionView?.reloadData()
            MyHUD.sharedHUD.hide()
        }) { (error) in
            MyHUD.sharedHUD.hide()
        }
    }
    
    func changeQuality(movie: Movie, indexPath: IndexPath)
    {
        let completionBlock: ((MovieProfile) -> Void) = { qualityProfile in
            
            let updatedMovie = MovieMutable(movie: movie, profile: qualityProfile)
            
            MyHUD.sharedHUD.show()
            Networking.update(updatedMovie, success: { (success) in
                MyHUD.sharedHUD.hide()
                self.navigationController?.toast(title: "Quality updated")
                self.loadMovies()
            }, failure: { (error) in
                MyHUD.sharedHUD.hide()
                self.showAlert(message: error.localizedDescription)
            })
        }
        
        let vc = UIAlertController.qualityActionSheet("Choose Quality", selectedProfileId: movie.profile?.id, qualityProfiles: Media.allMovieProfiles, completion: completionBlock)
        
        present(vc, animated: true, completion: nil)
    }
    
    func delete(movie: Movie, indexPath: IndexPath) {
        MyHUD.sharedHUD.show()
        Networking.delete(movie, success: { (success) in
            if success {
                self.items.remove(at: indexPath.row)
                self.collectionView?.deleteItems(at: [indexPath])
            } else {
                MyHUD.sharedHUD.hide()
                self.navigationController?.toast(title: "Unable to delete movie")
            }
            
        }, failure: { (error) in
            MyHUD.sharedHUD.hide()
            self.showAlert(message: error.localizedDescription)
        })
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let movie = items[indexPath.row] as? Movie else {
            fatalError()
        }
        
        if isTableViewMode {
            let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! MediaCollectionViewCell
            let deleteButton = SwipeButton(title: "Delete", backgroundColor: UIColor.red, callback: {
                self.delete(movie: movie, indexPath: indexPath)
            })
            
            let qualityButton = SwipeButton(title: "Quality", backgroundColor: UIColor.orange, callback: {
                self.changeQuality(movie: movie, indexPath: indexPath)
            })
            
            cell.config(withItem: movie, buttons: [qualityButton, deleteButton])
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MediaCollectionViewPosterCell.self), for: indexPath) as? MediaCollectionViewPosterCell else {
                fatalError()
            }
            
            cell.config(withItem: movie)
            cell.buttonHandler = {
                let alert = UIAlertController.changeItemActionSheet(qualityCompletion: {
                    self.changeQuality(movie: movie, indexPath: indexPath)
                    
                }, deleteCompletion: {
                    self.delete(movie: movie, indexPath: indexPath)
                })
                
                self.present(alert, animated: true, completion: nil )
            }
            
            return cell
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMovieDetail" {
            guard let indexPath = sender as? IndexPath, let vc = segue.destination as? DetailsViewController, let movie = items[indexPath.row] as? Movie else {
                fatalError()
            }
            
            vc.item = movie
        }
    }
    
    //MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, didSelectItemAt: indexPath)
        performSegue(withIdentifier: "showMovieDetail", sender: indexPath)
    }
    
}
