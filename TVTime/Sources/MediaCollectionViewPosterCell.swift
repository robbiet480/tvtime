/******************************************************************************
 *
 * MediaCollectionViewPosterCell
 *
 ******************************************************************************/

import UIKit
import AlamofireImage
import IBAnimatable
import TVTimeSDK

final class MediaCollectionViewPosterCell: UICollectionViewCell {
    
    @IBOutlet fileprivate weak var posterImage: UIImageView!
    @IBOutlet fileprivate weak var spinner: AnimatableActivityIndicatorView!

    var longPress: UILongPressGestureRecognizer!
    var buttonHandler: ((Void) -> Void)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(didPress(_:)))
        addGestureRecognizer(longPress)
    }
    
    func didPress(_ recognizer: UILongPressGestureRecognizer) {
        
        if let buttonHandler = buttonHandler {
            buttonHandler()
        }
    }
    
    func config(withItem item: Any) {
        
        var url: URL?
        
        if let series = item as? Series {
            url = series.imageUrl(.poster)
        } else if let movie = item as? Movie {
            url = movie.imageUrl(.poster)
        }
        
        if let url = url {
            spinner.startAnimating()
            posterImage.af_setImage(withURL: url, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .noTransition, runImageTransitionIfCached: false, completion: { (data) in
                self.spinner.stopAnimating()
            })
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImage?.image = nil
        spinner.stopAnimating()
    }
}
