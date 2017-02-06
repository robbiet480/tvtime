/******************************************************************************
 *
 * SereisQualityProfile
 *
 ******************************************************************************/

import SwiftyJSON

public final class SeriesQualityProfile: Equatable {
    
    fileprivate struct Keys {
        static let name = "name"
        static let id = "id"
        static let language = "language"
        static let cutoff = "cutoff"
        static let items = "items"
    }

    public let name: String
    public let cutoff: SeriesQualityProfileType
    public var items: [SeriesQualityProfileItem]?
    public let language: String
    public let id: Int
    
    init?(json: JSON?)
    {
        guard let json = json else {
            return nil
        }
        
        guard let name = json[Keys.name].string,
        let cutoff = SeriesQualityProfileType(json: json[Keys.cutoff]),
        let language = json[Keys.language].string,
            let id = json[Keys.id].int else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.language = language
        self.cutoff = cutoff
        
        if let items = json[Keys.items].array {
            self.items = items.flatMap({ SeriesQualityProfileItem(json: $0) })
        } else {
            items = nil
        }
    }    
}

public func == (lhs: SeriesQualityProfile, rhs: SeriesQualityProfile) -> Bool {
    return lhs.id == rhs.id
}
