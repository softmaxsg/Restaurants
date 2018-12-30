//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

extension SortingValues {
    
    private static let rankRange = 0...1000.0
    private static let costRange = 0...100000
    private static let distanceRange = 0...Int.max
    
    static func random(
        bestMatch: Double = .random(in: SortingValues.rankRange),
        newest: Double = .random(in: SortingValues.rankRange),
        averageRating: Double = .random(in: rankRange),
        distance: Int = .random(in: distanceRange),
        popularity: Double = .random(in: SortingValues.rankRange),
        averageProductPrice: Decimal = Decimal(cents: .random(in: costRange)),
        deliveryCost: Decimal = Decimal(cents: .random(in: costRange)),
        minimalCost: Decimal = Decimal(cents: .random(in: costRange))) -> SortingValues {
        return SortingValues(
            bestMatch: bestMatch,
            newest: newest,
            averageRating: averageRating,
            distance: distance,
            popularity: popularity,
            averageProductPrice: averageProductPrice,
            deliveryCost: deliveryCost,
            minimalCost: minimalCost
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
