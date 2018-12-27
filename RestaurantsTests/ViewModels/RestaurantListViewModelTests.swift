//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

final class RestaurantListViewModelTests: XCTestCase {

    private let expectedRestaurants = Array(1...Int.random(in: 1...10)).map { _ in Restaurant.random() }
    
    func testAllItems() {
        let viewModel = RestaurantListViewModel(expectedRestaurants)
        XCTAssertEqual(viewModel.itemsCount, expectedRestaurants.count)
        
        for (index, restaurant) in expectedRestaurants.enumerated() {
            let item = try! viewModel.item(at: index)
            XCTAssertTrue(item == restaurant)
        }
    }
    
    func testEmptyList() {
        let viewModel = RestaurantListViewModel([])
        XCTAssertEqual(viewModel.itemsCount, 0)
    }

    func testInvalidIndex() {
        let viewModel = RestaurantListViewModel(expectedRestaurants)

        XCTAssertThrowsError(try viewModel.item(at: viewModel.itemsCount), "Has to throw an error") { error in
            XCTAssertEqual(error as? RandomAccessCollectionError, RandomAccessCollectionError.indexOutOfBounds)
        }
    }

}
