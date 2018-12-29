//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

final class RestaurantViewModelTests: XCTestCase {

    func testInitialization() {
        let restaurantDetails = RestaurantDetails.random()
        let viewModel = RestaurantViewModel(restaurantDetails) { }
        XCTAssertTrue(viewModel == restaurantDetails)
    }

    func testToggleFavoriteState() {
        let expectation = self.expectation(description: "toggleFavoriteStateCallback")

        let viewModel = RestaurantViewModel(RestaurantDetails.random()) {
            expectation.fulfill()
        }
        
        viewModel.toggleFavoriteState()
        wait(for: [expectation], timeout: 1)
    }

}
