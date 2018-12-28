//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

final class FilteredServiceTests: XCTestCase {

    func testFilter() {
        let restaurant1 = Restaurant.random(name: "Lale Restaurant & Snackbar")
        let restaurant2 = Restaurant.random(name: "Italian restaurant")
        let restaurant3 = Restaurant.random(name: "Blackcurrant")
        
        let initialRestaurants = [restaurant1, .random(), restaurant2, restaurant3, .random()]
        let expectedRestaurants = [restaurant1, restaurant2, restaurant3]
        
        let service = FilteringService()
        let result = service.filtered(initialRestaurants, using: "Rant")
        XCTAssertEqual(result, expectedRestaurants)
    }

    func testFilterUsingEmptyText() {
        let expectedRestaurants: [Restaurant] = [.random(), .random(), .random()]
        let service = FilteringService()
        let result = service.filtered(expectedRestaurants, using: "")
        XCTAssertEqual(result, expectedRestaurants)
    }

}
