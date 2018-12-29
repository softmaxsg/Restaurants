//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

final class RestaurantViewModelTests: XCTestCase {

    func testInitialization() {
        let restaurant = Restaurant.random()
        let viewModel = RestaurantViewModel(restaurant) { }
        XCTAssertTrue(viewModel == restaurant)
    }

    func testToggleFavoriteState() {
        let expectation = self.expectation(description: "toggleFavoriteStateCallback")

        let viewModel = RestaurantViewModel(Restaurant.random()) {
            expectation.fulfill()
        }
        
        viewModel.toggleFavoriteState()
        wait(for: [expectation], timeout: 1)
    }

}
