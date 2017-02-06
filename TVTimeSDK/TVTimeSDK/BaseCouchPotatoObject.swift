/******************************************************************************
 *
 * BaseCouchPotatoObject
 *
 ******************************************************************************/

import SwiftyJSON

public class BaseCouchPotatoObject {
    
    fileprivate struct Keys {
        static let id = "_id"
    }

    public let id: String
    
    init?(json: JSON?) {
        
        guard let json = json, let id = json[Keys.id].string else {
            return nil
        }
        
        self.id = id
    }
}
