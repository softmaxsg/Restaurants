//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

final class SortingServiceTests: XCTestCase {

    private let restaurant1 = Restaurant.random(openingState: .open)
    private let restaurant2 = Restaurant.random(openingState: .open)

    private let service = SortingService()
    
    func testSortByIsFavorite() {
        let restaurant1 = Restaurant.random()
        let restaurant2 = Restaurant.random()
        let expectedResult = [restaurant1, restaurant2]
        
        let result = service.sorted([restaurant2, restaurant1], option: .bestMatch) { $0 == restaurant1 }
        XCTAssertEqual(result, expectedResult)
    }

    func testSortByOpeningState() {
        let restaurant1 = Restaurant.random(openingState: .preorder)
        let restaurant2 = Restaurant.random(openingState: .closed)
        let restaurant3 = Restaurant.random(openingState: .open)
        let expectedResult = [restaurant3, restaurant1, restaurant2]

        let result = service.sorted([restaurant1, restaurant2, restaurant3], option: .bestMatch) { _ in false }
        XCTAssertEqual(result, expectedResult)
    }
    
    func testSortyByBestMatch() {
        let result = service.sorted([restaurant1, restaurant2], option: .bestMatch) { _ in false }
        XCTAssertGreaterThanOrEqual(result[0].sortingValues.bestMatch, result[1].sortingValues.bestMatch)
    }
    
    func testSortyByNewest() {
        let result = service.sorted([restaurant1, restaurant2], option: .newest) { _ in false }
        XCTAssertGreaterThanOrEqual(result[0].sortingValues.newest, result[1].sortingValues.newest)
    }

    func testSortyByAverageRating() {
        let result = service.sorted([restaurant1, restaurant2], option: .averageRating) { _ in false }
        XCTAssertGreaterThanOrEqual(result[0].sortingValues.averageRating, result[1].sortingValues.averageRating)
    }
    
    func testSortyByBestPopularity() {
        let result = service.sorted([restaurant1, restaurant2], option: .popularity) { _ in false }
        XCTAssertGreaterThanOrEqual(result[0].sortingValues.popularity, result[1].sortingValues.popularity)
    }
    
    func testSortyByDistance() {
        let result = service.sorted([restaurant1, restaurant2], option: .distance) { _ in false }
        XCTAssertLessThanOrEqual(result[0].sortingValues.distance, result[1].sortingValues.distance)
    }
    
    func testSortyByAverageProductPrice() {
        let result = service.sorted([restaurant1, restaurant2], option: .averageProductPrice) { _ in false }
        XCTAssertLessThanOrEqual(result[0].sortingValues.averageProductPrice, result[1].sortingValues.averageProductPrice)
    }
    
    func testSortyByDeliveryCost() {
        let result = service.sorted([restaurant1, restaurant2], option: .deliveryCost) { _ in false }
        XCTAssertLessThanOrEqual(result[0].sortingValues.deliveryCost, result[1].sortingValues.deliveryCost)
    }
    
    func testSortyByMinimalCost() {
        let result = service.sorted([restaurant1, restaurant2], option: .minimalCost) { _ in false }
        XCTAssertLessThanOrEqual(result[0].sortingValues.minimalCost, result[1].sortingValues.minimalCost)
    }

}
