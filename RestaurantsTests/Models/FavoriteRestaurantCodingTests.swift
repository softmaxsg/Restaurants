//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

// Those tests validate Codable adotion so the actual decoder doesn't matter
final class FavoriteRestaurantCodingTests: XCTestCase, DecodingTester {
    
    let expectedObject = FavoriteRestaurant.random()
    let requiredFields = ["name"]
    
    func testFullDecoding() {
        performFullDecodingTest()
    }
    
    func testRequiredFields() {
        performRequiredFieldsTest()
    }

    func testEncoding() {
        let expectedJSON = fullJSON as! [String: String]
        let decodedJSON = try! JSONEncoder().encodeToJSON(expectedObject) as! [String: String]
        XCTAssertEqual(decodedJSON, expectedJSON)
    }

}
