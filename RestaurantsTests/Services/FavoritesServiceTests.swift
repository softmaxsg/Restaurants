//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

final class FavoritesServiceTests: XCTestCase {
    
    private let restaurant = FavoriteRestaurant.random()
    
    func testAddRestaurant() {
        let service = FavoritesService(initial: [])
        XCTAssertFalse(service.isRestaurantFavorite(with: restaurant.name))

        try! service.addRestaurant(with: restaurant.name)
        XCTAssertTrue(service.isRestaurantFavorite(with: restaurant.name))
    }
    
    func testAddRestaurantFailed() {
        let service = FavoritesService(initial: [restaurant])

        XCTAssertThrowsError(try service.addRestaurant(with: restaurant.name), "Has to throw an error") { error in
            XCTAssertEqual(error as? FavoritesServiceError, FavoritesServiceError.alreadyExists)
        }
    }

    func testRemoveRestaurant() {
        let service = FavoritesService(initial: [restaurant])
        XCTAssertTrue(service.isRestaurantFavorite(with: restaurant.name))
        
        try! service.removeRestaurant(with: restaurant.name)
        XCTAssertFalse(service.isRestaurantFavorite(with: restaurant.name))
    }
    
    func testRemoveRestaurantFailed() {
        let service = FavoritesService(initial: [])
        
        XCTAssertThrowsError(try service.removeRestaurant(with: restaurant.name), "Has to throw an error") { error in
            XCTAssertEqual(error as? FavoritesServiceError, FavoritesServiceError.notFound)
        }
    }

    func testDelegate() {
        let restaurantAddedMethodName = "favoriteRestaurantAdded"
        let restaurantRemovedMethodName = "favoriteRestaurantRemoved"
        
        var methodName: String!
        let delegate = FavoritesServiceDelegateMock(
            restaurantAdded: { _ in methodName = restaurantAddedMethodName },
            restaurantRemoved: { _ in methodName = restaurantRemovedMethodName }
        )
        
        let service = FavoritesService(initial: [])
        service.addDelegate(delegate)
        
        try! service.addRestaurant(with: restaurant.name)
        XCTAssertEqual(methodName, restaurantAddedMethodName)
        
        try! service.removeRestaurant(with: restaurant.name)
        XCTAssertEqual(methodName, restaurantRemovedMethodName)
        
        service.removeDelegate(delegate)
        methodName = nil
        
        try! service.addRestaurant(with: restaurant.name)
        try! service.removeRestaurant(with: restaurant.name)
        XCTAssertNil(methodName)
    }
    
}
