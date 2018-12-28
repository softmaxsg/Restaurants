//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

final class SortingServiceTests: XCTestCase {

    private let restaurant1 = Restaurant.random(openingState: .open)
    private let restaurant2 = Restaurant.random(openingState: .open)

    private let service = SortingService()
    
    func testSortByOpeningState() {
        let restaurant1 = Restaurant.random(openingState: .preorder)
        let restaurant2 = Restaurant.random(openingState: .closed)
        let restaurant3 = Restaurant.random(openingState: .open)
        let expectedResult = [restaurant3, restaurant1, restaurant2]

        let result = service.sorted([restaurant1, restaurant2, restaurant3], option: .bestMatch)
        XCTAssertEqual(result, expectedResult)
    }
    
    func testSortyByBestMatch() {
        let result = service.sorted([restaurant1, restaurant2], option: .bestMatch)
        XCTAssertGreaterThanOrEqual(result[0].sortingValues.bestMatch, result[1].sortingValues.bestMatch)
    }
    
    func testSortyByNewest() {
        let result = service.sorted([restaurant1, restaurant2], option: .newest)
        XCTAssertGreaterThanOrEqual(result[0].sortingValues.newest, result[1].sortingValues.newest)
    }

    func testSortyByAverageRating() {
        let result = service.sorted([restaurant1, restaurant2], option: .averageRating)
        XCTAssertGreaterThanOrEqual(result[0].sortingValues.averageRating, result[1].sortingValues.averageRating)
    }
    
    func testSortyByBestPopularity() {
        let result = service.sorted([restaurant1, restaurant2], option: .popularity)
        XCTAssertGreaterThanOrEqual(result[0].sortingValues.popularity, result[1].sortingValues.popularity)
    }
    
    func testSortyByDistance() {
        let result = service.sorted([restaurant1, restaurant2], option: .distance)
        XCTAssertLessThanOrEqual(result[0].sortingValues.distance, result[1].sortingValues.distance)
    }
    
    func testSortyByAverageProductPrice() {
        let result = service.sorted([restaurant1, restaurant2], option: .averageProductPrice)
        XCTAssertLessThanOrEqual(result[0].sortingValues.averageProductPrice, result[1].sortingValues.averageProductPrice)
    }
    
    func testSortyByDeliveryCost() {
        let result = service.sorted([restaurant1, restaurant2], option: .deliveryCost)
        XCTAssertLessThanOrEqual(result[0].sortingValues.deliveryCost, result[1].sortingValues.deliveryCost)
    }
    
    func testSortyByMinimalCost() {
        let result = service.sorted([restaurant1, restaurant2], option: .minimalCost)
        XCTAssertLessThanOrEqual(result[0].sortingValues.minimalCost, result[1].sortingValues.minimalCost)
    }

}
