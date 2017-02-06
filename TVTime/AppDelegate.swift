/******************************************************************************
 *
 * AppDelegate
 *
 ******************************************************************************/


import UIKit
import AlamofireNetworkActivityIndicator
import TVTimeSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let shared = AppDelegate()
    static let noConnectionBlock = {
        if let nav = AppDelegate.shared.topViewController()?.navigationController as? TVTNavigationViewController {
            nav.showNoConnection()
        }
    }
    static let connectionBlock = {
        if let nav = AppDelegate.shared.topViewController()?.navigationController as? TVTNavigationViewController {
            nav.hideNoConnection()
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        NetworkActivityIndicatorManager.shared.isEnabled = true
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Networking.startWiFiDetection(reachableBlock: {
            AppDelegate.connectionBlock()
        }, notReachableBlock: {
            AppDelegate.noConnectionBlock()
        })
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Networking.stopWiFiDetection()
    }

    func topViewController(_ base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }

    func tabViewController() -> UITabBarController? {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if let tabController = appDelegate.window?.rootViewController as? UITabBarController {
                return tabController
            }
        }

        return nil
    }
}

