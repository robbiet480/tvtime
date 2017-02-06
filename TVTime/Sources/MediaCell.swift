/******************************************************************************
 *
 * MediaCell
 *
 ******************************************************************************/

import UIKit
import MGSwipeTableCell
import AlamofireImage
import TVTimeSDK

final class MediaCell: MGSwipeTableCell {
    
    @IBOutlet fileprivate weak var posterImage: UIImageView!
    @IBOutlet fileprivate weak var title: UILabel!
    @IBOutlet fileprivate weak var airDate: UILabel!
    @IBOutlet fileprivate weak var quality: UILabel!
    
    var buttonHandler: ((Void) -> Void)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterImage?.image = UIImage.placeholder()
        title?.text = nil
        airDate.text = nil
        quality.text = nil

    }
    
    func config(withItem item: Any, isSearch: Bool = false) {
                
        if let movie = item as? Movie {
            title.text = movie.title
            airDate.text = String(movie.year)
            
            if let profile = movie.profile {
                quality.text = profile.title
            } else {
                quality.text = nil
            }
            
            if isSearch {
                let add = UIButton(type: .contactAdd)
                add.addTarget(self, action: #selector(addMovie), for: .touchUpInside)
                
                self.accessoryView = add
            }

            guard let url = movie.imageUrl(.poster) else {
                return
            }
            
            posterImage.af_setImage(withURL: url, placeholderImage: UIImage.placeholder(), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .noTransition, runImageTransitionIfCached: false, completion: nil)
            
        } else if let series = item as? Series {
            
            if let name = series.profile?.name {
                quality.text = name
            }
            
            title?.text = series.title
            airDate.text = series.nextAirDateString()
            
            guard let url = series.imageUrl(.poster) else {
                return
            }
            
            posterImage.af_setImage(withURL: url, placeholderImage: UIImage.placeholder(), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .noTransition, runImageTransitionIfCached: false, completion: nil)

        } else if let searchResult = item as? SeriesSearchResult {
            let add = UIButton(type: .contactAdd)
            add.addTarget(self, action: #selector(addSeries), for: .touchUpInside)
            
            self.accessoryView = add
            
            title?.text = searchResult.title
            
            let calendar = Calendar.current
            let year = calendar.component(.year, from: searchResult.firstAired)

            airDate.text = "First Aired: " + String(year)
            quality.text = nil
            
            guard let url = searchResult.imageUrl(.poster) else {
                return
            }
            
            posterImage.af_setImage(withURL: url, placeholderImage: UIImage.placeholder(), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .noTransition, runImageTransitionIfCached: false, completion: nil)
        }
    }
    
    func addMovie() {
        
        if let buttonHandler = buttonHandler {
            buttonHandler()
        }
    }
    
    func addSeries() {
        if let _ = buttonHandler {
            buttonHandler()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImage?.image = nil
        title?.text = nil
        airDate.text = nil
        quality.text = nil
    }
}
