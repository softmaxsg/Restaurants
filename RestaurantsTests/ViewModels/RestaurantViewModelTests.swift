//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

final class RestaurantViewModelTests: XCTestCase {

    func testInitialization() {
        let restaurant = Restaurant.random()
        let isFavorite = Bool.random()
        
        let viewModel = RestaurantViewModel(restaurant, isFavorite: isFavorite) { }
        XCTAssertTrue(viewModel == restaurant)
        XCTAssertEqual(viewModel.isFavorite, isFavorite)
    }

    func testToggleFavoriteState() {
        let expectation = self.expectation(description: "toggleFavoriteStateCallback")

        let viewModel = RestaurantViewModel(.random(), isFavorite: .random()) {
            expectation.fulfill()
        }
        
        viewModel.toggleFavoriteState()
        wait(for: [expectation], timeout: 1)
    }

}
