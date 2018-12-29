//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

extension RestaurantDetails {
    
    static func random(name: String = .random(), openingState: OpeningState = .random(), sortingValues: SortingValues = .random()) -> RestaurantDetails {
        return RestaurantDetails(
            name: name,
            openingState: openingState,
            sortingValues: sortingValues
        )
    }
    
    init(_ restaurant: Restaurant) {
        self.init(
            name: restaurant.name,
            openingState: restaurant.openingState,
            sortingValues: restaurant.sortingValues
        )
    }
    
}

extension RestaurantDetails: JSONPresentable {

    func JSON() -> [String: Any] {
        return [
            "name": name,
            "status": openingState.rawValue,
            "sortingValues": sortingValues.JSON()
        ]
    }

}
