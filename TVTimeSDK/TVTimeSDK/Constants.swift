/******************************************************************************
 *
 * Constants
 *
 ******************************************************************************/

struct DefaultValueKey {
    static let SonarrDateFormatString = "yyyy-MM-dd'T'HH:mm:ssZ"
}

public struct DefaultsKeys {
    public struct Sonarr {
        public static let host = "sonarrHost"
        public static let api = "sonarrApi"
    }
    
    public struct CouchPotato {
        public static let host = "couchPotatoHost"
        public static let api = "couchPotatoApi"
    }
    
    public struct NZBGet {
        public static let host = "nzbGetHost"
        public static let username = "nzbGetUsername"
        public static let password = "nzbGetPassword"
    }
    
    public struct Networking {
        public static let timeout = "timeout"
    }
}



