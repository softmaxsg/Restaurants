//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

enum Result<Value> {

    case success(Value)
    case failure(Error)
    
}

extension Result {

    public init(value: Value) {
        self = .success(value)
    }
    
    public init(error: Error) {
        self = .failure(error)
    }
    
    var value: Value? {
        switch self {
        case .success(let value): return value
        case .failure: return nil
        }
    }
    
    var error: Error? {
        switch self {
        case .success: return nil
        case .failure(let error): return error
        }
    }
    
    func map<T>(_ transform: (Value) throws -> T) rethrows -> Result<T> {
        switch self {
        case .success(let value): return .success(try transform(value))
        case .failure(let error): return .failure(error)
        }
    }
    
}
