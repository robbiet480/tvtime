/******************************************************************************
 *
 * Movie
 *
 ******************************************************************************/

import SwiftyJSON

public final class Movie {

    public enum Status: String {
        case active = "active"
        case done = "done"
    }
    
    public enum ImageType: String {
        case poster = "poster"
        case backdrop = "backdrop"
    }

    fileprivate struct Keys {
        static let status = "status"
        static let info = "info"
        static let plot = "plot"
        static let tagline = "tagline"
        static let title = "title"
        static let profileId = "profile_id"
        static let images = "images"
        static let poster = "poster"
        static let backdrop = "backdrop"
        static let year = "year"
        static let imdb = "imdb"
        static let original_title = "original_title"
        static let id = "_id"
    }

    public let status: String
    public let plot: String
    public let title: String
    public let year: Int
    public let tagline: String?
    public let posters: [String]?
    public let backdrops: [String]?
    public let imdb: String?
    public let id: String?
    public let profile: MovieProfile?

    init?(json: JSON?, isSearch: Bool = false) {

        guard let json = json else {
            return nil
        }

        if isSearch {
            guard let title = json[Keys.original_title].string,
                let year = json[Keys.year].int,
                let plot = json[Keys.plot].string else {
                    return nil
            }

            self.title = title
            self.year = year
            self.plot = plot
            
            tagline = nil
            id = nil
            profile = nil
            
            if let backdrops = json[Keys.images][Keys.backdrop].arrayObject as? [String], backdrops.count > 0 {
                self.backdrops = backdrops
            } else {
                backdrops = nil
            }

            if let posters = json[Keys.images][Keys.poster].arrayObject as? [String], posters.count > 0 {
                self.posters = posters
            } else {
                posters = nil
            }

            imdb = json[Keys.imdb].string
            
            status = ""
        } else {
            guard let title = json[Keys.title].string,
                let year = json[Keys.info][Keys.year].int,
                let plot = json[Keys.info][Keys.plot].string,
                let tagline = json[Keys.info][Keys.tagline].string,
                let status = json[Keys.status].string,
                let id = json[Keys.id].string else {
                    return nil
            }

            self.status = status
            self.id = id
            self.title = title
            self.year = year
            self.plot = plot
            self.tagline = tagline

            if let profileId = json[Keys.profileId].string {
                profile = Media.movieProfile(profileId)
            } else {
                profile = nil
            }

            if let backdrops = json[Keys.info][Keys.images][Keys.backdrop].arrayObject as? [String], backdrops.count > 0 {
                self.backdrops = backdrops
            } else {
                backdrops = nil
            }

            if let posters = json[Keys.info][Keys.images][Keys.poster].arrayObject as? [String], posters.count > 0 {
                self.posters = posters
            } else {
                posters = nil
            }

            imdb = json[Keys.info][Keys.imdb].string
        }
    }
}

public extension Movie {
    public func imageUrl(_ type: ImageType) -> URL? {

        var url: URL? = nil

        switch type {
        case .poster:
            if let poster = posters?.first {
                url = URL(string: poster)
            }
        case .backdrop:
            if let backdrop = backdrops?.first {
                url = URL(string: backdrop)
            }
        }

        return url
    }
}
