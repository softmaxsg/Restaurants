//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

extension Restaurant {
    
    static func random(name: String = .random(), openingState: OpeningState = .random(), sortingValues: SortingValues = .random(), isFavorite: Bool = .random()) -> Restaurant {
        return Restaurant(
            isFavorite: isFavorite,
            name: name,
            openingState: openingState,
            sortingValues: sortingValues
        )
    }

}
