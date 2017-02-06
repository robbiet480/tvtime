/******************************************************************************
 *
 * SeriesQualityProfileItem
 *
 ******************************************************************************/

import SwiftyJSON

public final class SeriesQualityProfileItem {

    fileprivate struct Keys {
        static let quality = "quality"
        static let allowed = "allowed"
    }

    public let quality: SeriesQualityProfileType
    public let allowed: Bool
    
    init?(json: JSON?)
    {
        guard let json = json else {
            return nil
        }
        
        guard let quality = SeriesQualityProfileType(json: json[Keys.quality]), let allowed = json[Keys.allowed].bool else {
            return nil
        }
        
        self.quality = quality
        self.allowed = allowed
    }
}
