//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

final class FavoritesServiceDelegateMock: FavoritesServiceDelegate {
    
    typealias MethodImpl = (String) -> Void
    
    private let restaurantAddedImpl: MethodImpl
    private let restaurantRemovedImpl: MethodImpl
    
    init(restaurantAdded restaurantAddedImpl: @escaping MethodImpl,
         restaurantRemoved restaurantRemovedImpl: @escaping MethodImpl) {
        self.restaurantAddedImpl = restaurantAddedImpl
        self.restaurantRemovedImpl = restaurantRemovedImpl
    }
    
    func favoriteRestaurantAdded(with name: String) {
        restaurantAddedImpl(name)
    }
    
    func favoriteRestaurantRemoved(with name: String) {
        restaurantRemovedImpl(name)
    }
    
}
