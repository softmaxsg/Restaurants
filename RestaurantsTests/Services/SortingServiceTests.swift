//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

final class SortingServiceTests: XCTestCase {

    private let restaurant1 = RestaurantDetails(restaurant: .random(openingState: .open), isFavorite: false)
    private let restaurant2 = RestaurantDetails(restaurant: .random(openingState: .open), isFavorite: false)

    private let service = SortingService()
    
    func testSortByIsFavorite() {
        let restaurant1 = RestaurantDetails.random(isFavorite: true)
        let restaurant2 = RestaurantDetails.random(isFavorite: false)
        let expectedResult = [restaurant1, restaurant2]
        
        let result = service.sorted([restaurant2, restaurant1], option: .bestMatch)
        XCTAssertEqual(result, expectedResult)
    }

    func testSortByOpeningState() {
        let restaurant1 = RestaurantDetails(restaurant: .random(openingState: .preorder), isFavorite: false)
        let restaurant2 = RestaurantDetails(restaurant: .random(openingState: .closed), isFavorite: false)
        let restaurant3 = RestaurantDetails(restaurant: .random(openingState: .open), isFavorite: false)
        let expectedResult = [restaurant3, restaurant1, restaurant2]

        let result = service.sorted([restaurant1, restaurant2, restaurant3], option: .bestMatch)
        XCTAssertEqual(result, expectedResult)
    }
    
    func testSortyByBestMatch() {
        let result = service.sorted([restaurant1, restaurant2], option: .bestMatch).map { $0.restaurant.sortingValues }
        XCTAssertGreaterThanOrEqual(result[0].bestMatch, result[1].bestMatch)
    }
    
    func testSortyByNewest() {
        let result = service.sorted([restaurant1, restaurant2], option: .newest).map { $0.restaurant.sortingValues }
        XCTAssertGreaterThanOrEqual(result[0].newest, result[1].newest)
    }

    func testSortyByAverageRating() {
        let result = service.sorted([restaurant1, restaurant2], option: .averageRating).map { $0.restaurant.sortingValues }
        XCTAssertGreaterThanOrEqual(result[0].averageRating, result[1].averageRating)
    }
    
    func testSortyByBestPopularity() {
        let result = service.sorted([restaurant1, restaurant2], option: .popularity).map { $0.restaurant.sortingValues }
        XCTAssertGreaterThanOrEqual(result[0].popularity, result[1].popularity)
    }
    
    func testSortyByDistance() {
        let result = service.sorted([restaurant1, restaurant2], option: .distance).map { $0.restaurant.sortingValues }
        XCTAssertLessThanOrEqual(result[0].distance, result[1].distance)
    }
    
    func testSortyByAverageProductPrice() {
        let result = service.sorted([restaurant1, restaurant2], option: .averageProductPrice).map { $0.restaurant.sortingValues }
        XCTAssertLessThanOrEqual(result[0].averageProductPrice, result[1].averageProductPrice)
    }
    
    func testSortyByDeliveryCost() {
        let result = service.sorted([restaurant1, restaurant2], option: .deliveryCost).map { $0.restaurant.sortingValues }
        XCTAssertLessThanOrEqual(result[0].deliveryCost, result[1].deliveryCost)
    }
    
    func testSortyByMinimalCost() {
        let result = service.sorted([restaurant1, restaurant2], option: .minimalCost).map { $0.restaurant.sortingValues }
        XCTAssertLessThanOrEqual(result[0].minimalCost, result[1].minimalCost)
    }

}
