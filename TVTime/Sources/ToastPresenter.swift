/******************************************************************************
 *
 * ToastPresenter
 *
 ******************************************************************************/

import UIKit

protocol ToastPresenter {

    func showToast(message: String)
    func showNoConnection()
    func hideNoConnection()
}

extension ToastPresenter where Self: UINavigationController {

    fileprivate func overlayView() -> ConnectivityView {

        for subview in view.subviews {
            if subview is ConnectivityView {
                return subview as! ConnectivityView
            }
        }

        let oView = ConnectivityView(frame: CGRect(x: 0, y: navigationBar.frame.origin.y, width: view.bounds.size.width, height: navigationBar.frame.size.height))
        oView.backgroundColor = .red
        oView.isHidden = false
        view.insertSubview(oView, belowSubview: navigationBar)

        return oView
    }
    
    fileprivate func show(_ overlay: ConnectivityView? = nil, autoDismiss: Bool = false) {
        
        let overlay = overlay ?? overlayView()
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            var frame = overlay.frame
            frame.origin.y += frame.size.height
            overlay.frame = frame
        }, completion: { (finished) in
            if autoDismiss {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.hide()
                }
            }
        })
    }
    
    func showToast(message: String) {

        let overlay = overlayView()
        overlay.backgroundColor = .green
        overlay.title = message
        
        show(overlay, autoDismiss: true)
    }
    
    fileprivate func hide() {

        var overlay: ConnectivityView?
        
        for subview in view.subviews {
            if let view = subview as? ConnectivityView {
                overlay = view
                break
            }
        }
        
        if let overlay = overlay {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                var frame = overlay.frame
                frame.origin.y -= frame.size.height
                
                overlay.frame = frame
                
            }, completion: { (finished) in
                overlay.isHidden = true
                overlay.removeFromSuperview()
            })
        }
    }

    func showNoConnection() {
        show()
    }

    func hideNoConnection() {
        hide()
    }
}
