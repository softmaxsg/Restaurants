//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

final class FavoritesServiceTests: XCTestCase {
    
    private let restaurant = FavoriteRestaurant.random()
    
    func testAddRestaurant() {
        let storageService = FavoritesStorageServiceMock(initial: [])
        let service = FavoritesService(storageService: storageService)
        XCTAssertFalse(service.isRestaurantFavorite(with: restaurant.name))

        try! service.addRestaurant(with: restaurant.name)
        XCTAssertTrue(service.isRestaurantFavorite(with: restaurant.name))
        XCTAssertEqual(storageService.restaurants, [restaurant])
    }
    
    func testAddRestaurantFailed() {
        let storageService = FavoritesStorageServiceMock(initial: [restaurant])
        let service = FavoritesService(storageService: storageService)

        XCTAssertThrowsError(try service.addRestaurant(with: restaurant.name), "Has to throw an error") { error in
            XCTAssertEqual(error as? FavoritesServiceError, FavoritesServiceError.alreadyExists)
        }

        XCTAssertEqual(storageService.restaurants, [restaurant])
    }

    func testRemoveRestaurant() {
        let storageService = FavoritesStorageServiceMock(initial: [restaurant])
        let service = FavoritesService(storageService: storageService)
        XCTAssertTrue(service.isRestaurantFavorite(with: restaurant.name))
        
        try! service.removeRestaurant(with: restaurant.name)
        XCTAssertFalse(service.isRestaurantFavorite(with: restaurant.name))
        XCTAssertEqual(storageService.restaurants, [])
    }
    
    func testRemoveRestaurantFailed() {
        let storageService = FavoritesStorageServiceMock(initial: [])
        let service = FavoritesService(storageService: storageService)
        
        XCTAssertThrowsError(try service.removeRestaurant(with: restaurant.name), "Has to throw an error") { error in
            XCTAssertEqual(error as? FavoritesServiceError, FavoritesServiceError.notFound)
        }

        XCTAssertEqual(storageService.restaurants, [])
    }

    func testDelegate() {
        let restaurantAddedMethodName = "favoriteRestaurantAdded"
        let restaurantRemovedMethodName = "favoriteRestaurantRemoved"
        
        var methodName: String!
        let delegate = FavoritesServiceDelegateMock(
            restaurantAdded: { _ in methodName = restaurantAddedMethodName },
            restaurantRemoved: { _ in methodName = restaurantRemovedMethodName }
        )
        
        let service = FavoritesService(storageService: FavoritesStorageServiceMock(initial: []))
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
