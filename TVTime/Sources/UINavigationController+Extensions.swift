/******************************************************************************
 *
 * UINavigationController+Extensions
 *
 ******************************************************************************/

extension UINavigationController {
    
    func toast(title: String) {
        
        if let nav = self as? TVTNavigationViewController {
            nav.showToast(message: title)
        }
    }
}
