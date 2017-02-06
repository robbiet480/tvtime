/******************************************************************************
 *
 * ConnectivityView
 *
 ******************************************************************************/

import UIKit

@IBDesignable
class ConnectivityView: UIView {

    var title = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            myView.backgroundColor = backgroundColor
        }
    }
    // MARK: private
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    fileprivate var myView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        xibSetup()
    }

    fileprivate func xibSetup() {

        myView = loadViewFromNib()
        myView.frame = bounds
        myView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(myView)
    }

    fileprivate func loadViewFromNib() -> UIView {

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: ConnectivityView.self), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView

        return view
    }

}
