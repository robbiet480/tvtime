/******************************************************************************
 *
 * TabController
 *
 ******************************************************************************/

import UIKit
import TVTimeSDK

final class TabController: UITabBarController, ENSideMenuDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(showSettings), name: Networking.NeedsSetup, object: nil)
    }

    func showSettings() {
        performSegue(withIdentifier: "showTVSettings", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = AppDelegate.shared.topViewController() as? TVTTableViewController,
            let navController = segue.destination as? UINavigationController,
            let settings = navController.topViewController as? TVTSettingsViewController {
            
            settings.dismissClosure = {
                vc.hideSideMenuView()
            }
        }
    }
}
