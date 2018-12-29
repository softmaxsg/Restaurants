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
    
    func testSorting() {
        let expectedSortingOption = SortingOption.allCases.randomElement()!
        var expectedRestaurants: [Restaurant]! = nil
        
        var sortingServiceCalls = 0
        let sortingService = SortingServiceMock { restaurants, option in
            sortingServiceCalls += 1
            switch sortingServiceCalls {
            case 1: XCTAssertEqual(option, SortingOption.bestMatch)
            case 2: XCTAssertEqual(option, expectedSortingOption)
            default: XCTFail("Called too many times")
            }
            
            expectedRestaurants = restaurants.shuffled()
            return expectedRestaurants
        }
        
        let viewModel = self.viewModel(with: .success(initialRestaurants), sortingService: sortingService)
        expectedRestaurants = nil
        
        viewModel.sortingOption = expectedSortingOption
        compareItems(in: viewModel, with: expectedRestaurants)
    }
    
    func testFiltering() {
        let expectedFilteringText = String.random()
        var expectedRestaurants: [Restaurant]! = nil
        
        var filteringServiceCalls = 0
        let filteringService = FilteringServiceMock { restaurants, text in
            filteringServiceCalls += 1
            switch filteringServiceCalls {
            case 1: XCTAssertTrue(text.isEmpty)
            case 2: XCTAssertEqual(text, expectedFilteringText)
            default: XCTFail("Called too many times")
            }

            expectedRestaurants = restaurants.filter { _ in .random() }
            return expectedRestaurants
        }
        
        let viewModel = self.viewModel(with: .success(initialRestaurants), filteringService: filteringService)
        expectedRestaurants = nil
        
        viewModel.filteringText = expectedFilteringText
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
    
    func testFavoritesServiceDelegate() {
        var expectation = self.expectation(description: "RestaurantListViewModel.loadRestaurants")
        let delegate = RestaurantListViewModelDelegateMock(
            itemsDidUpdate: { expectation.fulfill() },
            itemsUpdateDidFail: { _ in XCTFail("Should be called in this test") }
        )

        let favoritesServiceExpectation = self.expectation(description: "FavoritesService.addDelegate")
        let favoritesService = FavoritesServiceMock(
            isRestaurantFavorite: { _ in false },
            addRestaurant: { _ in XCTFail("Should be called in this test") },
            removeRestaurant: { _ in XCTFail("Should be called in this test") },
            addDelegate: { _ in favoritesServiceExpectation.fulfill() },
            removeDelegate: { _ in XCTFail("Should be called in this test") }
        )

        let viewModel = self.viewModel(with: .success([]), delegate: delegate, favoritesService: favoritesService)
        wait(for: [expectation, favoritesServiceExpectation], timeout: 1)
        
        expectation = self.expectation(description: "FavoritesServiceDelegatel.favoriteRestaurantAdded")
        viewModel.favoriteRestaurantAdded(with: .random())
        wait(for: [expectation], timeout: 1)

        expectation = self.expectation(description: "FavoritesServiceDelegatel.favoriteRestaurantRemoved")
        viewModel.favoriteRestaurantRemoved(with: .random())
        wait(for: [expectation], timeout: 1)
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
    
    private func viewModel(with result: Result<[Restaurant]>,
                           delegate: RestaurantListViewModelDelegate? = nil,
                           sortingService: SortingServiceProtocol? = nil,
                           filteringService: FilteringServiceProtocol? = nil,
                           favoritesService: FavoritesServiceProtocol? = nil,
                           file: StaticString = #file,
                           line: UInt = #line) -> RestaurantListViewModel {
        let expectation = self.expectation(description: "RestaurantListViewModel.loadRestaurants")

        let provider = mockedRestaurantsProvider(with: result)
        let defaultDelegate = RestaurantListViewModelDelegateMock(
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
            delegate: delegate ?? defaultDelegate,
            restaurantsProvider: provider,
            sortingService: sortingService ?? SortingServiceMock.empty,
            filteringService: filteringService ?? FilteringServiceMock.empty,
            favoritesService: favoritesService ?? FavoritesServiceMock.empty
        )
        
        viewModel.loadRestaurants()
        
        if delegate != nil {
            expectation.fulfill()
        }

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
