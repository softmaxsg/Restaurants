//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

extension RestaurantDetails {
    
    static func random(restaurant: Restaurant = .random(), isFavorite: Bool = .random()) -> RestaurantDetails {
        return RestaurantDetails(restaurant: restaurant, isFavorite: isFavorite)
    }
    
}
