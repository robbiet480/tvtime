/******************************************************************************
 *
 * SonarrNavigationViewController
 *
 ******************************************************************************/

import UIKit
import TVTimeSDK

final class SonarrNavigationController: TVTNavigationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let menu = storyboard?.instantiateViewController(withIdentifier: "SNRMenuTableViewController") as? SonarrMenuTableViewController {
            menu.product = Networking.Product.sonarr
            sideMenu = ENSideMenu(sourceView: view, menuViewController: menu, menuPosition:.left)
            sideMenu?.bouncingEnabled = false
            sideMenu?.allowPanGesture = false
            sideMenu?.allowLeftSwipe = false
            sideMenu?.allowRightSwipe = false

            view.bringSubview(toFront: navigationBar)
        }
    }
}
