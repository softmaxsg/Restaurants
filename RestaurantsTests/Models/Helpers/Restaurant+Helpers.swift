//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

extension Restaurant {
    
    static func random(openingState: OpeningState = .random()) -> Restaurant {
        return Restaurant(
            name: .random(),
            openingState: openingState,
            sortingValues: .random()
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
