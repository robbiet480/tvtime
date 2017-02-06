/******************************************************************************
 *
 * SeriesImage
 *
 ******************************************************************************/

import SwiftyJSON

public final class SeriesImage {

    fileprivate struct Keys {
        static let coverType = "coverType"
        static let url = "url"
    }
    
    public enum ImageType: String {
        case fanart = "fanart"
        case banner = "banner"
        case poster = "poster"
    }
    

    let coverType: ImageType
    let urlString: String
    
    init?(json: JSON?) {
        guard let json = json else {
            return nil
        }
        
        guard let coverTypeString = json[Keys.coverType].string, let coverType = ImageType(rawValue: coverTypeString),
            let urlString = json[Keys.url].string else {
                return nil
        }
        
        self.coverType = coverType
        self.urlString = urlString
    }
}

extension SeriesImage: DictionaryRepresentationProtocol {
    
    public func toDictionary() -> [String : Any] {
        var dictionary: [String: Any] = [:]

        dictionary.updateValue(coverType.rawValue, forKey: Keys.coverType)
        dictionary.updateValue(urlString, forKey: Keys.url)
        
        return dictionary
    }
}
