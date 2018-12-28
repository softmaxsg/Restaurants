//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

enum JSONEncoderError: Error { case unknown }

extension JSONEncoder {
    
    open func encodeToJSON<T>(_ value: T) throws -> [String: Any] where T : Encodable {
        let data = try encode(value)
        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw JSONEncoderError.unknown
        }
        
        return jsonObject
    }
    
}
