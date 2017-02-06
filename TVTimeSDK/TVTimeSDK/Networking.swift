/******************************************************************************
 *
 * Networking
 *
 ******************************************************************************/

import Foundation
import Alamofire
import SwiftyJSON

public final class Networking {
    
    //MARK: Public Variables
    public enum Product: String {
        case couchPotato = "CouchPotato"
        case sonarr = "Sonarr"
        case nzbget = "NZBGet"
        case headphones = "Headphones"
        
        func hostURL() -> String? {
            
            guard let defaults = Networking.userDefaults() else {
                return nil
            }
            
            switch self {
            case .couchPotato:
                return String(format:"%@/api/%@", defaults.cpHost, defaults.cpApi)
            case .sonarr:
                return defaults.sonarrHost
            case .nzbget:
                return defaults.nzbGetHost
            case .headphones:
                return "" // String(format:"%@/api?apikey=%@", URLs.headphones, APIKeys.headphones)
            }
        }
    }
    
    public static let ReachableViaWiFiNotification = Notification.Name("ReachableViaWiFiNotification")
    public static let DoneConfiguringSonarr = Notification.Name("DoneConfiguringSonarr")
    public static let DoneConfiguringCouchPotato = Notification.Name("DoneConfiguringCouchPotato")
    public static let ErrorConfiguringSonarr = Notification.Name("ErrorConfiguringSonarr")
    public static let ErrorConfiguringCouchPotato = Notification.Name("ErrorConfiguringCouchPotato")
    public static let NeedsSetup = Notification.Name("NeedsSetup")
    
    // MARK: - Private Variables
    fileprivate static var sonarrRootFolder = ""

    fileprivate struct Headers {
        static let xApiKey = "X-Api-Key"
        static let authorization = "Authorization"
    }
    
    fileprivate struct Keys {
        static let list = "list"
        static let movies = "movies"
        static let success = "success"
        static let movie = "movie"
        static let path = "path"
        static let rootFolderPath = "rootFolderPath"
        static let title = "title"
    }
    
    
    fileprivate struct ServiceKeys {
        struct CouchPotato {
            static let movieListKey = "movieList"
            static let addMovieKey = "movieAdd"
            static let deleteMovieKey = "movieDelete"
            static let editMovieKey = "movieEdit"
            static let searchMoviesKey = "movieSearch"
            static let qualitiesKey = "profileList"
        }
        
        struct Sonarr {
            fileprivate static let profileKey = "profile"
            fileprivate static let statusKey = "status"
            fileprivate static let seriesKey = "series"
            fileprivate static let seriesIdKey = "seriesId"
            fileprivate static let seriesDeleteKey = "seriesDelete"
            fileprivate static let searchSeriesKey = "lookup"
            fileprivate static let rootFolderKey = "rootfolder"
        }
        
        struct NZBGet {
            fileprivate static let jsonRPC = "jsonrpc"
            fileprivate static let method = "method"
            fileprivate static let params = "params"
            
            struct Methods {
                fileprivate static let listGroups = "listgroups"
                fileprivate static let listFiles = "listfiles"
                fileprivate static let editQueue = "editqueue"
            }
            
            struct Commands {
                fileprivate static let pause = "GroupPause"
                fileprivate static let resume = "GroupResume"
                fileprivate static let delete = "GroupDelete"
            }
        }
    }
    
    fileprivate static let ServerPaths = [
        ServiceKeys.CouchPotato.movieListKey: "/movie.list?status=%@",
        ServiceKeys.CouchPotato.addMovieKey: "/movie.add?title=%@&identifier=%@",
        ServiceKeys.CouchPotato.deleteMovieKey: "/movie.delete?id=%@",
        ServiceKeys.CouchPotato.editMovieKey: "/movie.edit?id=%@&profile_id=%@",
        ServiceKeys.CouchPotato.searchMoviesKey: "/movie.search?q=%@",
        ServiceKeys.CouchPotato.qualitiesKey: "/profile.list",
        ServiceKeys.Sonarr.profileKey: "/api/profile",
        ServiceKeys.Sonarr.statusKey: "/api/system/status",
        ServiceKeys.Sonarr.searchSeriesKey: "/api/series/lookup?term=%@",
        ServiceKeys.Sonarr.seriesKey: "/api/series",
        ServiceKeys.Sonarr.seriesIdKey: "/api/series/%@",
        ServiceKeys.Sonarr.seriesDeleteKey: "/api/series/%@",
        ServiceKeys.Sonarr.rootFolderKey: "/api/rootfolder",
        ServiceKeys.NZBGet.jsonRPC: "/jsonrpc"
    ]
    
    fileprivate static let availabelAndSnatched = "release_status=snatched,available"
    fileprivate static let reachability = NetworkReachabilityManager()

    // MARK: Sonarr Methods
    
    internal static func setupSonarr(_ success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        fetchSonarrRootFolder({ (folder) in
            sonarrRootFolder = folder
            fetchSonarrQualityProfiles({ (profiles) in
                Media.allSeriesProfiles = profiles
            }, failure: failure)
        }, failure: failure)
    }
    
    fileprivate static func fetchSonarrRootFolder(_ success: ((String) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (json: JSON) -> Any? in
            let rootFolder = json.arrayValue.flatMap({ $0[Keys.path].stringValue }).first
            return rootFolder
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! String)
            }
        }
        
        performGetRequest(.sonarr, key: ServiceKeys.Sonarr.rootFolderKey, parameters: nil, parse: parseBlock, success: successBlock, failure: failure)
    }
    
    fileprivate static func fetchSonarrQualityProfiles(_ success: (([SeriesQualityProfile]) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (json: JSON) -> Any? in
            let profiles = json.array?.flatMap({ SeriesQualityProfile(json: $0) })
            
            return profiles
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! [SeriesQualityProfile])
            }
        }
        
        performGetRequest(.sonarr, key: ServiceKeys.Sonarr.profileKey, parameters: nil, parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func add(_ seriesSearchResult: DictionaryRepresentationProtocol, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (json: JSON) -> Any? in
            return true
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Bool)
            }
        }
        
        do {
            var dictionary = seriesSearchResult.toDictionary()
            dictionary.updateValue(sonarrRootFolder, forKey: Keys.rootFolderPath)
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            performPostRequest(.sonarr, key: ServiceKeys.Sonarr.seriesKey, parameters: nil, postBody: jsonData, parse: parseBlock, success: successBlock, failure: failure)
            
        } catch let error {
            if let failure = failure {
                failure(error)
            }
        }
    }
    
    public static func series(_ sortType: Media.SeriesSortType?, success: (([Series]) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (json: JSON) -> Any? in
            let series = json.array?.flatMap({ Series(json: $0) })
            
            if let series = series {
                if let sortType = sortType {
                    return Media.sort(series, sortType: sortType)
                } else {
                    return series
                }
            } else {
                return nil
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! [Series])
            }
        }
        
        performGetRequest(.sonarr, key: ServiceKeys.Sonarr.seriesKey, parameters: nil, parse: parseBlock, success: successBlock, failure: failure)
        
    }
    
    public static func search(_ term: String, success: (([SeriesSearchResult]) -> Void)?, failure: @escaping ((Error) -> ())) {
        
        let parseBlock = { (json: JSON) -> Any? in
            let results = json.array?.flatMap { SeriesSearchResult(json: $0) }
            
            if let results = results {
                return results
            } else {
                return [SeriesSearchResult]()
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! [SeriesSearchResult])
            }
        }
        
        performGetRequest(.sonarr, key: ServiceKeys.Sonarr.searchSeriesKey, parameters: [term], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func delete(_ series: Series, deleteFiles: Bool = true, success: ((Bool) -> Void)?, failure: ((Error) -> ())?) {
        
        let parseBlock = { (json: JSON) -> Any? in
            
            if json.error == nil {
                return true
            }
            return false
        }
        
        let completionBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Bool)
            }
        }
        
        let params =  [String(series.id), "deleteFiles=\(deleteFiles)"]
        
        performDeleteRequest(.sonarr, key: ServiceKeys.Sonarr.seriesDeleteKey, parameters: params, postBody: nil, parse: parseBlock, success: completionBlock, failure: failure)
    }
    
    public static func update(_ seriesId: Int, putBody: DictionaryRepresentationProtocol, success: ((Series) -> Void)?, failure: ((Error) -> ())?) {
        
        let parseBlock = { (json: JSON) -> Any? in
            
            return Series(json: json)
        }
        
        let completionBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Series)
            }
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: putBody.toDictionary(), options: JSONSerialization.WritingOptions.prettyPrinted)
            performPutRequest(.sonarr, key: ServiceKeys.Sonarr.seriesIdKey, parameters: [String(seriesId)], putBody: jsonData, parse: parseBlock, success: completionBlock, failure: failure)
            
        } catch {
            if let failure = failure {
                let error = NSError(domain: "TVTimeSDK", code: 99, userInfo: nil)
                failure(error)
            }
        }
    }
    
    // MARK: CouchPotato Methods
    public static func search(_ term: String, sortType: Media.MovieSortType?, success: (([Movie]) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (json: JSON) -> Any? in
            let movies = json[Keys.movies].array?.flatMap { Movie(json: $0, isSearch: true) }
            
            if let movies = movies {
                if let sortType = sortType {
                    return Media.sort(movies, sortType: sortType)
                } else {
                    return movies
                }
            } else {
                return [Movie]()
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! [Movie])
            } else {
                if let failure = failure {
                    failure(NSError(domain: "TVTimeSDK", code: 99, userInfo: [NSLocalizedDescriptionKey : "No movie results found"]))
                }
            }
        }
        
        performGetRequest(.couchPotato, key: ServiceKeys.CouchPotato.searchMoviesKey, parameters: [term], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func add(_ movie: Movie, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (json: JSON) -> Any? in
            let result = json[Keys.success].bool
            
            return result
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Bool)
            }
        }
        
        var imdb = ""
        if let foo = movie.imdb {
            imdb = foo
        }
        performGetRequest(.couchPotato, key: ServiceKeys.CouchPotato.addMovieKey, parameters: [movie.title, imdb], parse: parseBlock, success: successBlock, failure: failure)
    }
        
    public static func update(_ movie: MovieMutable, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (json: JSON) -> Any? in
            let result = json[Keys.success].bool
            
            return result
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Bool)
            }
        }
        
        performGetRequest(.couchPotato, key: ServiceKeys.CouchPotato.editMovieKey, parameters: [movie.id, movie.profile.id], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func delete(_ movie: Movie, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (json: JSON) -> Any? in
            let result = json[Keys.success].bool
            
            return result
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! Bool)
            }
        }
        
        guard let movieId = movie.id else {
            
            let error = NSError(domain: "", code: 99, userInfo: [NSLocalizedDescriptionKey : "Movie Id is nil"])
            
            if let failure = failure {
                failure(error)
            }
            
            return
        }
        
        performGetRequest(.couchPotato, key: ServiceKeys.CouchPotato.deleteMovieKey, parameters: [movieId], parse: parseBlock, success: successBlock, failure: failure)
    }
    
    public static func movies(_ status: Movie.Status, sortType: Media.MovieSortType?, expandSnatchedAndAvailable: Bool = false, success: (([Movie]) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (json: JSON) -> Any? in
            let movies = json[Keys.movies].array?.flatMap { Movie(json: $0) }
            
            if let movies = movies {
                if let sortType = sortType {
                    return Media.sort(movies, sortType: sortType)
                } else {
                    return movies
                }
            } else {
                return nil
            }
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! [Movie])
            }
        }
        
        var parameters = [Movie.Status.active.rawValue]
        
        if expandSnatchedAndAvailable {
            parameters.append(availabelAndSnatched)
        }

        performGetRequest(.couchPotato, key: ServiceKeys.CouchPotato.movieListKey, parameters: parameters, parse: parseBlock, success: successBlock, failure: failure)
        
    }
    
    static func setupCouchPotato(_ success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        fetchCPQualityProfiles({ (profiles) in
            Media.allMovieProfiles = profiles
        }, failure: failure)
    }
    
    static func fetchCPQualityProfiles(_ success: (([MovieProfile]) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (json: JSON) -> Any? in
            let profiles = json[Keys.list].array?.flatMap { MovieProfile(json: $0) }
            return profiles
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! [MovieProfile])
            }
        }
        
        performGetRequest(.couchPotato, key: ServiceKeys.CouchPotato.qualitiesKey, parameters: nil, parse: parseBlock, success: successBlock, failure: failure)
        
    }
    
    //MARK: NZBGet methods
    public static func queue(_ success: (([NZBQueueItem]) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (json: JSON) -> Any? in
            let items = json["result"].array?.flatMap({ NZBQueueItem(json: $0) })
            return items
        }
        
        let successBlock = { (results: Any?) -> Void in
            if let success = success {
                success(results as! [NZBQueueItem])
            }
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: [ServiceKeys.NZBGet.method : ServiceKeys.NZBGet.Methods.listGroups], options: JSONSerialization.WritingOptions.prettyPrinted)
            performPostRequest(.nzbget, key: ServiceKeys.NZBGet.jsonRPC, parameters: nil, postBody: jsonData, parse: parseBlock, success: successBlock, failure: failure)
            
        } catch let error {
            if let failure = failure {
                failure(error)
            }
        }
    }
    
    public static func pause(_ queueItem: NZBQueueItem, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (json: JSON) -> Any? in
            let result = json["result"].bool
            return result
        }
        
        let successBlock = { (result: Any) -> Void in
            if let success = success {
                success(result as! Bool)
            }
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: [ServiceKeys.NZBGet.method : ServiceKeys.NZBGet.Methods.editQueue, ServiceKeys.NZBGet.params : [ServiceKeys.NZBGet.Commands.pause, 0, "", [queueItem.id]]], options: JSONSerialization.WritingOptions.prettyPrinted)
            performPostRequest(.nzbget, key: ServiceKeys.NZBGet.jsonRPC, parameters: nil, postBody: jsonData, parse: parseBlock, success: successBlock, failure: failure)
            
        } catch let error {
            if let failure = failure {
                failure(error)
            }
        }
    }

    public static func resume(_ queueItem: NZBQueueItem, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (json: JSON) -> Any? in
            let result = json["result"].bool
            return result
        }
        
        let successBlock = { (result: Any) -> Void in
            if let success = success {
                success(result as! Bool)
            }
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: [ServiceKeys.NZBGet.method : ServiceKeys.NZBGet.Methods.editQueue, ServiceKeys.NZBGet.params : [ServiceKeys.NZBGet.Commands.resume, 0, "", [queueItem.id]]], options: JSONSerialization.WritingOptions.prettyPrinted)
            performPostRequest(.nzbget, key: ServiceKeys.NZBGet.jsonRPC, parameters: nil, postBody: jsonData, parse: parseBlock, success: successBlock, failure: failure)
            
        } catch let error {
            if let failure = failure {
                failure(error)
            }
        }
    }

    public static func delete(_ queueItem: NZBQueueItem, success: ((Bool) -> Void)?, failure: ((Error) -> Void)?) {
        
        let parseBlock = { (json: JSON) -> Any? in
            let result = json["result"].bool
            return result
        }
        
        let successBlock = { (result: Any) -> Void in
            if let success = success {
                success(result as! Bool)
            }
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: [ServiceKeys.NZBGet.method : ServiceKeys.NZBGet.Methods.editQueue, ServiceKeys.NZBGet.params : [ServiceKeys.NZBGet.Commands.delete, 0, "", [queueItem.id]]], options: JSONSerialization.WritingOptions.prettyPrinted)
            performPostRequest(.nzbget, key: ServiceKeys.NZBGet.jsonRPC, parameters: nil, postBody: jsonData, parse: parseBlock, success: successBlock, failure: failure)
            
        } catch let error {
            if let failure = failure {
                failure(error)
            }
        }
    }

    //MARK: Generic methods
    
    fileprivate static func performGetRequest(_ product: Product, key: String, parameters: [String]?, headers: [String: String]? = nil, requireToken: Bool = true, parse: @escaping (JSON) -> Any?, success: ((Any?) -> Void)?, failure: ((Error) -> Void)?) {
        
        performRequest(product, method: .get, key: key, parameters: parameters, headers: headers, requireToken: requireToken, postBody: nil,
                       parse: parse, success: success, failure: failure)
    }
    
    fileprivate static func performPostRequest(_ product: Product, key: String, parameters: [String]?, postBody: Data?,
                                               parse: @escaping (JSON) -> Any?, success: ((Any?) -> Void)?, failure: ((Error) -> Void)?) {
        
        performRequest(product, method: .post, key: key, parameters: parameters, postBody: postBody,
                       parse: parse, success: success, failure: failure)
    }
    
    fileprivate static func performPutRequest(_ product: Product, key: String, parameters: [String]?, putBody: Data?,
                                              parse: @escaping (JSON) -> Any?, success: ((Any?) -> Void)?, failure: ((Error) -> Void)?) {
        
        performRequest(product, method: .put, key: key, parameters: parameters, postBody: putBody,
                       parse: parse, success: success, failure: failure)
    }
    
    fileprivate static func performDeleteRequest(_ product: Product, key: String, parameters: [String]?, postBody: Data? = nil,
                                                 parse: @escaping (JSON) -> Any?, success: ((Any?) -> Void)?, failure: ((Error) -> Void)?) {
        
        performRequest(product, method: .delete, key: key, parameters: parameters, postBody: postBody,
                       parse: parse, success: success, failure: failure)
    }
    
    fileprivate static func performRequest(_ product: Product, method: HTTPMethod, key: String, parameters: [String]?, headers: [String: String]? = nil, requireToken: Bool = true, postBody: Data?,
                                           parse: @escaping (JSON) -> Any?, success: ((Any?) -> Void)?, failure: ((Error) -> Void)?) {
        
        guard let url = getURLFor(product, key: key, parameters: parameters), let defaults = userDefaults() else {
            return
        }
        
        print(url.absoluteString)
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        request.timeoutInterval = defaults.timeout
        
        if method == .post || method == .put {
            request.setPostHeaders()
            if let postBody = postBody {
                request.httpBody = postBody
                print(String(data: postBody, encoding: .utf8)!)
            }
        } else if method == .get {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        // Add optional headers
        if let headers = headers {
            request.addHeaders(headers)
        }
        
        addTrackingHeaders(product, request: &request)
        addBasicAuthentication(product, request: &request)
        
        
        Alamofire.request(request).validate().responseJSON { response in
            
            switch response.result {
            case .success:
                
                guard let value = response.result.value,
                    let results = parse(JSON(value)) else {
                    let error = NSError(domain: "", code: 99, userInfo: [NSLocalizedDescriptionKey : "Invalid JSON response object"])
                    
                    if let failure = failure {
                        failure(error)
                    }
                    
                    return
                }
                
                if let success = success {
                    success(results)
                }
                
            case .failure(let error):
                
                if let failure = failure {
                    failure(error)
                }
            }
        }
    }
}
// MARK: - Helper methods
public extension Networking {
    
    public static func startWiFiDetection(reachableBlock: ((Void) -> Void)?, notReachableBlock: ((Void) -> Void)?) {
        
        if areUserDefaultsSet() {
            reachability?.listener = { (status) in
                if status == .reachable(.ethernetOrWiFi) || status == .reachable(.wwan){
                    
                    if Media.allSeriesProfiles.count == 0 {
                        setupSonarr({ (success) in
                            print(success)
                        }) { (error) in
                            DispatchQueue.main.async(execute: {
                                NotificationCenter.default.post(name: ErrorConfiguringSonarr, object: nil)
                            })
                        }
                    }
                    
                    if Media.allMovieProfiles.count == 0 {
                        setupCouchPotato({ (success) in
                            print(success)
                        }) { (error) in
                            DispatchQueue.main.async(execute: {
                                NotificationCenter.default.post(name: ErrorConfiguringCouchPotato, object: nil)
                            })
                        }
                    }
                    
                    DispatchQueue.main.async(execute: {
                        NotificationCenter.default.post(name: ReachableViaWiFiNotification, object: nil)
                        
                        if let reachableBlock = reachableBlock {
                            reachableBlock()
                        }
                    })
                } else if status == .notReachable {
                    
                    if let notReachableBlock = notReachableBlock {
                        notReachableBlock()
                    }
                }
            }
            
            reachability?.startListening()
            
        } else {
            DispatchQueue.main.async(execute: {
                NotificationCenter.default.post(name: NeedsSetup, object: nil)
            })
        }
    }
    
    static func stopWiFiDetection() {
        reachability?.stopListening()
    }
    
    static func areUserDefaultsSet() -> Bool {
        
        guard let _ = userDefaults() else {
            return false
        }
        
        return true
    }
    
    //MARK: Private Utility Methods
    
    fileprivate static func getURLFor(_ product: Product, key: String, parameters: [String]?) -> URL? {
        guard let urlString = urlWithKey(product, key: key, parameters: parameters) else {
            return nil
        }
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        return url
    }
    
    fileprivate class func addTrackingHeaders(_ product: Product, request: inout URLRequest) {
        
        if let apiKeyHeader = getAPIKeyHeader(product) {
            request.addHeaders(apiKeyHeader)
        }
    }
    
    fileprivate class func addBasicAuthentication(_ product: Product, request: inout URLRequest) {
        
        if product == .nzbget {
            
            guard let defaults = userDefaults() else {
                return
            }
            
            if let authorizationHeader = Request.authorizationHeader(user: defaults.nzbGetUsername, password: defaults.nzbGetPassword) {
                request.setValue(authorizationHeader.value, forHTTPHeaderField: authorizationHeader.key)
            }
        }
    }
    
    fileprivate class func getAPIKeyHeader(_ product: Product) -> [String: String]? {
        var headers: [String: String]? = nil
        
        if product == .sonarr {
            
            guard let defaults = userDefaults() else {
                return nil
            }
            
            headers = [Headers.xApiKey: defaults.sonarrApi]
        } else {
            print("x-api-key is not set")
        }
        
        return headers
    }
    
    public static func userDefaults() -> (sonarrHost: String, sonarrApi: String, cpHost: String, cpApi: String, nzbGetHost: String, nzbGetUsername: String, nzbGetPassword: String, timeout: Double)? {
        
        guard let sonarrHost = UserDefaults.standard.string(forKey: DefaultsKeys.Sonarr.host),
            let sonarrApi = UserDefaults.standard.string(forKey: DefaultsKeys.Sonarr.api),
            let cpHost = UserDefaults.standard.string(forKey: DefaultsKeys.CouchPotato.host),
            let cpApi = UserDefaults.standard.string(forKey: DefaultsKeys.CouchPotato.api),
            let nzbgetHost = UserDefaults.standard.string(forKey: DefaultsKeys.NZBGet.host),
            let nzbUsername = UserDefaults.standard.string(forKey: DefaultsKeys.NZBGet.username),
            let nzbgetPassword = UserDefaults.standard.string(forKey: DefaultsKeys.NZBGet.password) else {
                return nil
        }
        
        var timeout = UserDefaults.standard.double(forKey: DefaultsKeys.Networking.timeout)
        
        if timeout == 0 {
            timeout = 30
        }
        
        return (sonarrHost, sonarrApi, cpHost, cpApi, nzbgetHost, nzbUsername, nzbgetPassword, timeout)
    }
    
    fileprivate static func pathAndQueryWithKey(_ key: String, parameters: [String]?) -> String? {
        var pathAndQuery: String?
        var pathDictonary = ServerPaths
        
        if let baseURLString = pathDictonary[key] {
            if let parameters = parameters {
                var tempString = baseURLString
                
                for param in parameters {
                    
                    if tempString.contains("%@") {
                        tempString = tempString.replacingCharacters(in: tempString.range(of: "%@")!, with: param)
                    } else {
                        tempString = String(format: "%@&%@", tempString, param)
                    }
                    
                }
                
                pathAndQuery = tempString
                
            }
            else {
                pathAndQuery = baseURLString
            }
        }
        
        return pathAndQuery
    }
    
    fileprivate static func urlWithKey(_ product: Product, key: String, parameters: [String]? = nil) -> String? {
        let encodedParamters = parameters?.flatMap { $0.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) }
        
        guard let parameters = pathAndQueryWithKey(key, parameters: encodedParamters), let hostUrl = product.hostURL() else {
            return nil
        }
        
        return hostUrl + parameters
    }
}
