/******************************************************************************
 *
 * SeriesQualityProfileType
 *
 ******************************************************************************/

import SwiftyJSON

public final class SeriesQualityProfileType {

    fileprivate struct Keys {
        static let name = "name"
        static let id = "id"
    }

    public let name: String
    public let id: Int
    
    init?(json: JSON?)
    {
        guard let json = json, let name = json[Keys.name].string, let id = json[Keys.id].int else {
            return nil
        }
        
        self.name = name
        self.id = id
    }

}
