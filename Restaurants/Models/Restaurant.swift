//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

struct Restaurant: Equatable {
    
    let isFavorite: Bool
    let name: String
    let openingState: OpeningState
    let sortingValues: SortingValues

}

extension Restaurant {
    
    init(details: RestaurantDetails, isFavorite: Bool) {
        self.isFavorite = isFavorite
        self.name = details.name
        self.openingState = details.openingState
        self.sortingValues = details.sortingValues
    }
    
}
