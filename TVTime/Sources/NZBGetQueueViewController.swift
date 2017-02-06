/******************************************************************************
 *
 * NZBGetQueueViewController
 *
 ******************************************************************************/

import UIKit
import MGSwipeTableCell
import TVTimeSDK

final class NZBGetQueueViewController: TVTTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        title = "Downloads"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
    }
    
    func refresh() {
        
        refreshControl?.beginRefreshing()
        Networking.queue({ (items) in
            self.items = items
            self.refreshControl?.endRefreshing()
        }) { (error) in
            self.showAlert(message: error.localizedDescription)
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count > 0 ? items.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "queueCell", for: indexPath) as? NZBGetTableCell else {
            fatalError()
        }
        
        if items.count > 0 {
            guard let item = items[indexPath.row] as? NZBQueueItem else {
                fatalError()
            }
            
            cell.configure(item: item)
            
            let pauseButton = MGSwipeButton(title: "Pause", backgroundColor: UIColor.orange, callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                
                MyHUD.sharedHUD.show()
                Networking.pause(item, success: { (success) in
                    sleep(1)
                    self.refresh()
                }, failure: { (error) in
                    self.showAlert(message: error.localizedDescription)
                })
                
                return true
            })
            
            let resumeButton = MGSwipeButton(title: "Resume", backgroundColor: UIColor.blue, callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                
                MyHUD.sharedHUD.show()
                Networking.resume(item, success: { (success) in
                    sleep(1)
                    self.refresh()
                }, failure: { (error) in
                    self.showAlert(message: error.localizedDescription)
                })
                
                return true
            })
            
            let deleteButton = MGSwipeButton(title: "Delete", backgroundColor: UIColor.red, callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                
                MyHUD.sharedHUD.show()
                Networking.delete(item, success: { (successfulDelete) in
                    
                    sleep(1)
                    if !successfulDelete {
                        self.navigationController?.toast(title: "Delete unsuccessful")
                    } else {
                        self.refresh()
                    }
                }, failure: { (error) in
                    self.showAlert(message: error.localizedDescription)
                })
                
                return true
            })
            cell.rightButtons = [deleteButton, pauseButton, resumeButton]
            cell.rightSwipeSettings.transition = .drag
        } else {
            cell.title.text = "Download queue is empty"
            cell.status.text = nil
            cell.progress.isHidden = true
        }
        
        return cell
    }
}
