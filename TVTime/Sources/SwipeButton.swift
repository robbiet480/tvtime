/******************************************************************************
 *
 * SwipeButton
 *
 ******************************************************************************/
import UIKit

final class SwipeButton: UIButton {

    typealias SwipeButtonCallback = (Void) -> (Void)

    private var callback: SwipeButtonCallback?
    
    init(title: String, backgroundColor: UIColor, callback: @escaping SwipeButtonCallback) {
        
        self.callback = callback
        
        super.init(frame: CGRect.zero)
        
        setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTap() {
        if let callback = callback {
            callback()
        }
    }
}
