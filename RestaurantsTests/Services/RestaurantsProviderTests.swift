//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

final class RestaurantsProviderTests: XCTestCase {

    private let expectedRestaurants = Array(1...Int.random(in: 1...10)).map { _ in RestaurantDetails.random() }

    func testLoadAllSuccessful() {
        let urlSession = mockedURLSession(restaurants: expectedRestaurants)
        let provider = RestaurantsProvider(urlSession: urlSession)
        let result = loadRestaurants(using: provider)
        XCTAssertEqual(result.value, expectedRestaurants)
    }

    func testLoadAllEmpty() {
        let urlSession = mockedURLSession(restaurants: [])
        let provider = RestaurantsProvider(urlSession: urlSession)
        let result = loadRestaurants(using: provider)
        XCTAssertEqual(result.value, [])
    }

    func testLoadAllFailed() {
        let urlSession = mockedURLSession(restaurants: nil)
        let provider = RestaurantsProvider(urlSession: urlSession)
        let result = loadRestaurants(using: provider)
        XCTAssertNotNil(result.error)
    }

    // This test proves that decoder is being used by RestaurantsProvider
    func testLoadAllDecodingFailed() {
        let jsonDecoder = JSONDecoderMock<RestaurantsResponse> { _ in throw MockError.some }
        let urlSession = mockedURLSession(restaurants: [])
        let provider = RestaurantsProvider(urlSession: urlSession, jsonDecoder: jsonDecoder)
        let result = loadRestaurants(using: provider)
        XCTAssertEqual(result.error as? MockError, MockError.some)
    }

}

extension RestaurantsProviderTests {

    private enum MockError: Error { case some }
    
    private func mockedURLSession(restaurants: [RestaurantDetails]?) -> URLSessionProtocol {
        let data = restaurants != nil ? try? JSONSerialization.data(withJSONObject: RestaurantsResponse(restaurants: restaurants!).JSON()) : nil
        return URLSessionMock(map: [Constants.restaurantsURL: data])
    }

    private func loadRestaurants(using provider: RestaurantsProvider) -> Result<[RestaurantDetails]> {
        let expectation = self.expectation(description: "RestaurantsProvider.loadAll")
        var result: Result<[RestaurantDetails]>!
        
        provider.loadAll {
            result = $0
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        return result
    }
    
}
