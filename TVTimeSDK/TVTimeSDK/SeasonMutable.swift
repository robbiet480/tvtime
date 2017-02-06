/******************************************************************************
 *
 * SeasonMutable
 *
 ******************************************************************************/

public final class SeasonMutable {
    
    fileprivate var season: Season
    
    // MARK: Mutable Properties
    var monitored: Bool
    
    init(season: Season) {
        
        self.season = season
        self.monitored = season.monitored
    }
}

extension SeasonMutable: DictionaryRepresentationProtocol {
    
    public func toDictionary() -> [String : Any] {
        
        var dictionary: [String: Any] = [:]
        
        dictionary.updateValue(season.seasonNumber, forKey: Season.Keys.seasonNumber)
        dictionary.updateValue(String(monitored), forKey: Season.Keys.monitored)
        
        if let statistics = season.statistics {
            dictionary.updateValue(statistics, forKey: Season.Keys.statistics)
        }
        
        return dictionary
    }
}
