/******************************************************************************
 *
 * TVTNavigationViewController
 *
 ******************************************************************************/

import UIKit
import IBAnimatable

class TVTNavigationViewController: ENSideMenuNavigationController, ENSideMenuDelegate, ToastPresenter, TransitionAnimatable  {

    let defaultTransitionDuration: Duration = 0.75

    // MARK: - TransitionAnimatable
    @IBInspectable  var _transitionAnimationType: String? {
        didSet {
            if let _transitionAnimationType = _transitionAnimationType {
                transitionAnimationType = TransitionAnimationType(string: _transitionAnimationType)
            }
        }
    }
    open var transitionAnimationType: TransitionAnimationType = .none {
        didSet {
            configureNavigationControllerDelegate()
        }
    }
    @IBInspectable open var transitionDuration: Double = .nan {
        didSet {
            configureNavigationControllerDelegate()
        }
    }
    open var interactiveGestureType: InteractiveGestureType = .none {
        didSet {
            configureNavigationControllerDelegate()
        }
    }
    
    @IBInspectable var _interactiveGestureType: String? {
        didSet {
            if let _interactiveGestureType = _interactiveGestureType {
                interactiveGestureType = InteractiveGestureType(string: _interactiveGestureType)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bringSubview(toFront: navigationBar)
    }
    
    // MARK: - Private
    // Must have a property to keep the reference alive because `UINavigationController.delegate` is `weak`
    fileprivate var navigator: Navigator?
    
    fileprivate func configureNavigationControllerDelegate() {
        if case .none = transitionAnimationType {
            navigator = nil
            delegate = nil
            return
        }
        var duration = transitionDuration
        // Set the default duration for transition
        if transitionDuration.isNaN {
            duration = defaultTransitionDuration
        }
        
        if case .none = interactiveGestureType {
            navigator = Navigator(transitionAnimationType: transitionAnimationType, transitionDuration: duration)
        } else {
            navigator = Navigator(transitionAnimationType: transitionAnimationType, transitionDuration: duration, interactiveGestureType: interactiveGestureType)
        }
        delegate = navigator
    }

}
