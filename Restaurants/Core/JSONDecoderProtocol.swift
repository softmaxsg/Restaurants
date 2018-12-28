//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol JSONDecoderProtocol {
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
    
}

extension JSONDecoder: JSONDecoderProtocol { }
