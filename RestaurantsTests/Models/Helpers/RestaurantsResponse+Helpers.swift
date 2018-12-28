//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

extension RestaurantsResponse {
    
    static func random() -> RestaurantsResponse {
        return RestaurantsResponse(
            restaurants: Array(0...Int.random(in: 0...10)).map { _ in .random() }
        )
    }
    
}

extension RestaurantsResponse: JSONPresentable {
    
    func JSON() -> [String: Any] {
        return [
            "restaurants": restaurants.map { $0.JSON() }
        ]
    }
    
}
