//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

final class RestaurantListViewModelTests: XCTestCase {

    private let initialRestaurants = Array(1...Int.random(in: 2...10)).map { _ in Restaurant.random() }

    func testAllItems() {
        var expectedRestaurants: [Restaurant]! = nil
        let sortingService = SortingServiceMock { restaurants, _ in
            expectedRestaurants = restaurants.shuffled()
            return expectedRestaurants
        }
        
        let viewModel = self.viewModel(with: .success(initialRestaurants), sortingService: sortingService)
        compareItems(in: viewModel, with: expectedRestaurants)
    }
    
    func testChangingSortingOption() {
        var expectedRestaurants: [Restaurant]! = nil
        let sortingService = SortingServiceMock { restaurants, _ in
            expectedRestaurants = restaurants.shuffled()
            return expectedRestaurants
        }
        
        let viewModel = self.viewModel(with: .success(initialRestaurants), sortingService: sortingService)
        expectedRestaurants = nil
        
        viewModel.sortingOption = SortingOption.allCases.randomElement()!
        compareItems(in: viewModel, with: expectedRestaurants)
    }
    
    func testEmptyList() {
        let viewModel = self.viewModel(with: .success([]))
        compareItems(in: viewModel, with: [])
    }
    
    func testLoadingFailed() {
        let viewModel = self.viewModel(with: .failure(MockError.some))
        compareItems(in: viewModel, with: [])
    }

    func testInvalidIndex() {
        let viewModel = self.viewModel(with: .success(initialRestaurants))

        XCTAssertThrowsError(try viewModel.item(at: viewModel.itemsCount), "Has to throw an error") { error in
            XCTAssertEqual(error as? RandomAccessCollectionError, RandomAccessCollectionError.indexOutOfBounds)
        }
    }

}

extension RestaurantListViewModelTests {
    
    private enum MockError: Error { case some }
    
    private func mockedRestaurantsProvider(with result: Result<[Restaurant]>) -> RestaurantsProviderProtocol {
        return RestaurantsProviderMock { handler in
            OperationQueue.main.addOperation { handler(result) }
            return EmptyTask()
        }
    }
    
    private func viewModel(with result: Result<[Restaurant]>, sortingService: SortingServiceProtocol? = nil, file: StaticString = #file, line: UInt = #line) -> RestaurantListViewModel {
        let expectation = self.expectation(description: "RestaurantListViewModel.loadRestaurants")

        let provider = mockedRestaurantsProvider(with: result)
        let delegate = RestaurantListViewModelDelegateMock(
            itemsDidUpdate: {
                switch result {
                case .success: expectation.fulfill()
                case .failure: XCTFail("Should be called in this test", file: file, line: line)
                }
            },
            itemsUpdateDidFail: { error in
                switch result {
                case .success: XCTFail("Should be called in this test", file: file, line: line)
                case .failure: expectation.fulfill()
                }
            }
        )
        
        let viewModel = RestaurantListViewModel(
            delegate: delegate,
            restaurantsProvider: provider,
            sortingService: sortingService ?? SortingServiceMock { restaurants, _ in restaurants.shuffled() }
        )
        
        viewModel.loadRestaurants()
        wait(for: [expectation], timeout: 1)
        return viewModel
    }
    
    private func compareItems(in viewModel: RestaurantListViewModel, with restaurants: [Restaurant], file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(viewModel.itemsCount, restaurants.count, file: file, line: line)
        
        for (index, restaurant) in restaurants.enumerated() {
            let item = try! viewModel.item(at: index)
            XCTAssertTrue(item == restaurant, file: file, line: line)
        }
    }
    
}
