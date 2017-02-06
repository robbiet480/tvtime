/******************************************************************************
 *
 * CouchPotatoNavViewController
 *
 ******************************************************************************/

import UIKit
import TVTimeSDK

final class CouchPotatoNavController: TVTNavigationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let menu = storyboard?.instantiateViewController(withIdentifier: "CouchPotatoMenuViewController") as? CouchPotatoMenuViewController {
            menu.product = Networking.Product.couchPotato
            sideMenu = ENSideMenu(sourceView: view, menuViewController: menu, menuPosition:.left)
            sideMenu?.bouncingEnabled = false
            sideMenu?.allowPanGesture = false
            sideMenu?.allowLeftSwipe = false
            sideMenu?.allowRightSwipe = false

            view.bringSubview(toFront: navigationBar)
        }
    }
}
