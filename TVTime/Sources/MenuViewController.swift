/******************************************************************************
 *
 * MenuViewController
 *
 ******************************************************************************/

import UIKit
import TVTimeSDK

class MenuViewController: UITableViewController {

    var selectedMenuItem = 0
    var product: Networking.Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0)
        tableView.selectRow(at: IndexPath(row: selectedMenuItem, section: 0), animated: false, scrollPosition: .none)
    }
        
    @IBAction func didTapAppSettings(_ sender: AnyObject) {
        if let tabController = AppDelegate.shared.tabViewController() as? TabController {
            tabController.showSettings()
            
            if let navController = AppDelegate.shared.tabViewController()?.selectedViewController as? TVTNavigationViewController {
                navController.sideMenu?.hideSideMenu()
            }
        }
    }
    
    fileprivate func identifier(product: Networking.Product, name: String) -> String {
        return String(format:"%@%@ViewController", product.rawValue, name)
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == selectedMenuItem {
            sideMenuController()?.sideMenu?.toggleMenu()
        } else {
            selectedMenuItem = indexPath.row
            
            if let name = (tableView.cellForRow(at: indexPath)?.textLabel?.text), let sb = storyboard, let product = product {
                let destViewController = sb.instantiateViewController(withIdentifier: identifier(product: product, name: name))
                
                sideMenuController()?.setContentViewController(destViewController)
            }
        }
    }

}
