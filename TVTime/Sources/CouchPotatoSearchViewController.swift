/******************************************************************************
 *
 * CouchPotatoSearchViewController
 *
 ******************************************************************************/

import UIKit
import TVTimeSDK

final class CouchPotatoSearchViewController: SearchViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search for Movies"
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let movie = items[indexPath.row] as? Movie else {
            fatalError()
        }
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! MediaCell
        
        cell.config(withItem: movie, isSearch: true)
        cell.buttonHandler = {
            
            MyHUD.sharedHUD.show()
            Networking.add(movie, success: { (success) in
                MyHUD.sharedHUD.hide()
                self.navigationController?.toast(title: "\(movie.title) added successfully!")
                if success {
                    self.toggleSideMenuView()
                }
            }, failure: { (error) in
                MyHUD.sharedHUD.hide()
                self.showAlert(message: error.localizedDescription)
            })
        }
        
        return cell
    }
}
