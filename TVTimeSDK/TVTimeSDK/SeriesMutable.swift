/******************************************************************************
 *
 * SeriesMutable
 *
 ******************************************************************************/

public final class SeriesMutable {
    
    open var id: Int {
        get {
            return series.id
        }
    }

    fileprivate var series: Series
    fileprivate var seasons: [SeasonMutable]
    
    // MARK: Mutable Properties
    var profile: SeriesQualityProfile
    
    public init(series: Series, profile: SeriesQualityProfile) {
        
        self.series = series
        self.profile = profile
        
        var mSeasons = [SeasonMutable]()
        
        if let aSeasons = series.seasons {
            for aSeason in aSeasons {
                mSeasons.append(SeasonMutable(season: aSeason))
            }
        }
        
        seasons = mSeasons
    }
}

extension SeriesMutable: DictionaryRepresentationProtocol {
    
    public func toDictionary() -> [String: Any] {
        
        var dictionary: [String: Any] = [:]
                
        dictionary.updateValue(series.status, forKey: Series.Keys.status)
        dictionary.updateValue(series.overview, forKey: Series.Keys.overview)
        dictionary.updateValue(series.network, forKey: Series.Keys.network)
        dictionary.updateValue(series.year, forKey: Series.Keys.year)
        dictionary.updateValue(series.firstAired.toString(.custom(DefaultValueKey.SonarrDateFormatString), timeZone: .utc), forKey: Series.Keys.firstAired)
        
        if let images = series.images {
            dictionary.updateValue(images.toDictionary(), forKey: Series.Keys.images)
        }
        
        dictionary.updateValue(series.title, forKey: Series.Keys.title)
        dictionary.updateValue(series.titleSlug, forKey: Series.Keys.titleSlug)
        dictionary.updateValue(seasons.toDictionary(), forKey: Series.Keys.seasons)
        
        if let path = series.path {
            dictionary.updateValue(path, forKey: Series.Keys.path)
        }

        if let previousAiring = series.previousAiring {
            dictionary.updateValue(previousAiring, forKey: Series.Keys.previousAiring)
        }

        dictionary.updateValue(series.tvdbId, forKey: Series.Keys.tvdbId)
        dictionary.updateValue(profile.id, forKey: Series.Keys.qualityProfileId)
        dictionary.updateValue(series.sortTitle, forKey: Series.Keys.sortTitle)
        dictionary.updateValue(series.totalEpisodeCount, forKey: Series.Keys.totalEpisodeCount)
        dictionary.updateValue(series.episodeCount, forKey: Series.Keys.episodeCount)
        dictionary.updateValue(series.episodeFileCount, forKey: Series.Keys.episodeFileCount)
        dictionary.updateValue(series.sizeOnDisk, forKey: Series.Keys.sizeOnDisk)
        dictionary.updateValue(String(series.monitored), forKey: Series.Keys.monitored)
        dictionary.updateValue(String(series.seasonFolder), forKey: Series.Keys.seasonFolder)
        dictionary.updateValue(String(series.useSceneNumbering), forKey: Series.Keys.useSceneNumbering)
        dictionary.updateValue(series.tvRageId, forKey: Series.Keys.tvRageId)
        dictionary.updateValue(series.tvMazeId, forKey: Series.Keys.tvMazeId)
        dictionary.updateValue(series.cleanTitle, forKey: Series.Keys.cleanTitle)
        dictionary.updateValue(series.imdbId, forKey: Series.Keys.imdbId)
        dictionary.updateValue(series.genres, forKey: Series.Keys.genres)
        dictionary.updateValue(series.tags, forKey: Series.Keys.tags)
        dictionary.updateValue(series.added.toString(.custom(DefaultValueKey.SonarrDateFormatString), timeZone: .utc), forKey: Series.Keys.added)
        dictionary.updateValue(series.ratings, forKey: Series.Keys.ratings)
        dictionary.updateValue(series.seasonCount, forKey: Series.Keys.seasonCount)
        dictionary.updateValue(series.runtime, forKey: Series.Keys.runtime)
        dictionary.updateValue(series.id, forKey: Series.Keys.id)
        
        if let nextAiring = series.nextAiring, nextAiring != Date.distantFuture {
            dictionary.updateValue(nextAiring.toString(.custom(DefaultValueKey.SonarrDateFormatString), timeZone: .utc), forKey: Series.Keys.nextAiring)
        }
        
        return dictionary
    }
}
