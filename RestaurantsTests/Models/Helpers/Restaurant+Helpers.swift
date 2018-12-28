//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

extension Restaurant {
    
    static func random(name: String = .random(), openingState: OpeningState = .random(), sortingValues: SortingValues = .random()) -> Restaurant {
        return Restaurant(
            name: name,
            openingState: openingState,
            sortingValues: sortingValues
        )
    }
    
}

extension Restaurant: JSONPresentable {

    func JSON() -> [String: Any] {
        return [
            "name": name,
            "status": openingState.rawValue,
            "sortingValues": sortingValues.JSON()
        ]
    }

}
