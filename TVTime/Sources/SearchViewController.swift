/******************************************************************************
 *
 * SearchViewController
 *
 ******************************************************************************/

import UIKit
import TVTimeSDK

class SearchViewController: TVTTableViewController {
    
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let term = searchBar.text {
            searchBar.resignFirstResponder()
            
            if self is CouchPotatoSearchViewController {
                MyHUD.sharedHUD.show()
                Networking.search(term, sortType: .year, success: { (results) in
                    self.items = results
                    MyHUD.sharedHUD.hide()
                }, failure: { (error) in
                    self.showAlert(message: error.localizedDescription)
                })
            } else if self is SonarrSearchViewController {
                MyHUD.sharedHUD.show()
                
                Networking.search(term, success: { (results) in
                    self.items = results
                    MyHUD.sharedHUD.hide()
                }, failure: { (error) in
                    self.showAlert(message: error.localizedDescription)
                })
            }
        }
    }
}
