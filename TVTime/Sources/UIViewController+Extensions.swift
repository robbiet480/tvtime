/******************************************************************************
 *
 * UIViewController+Extensions
 *
 ******************************************************************************/

extension UIViewController {
    
    func showAlert(title: String? = nil, message: String) {
        let alert = UIAlertController.errorAlertAction(title, message: message)
        present(alert, animated: true, completion: nil)
    }
}
