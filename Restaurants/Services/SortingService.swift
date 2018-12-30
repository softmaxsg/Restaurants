//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol SortingServiceProtocol {

    func sorted(_ restaurants: [Restaurant], option: SortingOption) -> [Restaurant]
    
}

final class SortingService: SortingServiceProtocol {
    
    func sorted(_ restaurants: [Restaurant], option: SortingOption) -> [Restaurant] {
        return restaurants.sorted { lhs, rhs in
            if lhs.isFavorite != rhs.isFavorite { return lhs.isFavorite }
            
            if lhs.openingState != rhs.openingState {
                return compare(lhs: lhs.openingState, rhs: rhs.openingState)
            }

            return compare(lhs: lhs.sortingValues, rhs: rhs.sortingValues, option: option)
        }
    }
    
}

extension SortingService {
    
    private func compare(lhs: SortingValues, rhs: SortingValues, option: SortingOption) -> Bool {
        switch option {
        // Higher is better
        case .bestMatch: return lhs.bestMatch > rhs.bestMatch
        case .newest: return lhs.newest > rhs.newest
        case .averageRating: return lhs.averageRating > rhs.averageRating
        case .popularity: return lhs.popularity > rhs.popularity
            
        // Closer is better
        case .distance: return lhs.distance < rhs.distance
            
        // Cheaper is better
        case .averageProductPrice: return lhs.averageProductPrice < rhs.averageProductPrice
        case .deliveryCost: return lhs.deliveryCost < rhs.deliveryCost
        case .minimalCost: return lhs.minimalCost < rhs.minimalCost
        }
    }
    
    private func compare(lhs: OpeningState, rhs: OpeningState) -> Bool {
        switch lhs {
        case .open: return true
        case .preorder: return rhs != .open
        case .closed: return rhs == .closed
        }
    }

}
