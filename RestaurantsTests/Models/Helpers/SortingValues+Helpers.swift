//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

extension SortingValues {
    
    private static let rankRange = 0...1000.0
    private static let costRange = 0...100000
    private static let distanceRange = 0...Int.max
    
    static func random() -> SortingValues {
        return SortingValues(
            bestMatch: .random(in: SortingValues.rankRange),
            newest: .random(in: SortingValues.rankRange),
            averageRating: .random(in: rankRange),
            distance: .random(in: distanceRange),
            popularity: .random(in: SortingValues.rankRange),
            averageProductPrice: Decimal(cents: .random(in: costRange)),
            deliveryCost: Decimal(cents: .random(in: costRange)),
            minimalCost: Decimal(cents: .random(in: costRange))
        )
    }
    
}

extension SortingValues: JSONPresentable {
    
    func JSON() -> [String: Any] {
        return [
            "bestMatch": bestMatch,
            "newest": newest,
            "ratingAverage": averageRating,
            "distance": distance,
            "popularity": popularity,
            "averageProductPrice": averageProductPrice.cents,
            "deliveryCosts": deliveryCost.cents,
            "minCost": minimalCost.cents,
        ]
    }
    
}
