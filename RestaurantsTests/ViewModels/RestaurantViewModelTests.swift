//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

final class RestaurantViewModelTests: XCTestCase {

    func testInitialization() {
        let restaurant = Restaurant.random()
        for option in SortingOption.allCases {
            let viewModel = RestaurantViewModel(restaurant, sorting: SortingOptionViewModel(option: option)) { }
            XCTAssertTrue(viewModel.isEqual(to: restaurant, sorting: option))
        }
    }

    func testToggleFavoriteState() {
        let expectation = self.expectation(description: "toggleFavoriteStateCallback")

        let viewModel = RestaurantViewModel(Restaurant.random(), sorting: SortingOptionViewModel(option: .random())) {
            expectation.fulfill()
        }
        
        viewModel.toggleFavoriteState()
        wait(for: [expectation], timeout: 1)
    }

}
