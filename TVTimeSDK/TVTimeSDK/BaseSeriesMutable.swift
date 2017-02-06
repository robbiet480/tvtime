/******************************************************************************
 *
 * BaseSeriesMutable
 *
 ******************************************************************************/

public final class BaseSeriesMutable {
    fileprivate var baseSeries: BaseSeries
    
    // MARK: Mutable Properties
    var profile: SeriesQualityProfile
    
    init(baseSeries: BaseSeries, profile: SeriesQualityProfile) {
        
        self.baseSeries = baseSeries
        self.profile = profile
    }
}

extension BaseSeriesMutable: DictionaryRepresentationProtocol {
    
    public func toDictionary() -> [String: Any] {
        
        var dictionary: [String: Any] = [:]
        
        dictionary.updateValue(baseSeries.title, forKey: Series.Keys.title)
        dictionary.updateValue(baseSeries.status, forKey: Series.Keys.status)
        dictionary.updateValue(baseSeries.overview, forKey: Series.Keys.overview)
        dictionary.updateValue(baseSeries.network, forKey: Series.Keys.network)
        dictionary.updateValue(baseSeries.year, forKey: Series.Keys.year)
        dictionary.updateValue(baseSeries.firstAired.toString(.custom(DefaultValueKey.SonarrDateFormatString), timeZone: .utc), forKey: Series.Keys.firstAired)
        
        if let profile = baseSeries.profile {
            dictionary.updateValue(profile.id, forKey: Series.Keys.qualityProfileId)
        }
        
        dictionary.updateValue(baseSeries.tvdbId, forKey: Series.Keys.tvdbId)

        dictionary.updateValue(baseSeries.titleSlug, forKey: Series.Keys.titleSlug)
        
        if let seasons = baseSeries.seasons {
            dictionary.updateValue(seasons.toDictionary(), forKey: Series.Keys.seasons)
        }

        if let images = baseSeries.images {
            dictionary.updateValue(images.toDictionary(), forKey: Series.Keys.images)
        }
        
        if let path = baseSeries.path {
            dictionary.updateValue(path, forKey: Series.Keys.path)
        }
        
        return dictionary
    }
}

