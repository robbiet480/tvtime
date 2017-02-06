/******************************************************************************
 *
 * FloatingPlaceholderTextField
 *
 ******************************************************************************/

import UIKit

@IBDesignable
final class FloatingPlaceholderTextField: UITextField {
    
    //MARK: Public
    @IBInspectable var placeholderText: String = "" {
        didSet {
            floatingLabel.text = placeholderText
            floatingLabel.sizeToFit()
        }
    }
    @IBInspectable var placeholderTextColor: UIColor = .lightGray {
        didSet {
            setPlaceholder()
        }
    }
    
    override var text: String? {
        didSet {
            textFieldTextDidChange()
        }
    }
    
    //MARK: Private
    fileprivate let floatingLabel = UILabel()
    fileprivate var shouldAnimateFloatingLabel = false
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    fileprivate func setPlaceholder() {
        attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSForegroundColorAttributeName: placeholderTextColor])
        floatingLabel.textColor = placeholderTextColor
    }
    
    fileprivate func commonInit() {
        clipsToBounds = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChange), name: .UITextFieldTextDidChange, object: self)
        
        floatingLabel.font = font
        floatingLabel.isHidden = true
        floatingLabel.backgroundColor = .clear
        floatingLabel.frame = floatingLabelStartFrame()
    }
    
    fileprivate func floatingLabelStartFrame() -> CGRect {
        var frame = placeholderRect(forBounds: bounds)
        frame.size = floatingLabel.frame.size
        return frame
    }
    
    @objc fileprivate func textFieldTextDidChange() {
        
        let previousShouldAnimateFloatingLabel = shouldAnimateFloatingLabel
        shouldAnimateFloatingLabel = hasText
        
        if shouldAnimateFloatingLabel != previousShouldAnimateFloatingLabel {
            if shouldAnimateFloatingLabel {
                animateFloatingLabel(away: true)
            } else {
                animateFloatingLabel(away: false)
            }
        }
    }
    
    fileprivate func animateFloatingLabel(away: Bool) {
        
        if away {
            addSubview(floatingLabel)
            floatingLabel.isHidden = false
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                let origin = CGPoint(x: 0, y: -(self.floatingLabel.bounds.size.height))
                var targetFrame = self.floatingLabel.frame
                targetFrame.origin = origin
                self.floatingLabel.frame = targetFrame
                
                let fontSize = self.floatingLabel.font.pointSize
                let fontName = self.floatingLabel.font.fontName
                
                self.floatingLabel.font = UIFont(name: fontName, size: fontSize * 0.75)
            }) { (finished) in
                self.attributedPlaceholder = nil
            }
        } else {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.floatingLabel.frame = self.floatingLabelStartFrame()
                
            }) { (finished) in
                self.floatingLabel.isHidden = true
                self.floatingLabel.removeFromSuperview()
                self.floatingLabel.font = self.font
                self.setPlaceholder()
            }
        }
        
    }
}
