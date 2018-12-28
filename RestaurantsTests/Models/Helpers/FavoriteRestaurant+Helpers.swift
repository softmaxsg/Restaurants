//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

extension FavoriteRestaurant {
    
    static func random() -> FavoriteRestaurant {
        return FavoriteRestaurant(name: .random())
    }
    
}

extension FavoriteRestaurant: JSONPresentable {
    
    func JSON() -> [String: Any] {
        return ["name": name]
    }
    
}
