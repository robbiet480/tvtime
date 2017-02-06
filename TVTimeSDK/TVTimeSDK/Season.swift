/******************************************************************************
 *
 * Season
 *
 ******************************************************************************/

import SwiftyJSON

public final class Season {
    
    internal struct Keys {
        static let seasonNumber = "seasonNumber"
        static let monitored = "monitored"
        static let statistics = "statistics"
    }
    
    let seasonNumber: Int
    let monitored: Bool
    let statistics: [String : Any]?
    
    init?(json: JSON?)
    {
        guard let json = json else {
            return nil
        }
        
        guard let seasonNumber = json[Keys.seasonNumber].int, let monitored = json[Keys.monitored].bool else {
            return nil
        }
        
        if let statistics = json[Keys.statistics].dictionaryObject {
            self.statistics = statistics
        } else {
            statistics = nil
        }
        
        self.seasonNumber = seasonNumber
        self.monitored = monitored
    }
}

extension Season: DictionaryRepresentationProtocol {
    
    public func toDictionary() -> [String : Any] {
        
        var dictionary: [String: Any] = [:]
        
        dictionary.updateValue(seasonNumber, forKey: Keys.seasonNumber)
        dictionary.updateValue(String(monitored), forKey: Keys.monitored)
        
        if let statistics = statistics {
            dictionary.updateValue(statistics, forKey: Keys.statistics)
        }
        
        return dictionary
    }
}


