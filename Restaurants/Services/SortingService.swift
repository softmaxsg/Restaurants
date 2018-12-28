//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

enum SortingOption {
    
    case bestMatch
    case newest
    case averageRating
    case distance
    case popularity
    case averageProductPrice
    case deliveryCost
    case minimalCost

}

protocol SortingServiceProtocol {

    func sorted(_ restaurants: [Restaurant], option: SortingOption) -> [Restaurant]
    
}

final class SortingService: SortingServiceProtocol {
    
    func sorted(_ restaurants: [Restaurant], option: SortingOption) -> [Restaurant] {
        return restaurants.sorted { lhs, rhs in
            if lhs.openingState != rhs.openingState { return compare(lhs: lhs.openingState, rhs: rhs.openingState) }

            switch option {
            // Higher is better
            case .bestMatch: return lhs.sortingValues.bestMatch > rhs.sortingValues.bestMatch
            case .newest: return lhs.sortingValues.newest > rhs.sortingValues.newest
            case .averageRating: return lhs.sortingValues.averageRating > rhs.sortingValues.averageRating
            case .popularity: return lhs.sortingValues.popularity > rhs.sortingValues.popularity
            
            // Closer is better
            case .distance: return lhs.sortingValues.distance < rhs.sortingValues.distance

            // Cheaper is better
            case .averageProductPrice: return lhs.sortingValues.averageProductPrice < rhs.sortingValues.averageProductPrice
            case .deliveryCost: return lhs.sortingValues.deliveryCost < rhs.sortingValues.deliveryCost
            case .minimalCost: return lhs.sortingValues.minimalCost < rhs.sortingValues.minimalCost
            }
        }
    }
    
}

extension SortingService {
    
    private func compare(lhs: OpeningState, rhs: OpeningState) -> Bool {
        switch lhs {
        case .open: return true
        case .preorder: return rhs != .open
        case .closed: return rhs == .closed
        }
    }

}
