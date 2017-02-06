/******************************************************************************
 *
 * URLRequest+Extensions
 *
 ******************************************************************************/

internal extension URLRequest {

    mutating func setPostHeaders() {
        setValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
        setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        setValue("en-US,en;q=0.8", forHTTPHeaderField: "Accept-Language")
    }

    mutating func addHeaders(_ headers: [String: String]) {
        for (key, value) in headers {
            setValue(value, forHTTPHeaderField: key)
        }
    }
}
