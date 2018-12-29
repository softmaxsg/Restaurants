//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

final class RestaurantDetailsDecodingTests: XCTestCase, DecodingTester {

    let expectedObject = RestaurantDetails.random()
    let requiredFields = RestaurantDetails.CodingKeys.allCases.map { $0.rawValue }
    
    func testFullDecoding() {
        performFullDecodingTest()
    }
    
    func testRequiredFields() {
        performRequiredFieldsTest()
    }

}
