/******************************************************************************
 *
 * Series
 *
 ******************************************************************************/

import SwiftyJSON
import AFDateHelper

public final class Series: BaseSeries {

    internal struct Keys {
        static let alternateTitles = "alternateTitles"
        static let sortTitle = "sortTitle"
        static let seasonCount = "seasonCount"
        static let totalEpisodeCount = "totalEpisodeCount"
        static let episodeCount = "episodeCount"
        static let episodeFileCount = "episodeFileCount"
        static let sizeOnDisk = "sizeOnDisk"
        static let previousAiring = "previousAiring"
        static let nextAiring = "nextAiring"
        static let airTime = "airTime"
        static let monitored = "monitored"
        static let profileId = "profileId"
        static let seasonFolder = "seasonFolder"
        static let useSceneNumbering = "useSceneNumbering"
        static let tvRageId = "tvRageId"
        static let tvMazeId = "tvMazeId"
        static let seriesType = "seriesType"
        static let cleanTitle = "cleanTitle"
        static let imdbId = "imdbId"
        static let genres = "genres"
        static let tags = "tags"
        static let ratings = "ratings"
        static let added = "added"
        static let runtime = "runtime"
        static let id = "id"
    }

    public let seasonCount: Int
    public let profileId: Int
    public let runtime: Int
    public let nextAiring: Date?
    public let id: Int
    public let airTime: Date?
    public let alternateTitles: [String]
    public let sortTitle: String
    public let totalEpisodeCount: Int
    public let episodeCount: Int
    public let episodeFileCount: Int
    public let sizeOnDisk: Int
    public let previousAiring: String?
    public let monitored: Bool
    public let seasonFolder: Bool
    public let useSceneNumbering: Bool
    public let tvRageId: Int
    public let tvMazeId: Int
    public let seriesType: String
    public let cleanTitle: String
    public let imdbId: String
    public let genres: [String]
    public let tags: [String]
    public let added: Date
    public let ratings: [String: Any]

    override init?(json: JSON?) {

        guard let json = json else {
            return nil
        }

        guard let id = json[Keys.id].int,
            let sortTitle = json[Keys.sortTitle].string,
            let totalEpisodeCount = json[Keys.totalEpisodeCount].int,
            let episodeCount = json[Keys.episodeCount].int,
            let episodeFileCount = json[Keys.episodeFileCount].int,
            let sizeOnDisk = json[Keys.sizeOnDisk].int,
            let monitored = json[Keys.monitored].bool,
            let seasonFolder = json[Keys.seasonFolder].bool,
            let useSceneNumbering = json[Keys.useSceneNumbering].bool,
            let tvRageId = json[Keys.tvRageId].int,
            let tvMazeId = json[Keys.tvMazeId].int,
            let seriesType = json[Keys.seriesType].string,
            let cleanTitle = json[Keys.cleanTitle].string,
            let imdbId = json[Keys.imdbId].string,
            let profileId = json[Keys.profileId].int

        else {
            return nil
        }

        guard let alternateTitles = json[Keys.alternateTitles].arrayObject as? [String] else {
            return nil
        }

        guard let genres = json[Keys.genres].arrayObject as? [String] else {
            return nil
        }

        guard let tags = json[Keys.tags].arrayObject as? [String] else {
            return nil
        }

        guard let added = json[Keys.added].string else {
            return nil
        }

        guard let ratings = json[Keys.ratings].dictionaryObject else {
            return nil
        }

        guard let seasonCount = json[Keys.seasonCount].int else {
            return nil
        }

        guard let runtime = json[Keys.runtime].int else {
            return nil
        }
        
        self.sortTitle = sortTitle
        self.totalEpisodeCount = totalEpisodeCount
        self.episodeCount = episodeCount
        self.episodeFileCount = episodeFileCount
        self.sizeOnDisk = sizeOnDisk
        self.monitored = monitored
        self.seasonFolder = seasonFolder
        self.useSceneNumbering = useSceneNumbering
        self.tvRageId = tvRageId
        self.tvMazeId = tvMazeId
        self.seriesType = seriesType
        self.cleanTitle = cleanTitle
        self.imdbId = imdbId
        self.alternateTitles = alternateTitles
        self.genres = genres
        self.tags = tags

        if let addedDate = Date(fromString: added, format: .custom(DefaultValueKey.SonarrDateFormatString)) {
            self.added = addedDate
        } else {
            self.added = Date()
        }
        self.ratings = ratings
        self.seasonCount = seasonCount
        self.runtime = runtime
        self.id = id
        
        self.previousAiring = json[Keys.previousAiring].string

        if let airTime = json[Keys.airTime].string {
            self.airTime = Date(fromString: airTime, format: .custom("ha"))
        } else {
            airTime = nil
        }

        if let nextAiring = json[Keys.nextAiring].string {
            self.nextAiring = Date(fromString: nextAiring, format: .custom(DefaultValueKey.SonarrDateFormatString))
        }
        else {
            self.nextAiring = Date.distantFuture
        }
        
        self.profileId = profileId

        super.init(json: json)
    }
}

extension Series {
    
    public func nextAirDateString() -> String {
        guard let date = nextAiring else {
            return ""
        }
        
        if date.compare(.isToday) {
            return "\(date.toString(format: .custom("h:mm a"), timeZone: .local))"
        } else if date.compare(.isThisWeek) {
            return date.toString(style: .shortWeekday)
        } else if date.compare(.isNextWeek) {
            if date.toString(style: .shortWeekday) == "Sun" {
                return "\(date.toString(style: .shortWeekday)) at \(date.toString(format: .custom("h:mm a"), timeZone: .local))"
            } else {
                return "Next \(date.toString(style: .shortWeekday)) at \(date.toString(format: .custom("h:mm a"), timeZone: .local))"
            }
        } else if date.compare(.isThisYear) {
            return "Next Episode: \(date.toString(style: .shortMonth)) \(date.toString(format: .custom("dd")))\(date.daySuffix()) at \(date.toString(format: .custom("h:mm a"), timeZone: .local))"
        } else if date == Date.distantFuture {
            return "Next Episode: N/A"
        } else {
            return "Next Episode: \(date.toString(format: .custom("MMM dd yyyy, h:mm a"), timeZone: .local))"
        }
    }
}
