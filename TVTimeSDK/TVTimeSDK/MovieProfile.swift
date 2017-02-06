/******************************************************************************
 *
 * MovieProfile
 *
 ******************************************************************************/

import SwiftyJSON

public final class MovieProfile: BaseCouchPotatoObject {

    fileprivate struct Keys {
        static let label = "label"
    }

    public let title: String

    override init?(json: JSON?) {

        guard let json = json, let title = json[Keys.label].string else {
            return nil
        }

        self.title = title
        
        super.init(json: json)
    }
}
