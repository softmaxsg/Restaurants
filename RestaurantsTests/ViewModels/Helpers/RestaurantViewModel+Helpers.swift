//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

extension RestaurantViewModelProtocol {
    
    func isEqual(to restaurant: Restaurant) -> Bool {
        return true
    }
    
}

public func == (lhs: RestaurantViewModelProtocol, rhs: Restaurant) -> Bool {
    return lhs.isEqual(to: rhs)
}

public func == (lhs: Restaurant, rhs: RestaurantViewModelProtocol) -> Bool {
    return rhs.isEqual(to: lhs)
}
