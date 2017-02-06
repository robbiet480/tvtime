/******************************************************************************
 *
 * BaseSeries
 *
 ******************************************************************************/

import SwiftyJSON
import AFDateHelper

public class BaseSeries {
    
    internal struct Keys {
        static let title = "title"
        static let status = "status"
        static let overview = "overview"
        static let network = "network"
        static let year = "year"
        static let firstAired = "firstAired"
        static let poster = "poster"
        static let banner = "banner"
        static let fanart = "fanart"
        static let qualityProfileId = "qualityProfileId"
        static let tvdbId = "tvdbId"
        static let images = "images"
        static let coverType = "coverType"
        static let url = "url"
        static let titleSlug = "titleSlug"
        static let seasons = "seasons"
        static let path = "path"
    }
    
    public let title: String
    public let status: String
    public let overview: String
    public let network: String
    public let year: Int
    public let firstAired: Date
    public let profile: SeriesQualityProfile?
    public let tvdbId: Int
    public let titleSlug: String
    public let seasons: [Season]?
    public let path: String?
    public let images: [SeriesImage]?
    
    init?(json: JSON?) {
        
        guard let json = json else {
            return nil
        }
        
        guard let title = json[Keys.title].string,
            let status = json[Keys.status].string,
            let overview = json[Keys.overview].string,
            let network = json[Keys.network].string,
            let year = json[Keys.year].int,
            let tvdbId = json[Keys.tvdbId].int,
            let titleSlug = json[Keys.titleSlug].string
            else {
                return nil
        }
        
        self.title = title
        self.status = status
        self.overview = overview
        self.network = network
        self.year = year
        self.tvdbId = tvdbId
        self.titleSlug = titleSlug
        
        if let qualityProfileId = json[Keys.qualityProfileId].int, qualityProfileId > 0 {
            profile = Media.seriesProfile(qualityProfileId)
        } else {
            profile = nil
        }
        
        images = json[Keys.images].array?.flatMap({ SeriesImage(json: $0) })
        seasons = json[Keys.seasons].array?.flatMap({ Season(json: $0) })
        path = json[Keys.path].string
        
        if let firstAired = json[Keys.firstAired].string {
            self.firstAired = Date(fromString: firstAired, format: .custom(DefaultValueKey.SonarrDateFormatString))
            
        } else {
            self.firstAired = Date.distantPast
        }
    }
}

public extension BaseSeries {
    
    public func imageUrl(_ type: SeriesImage.ImageType) -> URL? {
        
        guard let images = images, let urlString = images.filter({ $0.coverType.rawValue == type.rawValue }).first?.urlString, let hostUrl = Networking.Product.hostURL(.sonarr)() else {
            return nil
        }
        
        return URL(string: hostUrl + urlString)
    }
}
