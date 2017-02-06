/******************************************************************************
 *
 * Media
 *
 ******************************************************************************/

public final class Media {
    
    public enum MovieSortType {
        case name
        case year
    }
    
    public enum SeriesSortType {
        case name
        case airDate
    }
    
    public enum MonitorType: String {
        case all = "All"
        case none = "None"
        case future = "Future"
        case missing = "Missing"
        case existing = "Existing"
        case firstSeason = "First Season"
        case lastSeason = "Last Season"
        
        public static let allValues = [all, none, future, missing, existing, firstSeason, lastSeason]
    }
    
    public static var allMovieProfiles = [MovieProfile]() {
        didSet {
            DispatchQueue.main.async(execute: {
                NotificationCenter.default.post(name: Networking.DoneConfiguringCouchPotato, object: nil)
            })
        }
    }
    
    public static var allSeriesProfiles = [SeriesQualityProfile]() {
        didSet {
            DispatchQueue.main.async(execute: {
                NotificationCenter.default.post(name: Networking.DoneConfiguringSonarr, object: nil)
            })
        }
    }
    
    static func sort(_ movies: [Movie], sortType: MovieSortType) -> [Movie] {
        
        var newMovies = [Movie]()
        
        switch sortType {
        case .name:
            newMovies = movies.sorted(by: { $0.title.compare($1.title) == .orderedAscending })
        case .year:
            newMovies = movies.sorted(by: { $0.year < $1.year })
        }
        
        return newMovies
    }
    
    static func sort(_ series: [Series], sortType: SeriesSortType) -> [Series] {
        
        var newSeries = [Series]()
        
        switch sortType {
        case .name:
            newSeries = series.sorted(by: { $0.title.compare($1.title) == .orderedAscending })
        case .airDate:
            newSeries = series.sorted(by: {
                
                if let foo = $0.nextAiring, let bar = $1.nextAiring {
                    
                    if foo.compare(bar as Date) == .orderedAscending {
                        return true
                    }
                    
                    if foo.compare(bar as Date) == .orderedDescending {
                        return false
                    }
                    
                    if foo.compare(bar as Date) == .orderedSame {
                        return $0.title.compare($1.title) == .orderedAscending
                    }
                    
                    return false
                } else {
                    return false
                }
            })
        }
        
        return newSeries
    }
    
    static func movieProfile(_ id: String) -> MovieProfile {
        
        return allMovieProfiles.filter({ $0.id == id })[0]
    }
    
    static func indexOf(_ profile: MovieProfile) -> Int? {
        return allMovieProfiles.index(where: { $0.id == profile.id })
    }
    
    static func seriesProfile(_ id: Int) -> SeriesQualityProfile? {
        
        if let index = allSeriesProfiles.index(where: { $0.id == id }) {
            return allSeriesProfiles[index]
        }
        
        return nil
    }
    
    static func indexOf(_ profile: SeriesQualityProfile) -> Int? {
        if let index = allSeriesProfiles.index(where: { $0.id == profile.id }) {
            return index
        }
        
        return nil
    }
    
    static func monitorSeasons(_ seasons: [Season], type: MonitorType) {
        
        switch type {
        case .all:
            //            seasons.forEach({
            //                $0.monitored = true
            //            })
            break
        case .none:
            break
        case .future:
            break
        case .missing:
            break
        case .existing:
            break
        case .firstSeason:
            break
        case .lastSeason:
            break
        }
    }
    
}
