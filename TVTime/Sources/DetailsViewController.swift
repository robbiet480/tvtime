/******************************************************************************
 *
 * DetailsViewController
 *
 ******************************************************************************/

import UIKit
import AlamofireImage
import TVTimeSDK

final class DetailsViewController: UIViewController {

    var item: Any?
    var shouldUpdate:((Void)-> (Void))?
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var overview: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let item = item else {
            fatalError()
        }
        
        poster.image = UIImage.placeholder()

        if let series = item as? Series {
            title = series.title
            
            overview.text = series.overview
            
            guard let url = series.imageUrl(.fanart) else {
                return
            }
            
            poster.af_setImage(withURL: url, placeholderImage: UIImage.placeholder(), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .noTransition, runImageTransitionIfCached: false, completion: nil)
                
        } else if let movie = item as? Movie {
            title = movie.title
            
            overview.text = movie.plot
            
            guard let url = movie.imageUrl(.backdrop) else {
                return
            }
            
            poster.af_setImage(withURL: url, placeholderImage: UIImage.placeholder(), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .noTransition, runImageTransitionIfCached: false, completion: nil)

        }
    }

}
