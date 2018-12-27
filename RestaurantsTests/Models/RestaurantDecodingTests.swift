//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

final class RestaurantDecodingTests: XCTestCase, DecodingTester {

    let expectedObject = Restaurant.random()
    let requiredFields = Restaurant.CodingKeys.allCases.map { $0.rawValue }
    
    func testFullDecoding() {
        performFullDecodingTest()
    }
    
    func testRequiredFields() {
        performRequiredFieldsTest()
    }

}
