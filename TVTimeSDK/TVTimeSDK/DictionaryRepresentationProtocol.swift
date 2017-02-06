/******************************************************************************
 *
 * DictionaryRepresentationProtocol
 *
 ******************************************************************************/

import Foundation

public protocol DictionaryRepresentationProtocol {
    func toDictionary() -> [String: Any]
}
