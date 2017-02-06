/******************************************************************************
 *
 * Array+Extensions
 *
 ******************************************************************************/

internal extension Array {
    func toDictionary() -> [[String : Any]] {
        
        var objects = [[String : Any]]()
        
        for object in self {
            
            if let dictionaryObject = object as? DictionaryRepresentationProtocol {
                objects.append(dictionaryObject.toDictionary())
            }
        }
        
        return objects
    }
}
