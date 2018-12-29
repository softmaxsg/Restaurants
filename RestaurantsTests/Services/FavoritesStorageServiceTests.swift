//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

final class FavoritesStorageServiceTests: XCTestCase {
    
    private let expectedRestaurants = Array(1...Int.random(in: 1...10)).map { _ in FavoriteRestaurant.random() }
    
    private let storageUrl = FileManager.default.temporaryDirectory.appendingPathComponent(.random())
    
    override func tearDown() {
        try? FileManager.default.removeItem(at: storageUrl)
    }
    
    // No separate tests for loading and saving because it's not easy to mock dependencies for FavoritesDataStorage
    func testSaveAndLoad() {
        let savingStorage = FavoritesStorageService(url: storageUrl)
        savingStorage.saveAll(expectedRestaurants)
        
        let readingStorage = FavoritesStorageService(url: storageUrl)
        let restaurants = readingStorage.loadAll()
        
        XCTAssertEqual(restaurants, expectedRestaurants)
    }
    
    func testLoadFailed() {
        let storage = FavoritesStorageService(url: URL(fileURLWithPath: .random()))
        let restaurants = storage.loadAll()
        XCTAssertTrue(restaurants.isEmpty)
    }
    
}
