//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

final class SortingValuesDecodingTests: XCTestCase, DecodingTester {
    
    let expectedObject = SortingValues.random()
    let requiredFields = SortingValues.CodingKeys.allCases.map { $0.rawValue }

    func testFullDecoding() {
        performFullDecodingTest()
    }
    
    func testRequiredFields() {
        performRequiredFieldsTest()
    }
    
}
