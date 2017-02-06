/******************************************************************************
 *
 * NZBGetTableCell
 *
 ******************************************************************************/

import UIKit
import MGSwipeTableCell
import TVTimeSDK

final class NZBGetTableCell: MGSwipeTableCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var healthLabel: UILabel!
    
    let greenColor = UIColor(red: 97.0 / 255.0, green: 180.0 / 255.0, blue: 94.0 / 255.0, alpha: 1.0)
    let orangeColor = UIColor(red: 249.0 / 255.0, green: 178.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        progress.transform = progress.transform.scaledBy(x: 1, y: 2)
        progress.progressTintColor = greenColor
        progress.isHidden = true
        
        healthLabel.textColor = orangeColor
        healthLabel.textAlignment = .center
        healthLabel.text = nil
        
        status.textColor = greenColor
    }
    
    func configure(item: NZBQueueItem) {
        
        title.text = item.title
        status.text = item.status.rawValue.capitalized
        
        if item.health < 100 {
            healthLabel.text = "Health: \(item.health)%"
        }
        
        let sizeLeft = 1.0 - (Float(item.remainingSize) / Float(item.fileSize))
        
        switch item.status {
        case .downloading:
            progress.isHidden = false
            progress.progress = sizeLeft
            progress.progressTintColor = greenColor
        case .paused:
            progress.isHidden = false
            progress.progress = sizeLeft
            status.textColor = orangeColor
            progress.progressTintColor = orangeColor
        default:
            if item.postStageProgress <= 1000 {
                progress.isHidden = false
                progress.progress = 1.0 - Float(1000 - item.postStageProgress)
            }
        }
    }
    
    override func prepareForReuse() {

        progress.progressTintColor = greenColor
        progress.isHidden = true
        
        healthLabel.textColor = orangeColor
        healthLabel.textAlignment = .center
        healthLabel.text = nil
        
        status.textColor = greenColor
    }
}
