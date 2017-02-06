/******************************************************************************
 *
 * MediaCollectionViewCell
 *
 ******************************************************************************/

import UIKit
import IBAnimatable
import TVTimeSDK

final class MediaCollectionViewCell: UICollectionViewCell {
    
    var shouldPan = false {
        didSet {
            pan.isEnabled = shouldPan
        }
    }
    @IBOutlet fileprivate weak var labelsContainer: UIView!
    @IBOutlet fileprivate weak var posterImage: UIImageView!
    @IBOutlet fileprivate weak var title: UILabel!
    @IBOutlet fileprivate weak var airDate: UILabel!
    @IBOutlet fileprivate weak var quality: UILabel!
    @IBOutlet fileprivate weak var buttonContainer: UIStackView!
    @IBOutlet fileprivate weak var containerTrailing: NSLayoutConstraint!
    @IBOutlet fileprivate weak var containerLeading: NSLayoutConstraint!
    @IBOutlet fileprivate weak var myContentView: UIView!
    @IBOutlet fileprivate weak var buttonContainerWidth: NSLayoutConstraint!
    @IBOutlet fileprivate weak var spinner: AnimatableActivityIndicatorView!
    
    fileprivate var rightButtons: [SwipeButton]? {
        willSet {
            buttonContainer.arrangedSubviews.forEach({
                buttonContainer.removeArrangedSubview($0)
                $0.removeFromSuperview()
            })
            
            buttonContainerWidth.constant = 0
        }
        didSet {
            if let rightButtons = rightButtons {
                rightButtons.forEach({
                    buttonContainer.addArrangedSubview($0)
                })

                buttonContainerWidth.constant = CGFloat(rightButtons.count) * bounds.size.height
            }
        }
    }
    
    fileprivate var panStartPoint: CGPoint!
    fileprivate var pan: UIPanGestureRecognizer!
    fileprivate var buttonWidth: CGFloat = 80.0
    fileprivate var startingRightLayoutConstraintConstant: CGFloat = 0.0
    fileprivate let bounceValue: CGFloat = 20.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterImage?.image = nil
        title?.text = nil
        airDate.text = nil
        quality.text = nil
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        pan.delegate = self
        addGestureRecognizer(pan)
    }
    
    func didPan(_ recognizer: UIPanGestureRecognizer) {
        
        switch (recognizer.state) {
        case .began:
            
            panStartPoint = recognizer.translation(in: myContentView)
            startingRightLayoutConstraintConstant = containerTrailing.constant
        case .changed:
            
            let currentPoint = recognizer.translation(in: myContentView)
            let deltaX = currentPoint.x - panStartPoint.x
            var panningLeft = false
            
            if currentPoint.x < panStartPoint.x {
                panningLeft = true
            }
            
            if cellWasOpening() {
                if !panningLeft {
                    let constant = max(-deltaX, 0)
                    
                    if constant == 0 {
                        resetConstraintContstantsToZero(animated: true)
                    } else {
                        containerTrailing.constant = constant
                    }
                } else {
                    let constant = min(-deltaX, buttonContainerWidth.constant)
                    
                    if constant == buttonContainerWidth.constant {
                        setConstraintsToShowAllButtons(animated: true)
                    } else {
                        containerTrailing.constant = constant
                    }
                }
            } else {
                let adjustment = startingRightLayoutConstraintConstant - deltaX
                
                if !panningLeft {
                    let constant = max(adjustment, 0)
                    
                    if constant == 0 {
                        resetConstraintContstantsToZero(animated: true)
                    } else {
                        containerTrailing.constant = constant
                    }
                } else {
                    let constant = min(adjustment, buttonContainerWidth.constant)
                    
                    if constant == buttonContainerWidth.constant {
                        setConstraintsToShowAllButtons(animated: true)
                    } else {
                        containerTrailing.constant = constant
                    }
                }
            }
            
            containerLeading.constant = -containerTrailing.constant
            
            
        case .ended:
            
            let halfOfButtonsWidth = buttonContainerWidth.constant / 2
            
            if cellWasOpening() {
                if containerTrailing.constant >= halfOfButtonsWidth {
                    setConstraintsToShowAllButtons(animated: true)
                } else {
                    resetConstraintContstantsToZero(animated: true)
                }
            } else {
                if containerTrailing.constant >= halfOfButtonsWidth {
                    setConstraintsToShowAllButtons(animated: true)
                } else {
                    resetConstraintContstantsToZero(animated: true)
                }
            }
        case .cancelled:
            if cellWasOpening() {
                resetConstraintContstantsToZero(animated: true)
            } else {
                setConstraintsToShowAllButtons(animated: true)
            }
            
        default: break
        }
    }
    
    fileprivate func cellWasOpening() -> Bool {
        return startingRightLayoutConstraintConstant == 0.0
    }
    
    fileprivate func resetConstraintContstantsToZero(animated: Bool) {
        
        if (startingRightLayoutConstraintConstant == 0 && containerTrailing.constant == 0) {
            return
        }
        
        containerTrailing.constant = -bounceValue
        containerLeading.constant = bounceValue
        
        updateConstraintsIfNeeded(animated: animated) { (finished) -> (Void) in
            self.containerTrailing.constant = 0
            self.containerLeading.constant = 0
            
            self.updateConstraintsIfNeeded(animated: animated) { (finished) -> (Void) in
                self.startingRightLayoutConstraintConstant = self.containerTrailing.constant
            }
        }
    }
    
    fileprivate func setConstraintsToShowAllButtons(animated: Bool) {
        
        if (startingRightLayoutConstraintConstant == buttonContainerWidth.constant && containerLeading.constant == buttonContainerWidth.constant) {
            return
        }
        
        containerLeading.constant = -buttonContainerWidth.constant - bounceValue
        containerTrailing.constant = buttonContainerWidth.constant + bounceValue
        
        updateConstraintsIfNeeded(animated: animated) { (finished) -> (Void) in
            self.containerLeading.constant = -self.buttonContainerWidth.constant
            self.containerTrailing.constant = self.buttonContainerWidth.constant
            
            self.updateConstraintsIfNeeded(animated: animated, completion: { (finished) -> (Void) in
                self.startingRightLayoutConstraintConstant = self.containerTrailing.constant
            })
        }
    }
    
    fileprivate func updateConstraintsIfNeeded(animated: Bool, completion: @escaping ((Bool)) -> (Void)) {
        var duration: TimeInterval = 0
        
        if animated {
            duration = 0.1
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }) { (finished) in
            completion(finished)
        }
    }
    
    func config(withItem item: Any, buttons: [SwipeButton]? = nil) {
        
        var url: URL?
        
        if let series = item as? Series {
            if let name = series.profile?.name {
                quality.text = name
            }
            
            title?.text = series.title
            airDate.text = series.nextAirDateString()
            url = series.imageUrl(.poster)
        } else if let movie = item as? Movie {
            
            title.text = movie.title
            airDate.text = String(movie.year)
            
            if let profile = movie.profile {
                quality.text = profile.title
            } else {
                quality.text = nil
            }
            
            url = movie.imageUrl(.poster)
        }
        
        if let url = url {
            spinner.startAnimating()
            posterImage.af_setImage(withURL: url, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .noTransition, runImageTransitionIfCached: false, completion: { (data) in
                self.spinner.stopAnimating()
            })
        }
        
        rightButtons = buttons
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImage?.image = nil
        title?.text = nil
        airDate.text = nil
        quality.text = nil
        rightButtons = nil
        resetConstraintContstantsToZero(animated: false)
        buttonContainerWidth.constant = 0
        
        spinner.stopAnimating()
    }
}

extension MediaCollectionViewCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer != pan {
            return false
        }
        
        return true
    }
}
