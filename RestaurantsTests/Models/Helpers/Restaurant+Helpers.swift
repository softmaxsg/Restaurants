//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

extension Restaurant {
    
    static func random() -> Restaurant {
        return Restaurant(
            name: .random(),
            openingState: .random(),
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
