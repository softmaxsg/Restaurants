//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

final class FavoritesStorageServiceMock: FavoritesStorageServiceProtocol {

    private(set) var restaurants: [FavoriteRestaurant]
    
    init(initial restaurants: [FavoriteRestaurant] = []) {
        self.restaurants = restaurants
    }
    
    func loadAll() -> [FavoriteRestaurant] {
        return restaurants
    }
    
    func saveAll(_ restaurants: [FavoriteRestaurant]) {
        self.restaurants = restaurants
    }
    
}
