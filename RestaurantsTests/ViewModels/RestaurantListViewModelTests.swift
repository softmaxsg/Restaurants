//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

final class RestaurantListViewModelTests: XCTestCase {

    private let expectedRestaurants = Array(1...Int.random(in: 1...10)).map { _ in Restaurant.random() }
    
    func testAllItems() {
        let viewModel = self.viewModel(with: .success(expectedRestaurants))
        XCTAssertEqual(viewModel.itemsCount, expectedRestaurants.count)
        
        for (index, restaurant) in expectedRestaurants.enumerated() {
            let item = try! viewModel.item(at: index)
            XCTAssertTrue(item == restaurant)
        }
    }
    
    func testEmptyList() {
        let viewModel = self.viewModel(with: .success([]))
        XCTAssertEqual(viewModel.itemsCount, 0)
    }
    
    func testLoadingFailed() {
        let viewModel = self.viewModel(with: .failure(MockError.some))
        XCTAssertEqual(viewModel.itemsCount, 0)
    }

    func testInvalidIndex() {
        let viewModel = self.viewModel(with: .success(expectedRestaurants))

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
    
    private func viewModel(with result: Result<[Restaurant]>, file: StaticString = #file, line: UInt = #line) -> RestaurantListViewModel {
        let expectation = self.expectation(description: "RestaurantListViewModel.loadRestaurants")

        let provider = mockedRestaurantsProvider(with: result)
        let delegate = RestaurantListViewModelDelegateMock(
            itemsDidUpdate: { expectation.fulfill() },
            itemsUpdateDidFail: { error in
                XCTAssertEqual(error as? MockError, MockError.some, file: file, line: line)
                expectation.fulfill()
            }
        )
        
        let viewModel = RestaurantListViewModel(delegate: delegate, restaurantsProvider: provider)
        viewModel.loadRestaurants()

        wait(for: [expectation], timeout: 1)
        return viewModel
    }
}
