/******************************************************************************
 *
 * SeriesSearchResult
 *
 ******************************************************************************/

import SwiftyJSON

public final class SeriesSearchResult: BaseSeries {

    override init?(json: JSON?) {

        super.init(json: json)
    }
}

extension SeriesSearchResult: DictionaryRepresentationProtocol {

    public func toDictionary() -> [String: Any] {

        var dictionary: [String: Any] = [:]

        dictionary.updateValue(tvdbId, forKey: Keys.tvdbId)
        dictionary.updateValue(title, forKey: Keys.title)
        
        if let profileId = profile?.id {
            dictionary.updateValue(profileId, forKey: Keys.qualityProfileId)
        } else {
            dictionary.updateValue(1, forKey: Keys.qualityProfileId)
        }

        dictionary.updateValue(titleSlug, forKey: Keys.titleSlug)
        
        if let seasons = seasons, seasons.count > 0 {
            dictionary.updateValue(seasons.toDictionary(), forKey: Keys.seasons)
        }
        
        if let images = images, images.count > 0 {
            dictionary.updateValue(images.toDictionary(), forKey: Keys.images)
        }
        
        if let path = path {
            dictionary.updateValue(path, forKey: Keys.path)
        }

        return dictionary
    }
}

