//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

struct SortingValues: Equatable {
    
    let bestMatch: Double
    let newest: Double
    let averageRating: Double
    let distance: Int
    let popularity: Double
    let averageProductPrice: Decimal
    let deliveryCost: Decimal
    let minimalCost: Decimal

}

extension SortingValues: Decodable {
    
    enum CodingKeys: String, CaseIterable, CodingKey {
        
        case bestMatch
        case newest
        case averageRating = "ratingAverage"
        case distance
        case popularity
        case averageProductPrice
        case deliveryCost = "deliveryCosts"
        case minimalCost = "minCost"
    
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bestMatch = try values.decode(Double.self, forKey: .bestMatch)
        newest = try values.decode(Double.self, forKey: .newest)
        averageRating = try values.decode(Double.self, forKey: .averageRating)
        distance = try values.decode(Int.self, forKey: .distance)
        popularity = try values.decode(Double.self, forKey: .popularity)
        averageProductPrice = Decimal(cents: try values.decode(Int.self, forKey: .averageProductPrice))
        deliveryCost = Decimal(cents: try values.decode(Int.self, forKey: .deliveryCost))
        minimalCost = Decimal(cents: try values.decode(Int.self, forKey: .minimalCost))
    }

}
