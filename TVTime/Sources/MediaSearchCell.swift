/******************************************************************************
 *
 * MediaSearchCell
 *
 ******************************************************************************/

import UIKit
import AlamofireImage
import TVTimeSDK

final class MediaSearchCell: UICollectionViewCell {
    
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var spinner: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var synopsisLabel: UILabel!
    
    var buttonHandler: ((Void) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.image = UIImage.placeholder()
    }
    
    
    func config(withSeries series: Series, size: CGSize) {
        
        var frame = contentView.frame
        frame.size = size
        contentView.frame = frame
        
        titleLabel.text = series.title
        synopsisLabel.text = nil
        
        guard let url = series.imageUrl(.poster) else {
            return
        }
        
        spinner.startAnimating()

        imageView.af_setImage(withURL: url, placeholderImage: UIImage.placeholder(), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .noTransition, runImageTransitionIfCached: false, completion: { (data) in
            self.spinner.stopAnimating()
        })

    }
    
    @IBAction func addSeries() {
        if let buttonHandler = buttonHandler {
            buttonHandler()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        synopsisLabel.text = nil
        imageView.image = nil
        spinner.stopAnimating()
    }
}
