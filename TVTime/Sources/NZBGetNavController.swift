/******************************************************************************
 *
 * NZBGetNavController
 *
 ******************************************************************************/

import UIKit
import TVTimeSDK

final class NZBGetNavController: TVTNavigationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let menu = storyboard?.instantiateViewController(withIdentifier: "NZBGetMenuViewController") as? NZBGetMenuViewController {
            menu.product = Networking.Product.nzbget
            sideMenu = ENSideMenu(sourceView: view, menuViewController: menu, menuPosition: .left)
            sideMenu?.bouncingEnabled = false
            sideMenu?.allowPanGesture = false
            sideMenu?.allowLeftSwipe = false
            sideMenu?.allowRightSwipe = false

            view.bringSubview(toFront: navigationBar)
        }
    }
}

