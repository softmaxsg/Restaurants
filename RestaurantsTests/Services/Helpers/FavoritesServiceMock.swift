//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

final class FavoritesServiceMock: FavoritesServiceProtocol {
    
    typealias IsRestaurantFavoriteImpl = (String) -> Bool
    typealias RestaurantManagementImpl = (String) -> Void
    typealias DelegateManagementImpl = (FavoritesServiceDelegate) -> Void

    private let isRestaurantFavoriteImpl: IsRestaurantFavoriteImpl
    private let addRestaurantImpl: RestaurantManagementImpl
    private let removeRestaurantImpl: RestaurantManagementImpl
    private let addDelegateImpl: DelegateManagementImpl
    private let removeDelegateImpl: DelegateManagementImpl

    init(isRestaurantFavorite isRestaurantFavoriteImpl: @escaping IsRestaurantFavoriteImpl,
         addRestaurant addRestaurantImpl: @escaping RestaurantManagementImpl,
         removeRestaurant removeRestaurantImpl: @escaping RestaurantManagementImpl,
         addDelegate addDelegateImpl: @escaping DelegateManagementImpl,
         removeDelegate removeDelegateImpl: @escaping DelegateManagementImpl) {
        self.isRestaurantFavoriteImpl = isRestaurantFavoriteImpl
        self.addRestaurantImpl = addRestaurantImpl
        self.removeRestaurantImpl = removeRestaurantImpl
        self.addDelegateImpl = addDelegateImpl
        self.removeDelegateImpl = removeDelegateImpl
    }
    
    func isRestaurantFavorite(with name: String) -> Bool {
        return isRestaurantFavoriteImpl(name)
    }
    
    func addRestaurant(with name: String) throws {
        addRestaurantImpl(name)
    }
    
    func removeRestaurant(with name: String) throws {
        removeRestaurantImpl(name)
    }
    
    func addDelegate(_ delegate: FavoritesServiceDelegate) {
        addDelegateImpl(delegate)
    }
    
    func removeDelegate(_ delegate: FavoritesServiceDelegate) {
        removeDelegateImpl(delegate)
    }

}

extension FavoritesServiceMock {
    
    static var empty: FavoritesServiceMock {
        return FavoritesServiceMock(
            isRestaurantFavorite: { _ in false },
            addRestaurant: { _ in },
            removeRestaurant: { _ in },
            addDelegate: { _ in },
            removeDelegate: { _ in }
        )
    }
    
}
