//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

final class RestaurantsResponseDecodingTests: XCTestCase, DecodingTester {
    
    let expectedObject = RestaurantsResponse.random()
    let requiredFields = ["restaurants"]
    
    func testFullDecoding() {
        performFullDecodingTest()
    }
    
    func testRequiredFields() {
        performRequiredFieldsTest()
    }
    
}
