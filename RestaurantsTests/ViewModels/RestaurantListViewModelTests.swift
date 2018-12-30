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
        let expectedRestaurants: [Restaurant] = initialRestaurants.shuffled()
        
        var sortingServiceCalls = 0
        let sortingService = SortingServiceMock { restaurants, option in
            sortingServiceCalls += 1
            switch sortingServiceCalls {
            case 1:
                XCTAssertEqual(option, SortingOption.bestMatch)
                return restaurants
                
            case 2:
                XCTAssertEqual(option, expectedSortingOption)
                return expectedRestaurants
            
            default:
                XCTFail("Called too many times")
                return []
            }
        }
        
        let viewModel = self.viewModel(with: .success(initialRestaurants), sortingService: sortingService, actions: { viewModel in
            viewModel.sortingOption = expectedSortingOption
            return 1
        })
        
        compareItems(in: viewModel, with: expectedRestaurants)
    }
    
    func testFiltering() {
        let expectedFilteringText = String.random()
        let expectedRestaurants = initialRestaurants.filter { _ in .random() }
        
        var filteringServiceCalls = 0
        let filteringService = FilteringServiceMock { restaurants, text in
            filteringServiceCalls += 1
            switch filteringServiceCalls {
            case 1:
                XCTAssertTrue(text.isEmpty)
                return restaurants
                
            case 2:
                XCTAssertEqual(text, expectedFilteringText)
                return expectedRestaurants
                
            default:
                XCTFail("Called too many times")
                return []
            }
        }
        
        let viewModel = self.viewModel(with: .success(self.initialRestaurants), filteringService: filteringService, actions: { viewModel in
            viewModel.filteringText = expectedFilteringText
            return 1
        })
        
        compareItems(in: viewModel, with: expectedRestaurants)
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
    
    func testFavoritesService() {
        let isRestaurantFavorite: (String) -> Bool = { name in
            self.initialRestaurants.first(where: { $0.name == name })!.isFavorite
        }
        
        let favoritesService = FavoritesServiceMock(
            isRestaurantFavorite: isRestaurantFavorite,
            addRestaurant: { _ in XCTFail("Should be called in this test") },
            removeRestaurant: { _ in XCTFail("Should be called in this test") },
            addDelegate: { _ in },
            removeDelegate: { _ in XCTFail("Should be called in this test") }
        )
        
        let viewModel = self.viewModel(with: .success(initialRestaurants), favoritesService: favoritesService)
        for (index, restaurant) in initialRestaurants.enumerated() {
            let item = try! viewModel.item(at: index)
            XCTAssertEqual(item.isFavorite, restaurant.isFavorite)
        }
    }
    
    func testToggleFavoriteState() {
        let isRestaurantFavorite: (String) -> Bool = { name in
            self.initialRestaurants.first(where: { $0.name == name })!.isFavorite
        }
        
        let expectation = self.expectation(description: "FavoritesService.addRestaurant or removeRestaurant")
        let favoritesService = FavoritesServiceMock(
            isRestaurantFavorite: isRestaurantFavorite,
            addRestaurant: {
                XCTAssertFalse(isRestaurantFavorite($0), "Item is already favorite")
                expectation.fulfill()
            },
            removeRestaurant: {
                XCTAssertTrue(isRestaurantFavorite($0), "Item is not favorite")
                expectation.fulfill()
            },
            addDelegate: { _ in },
            removeDelegate: { _ in XCTFail("Should be called in this test") }
        )
        
        let viewModel = self.viewModel(with: .success(initialRestaurants), favoritesService: favoritesService)
        expectation.expectedFulfillmentCount = viewModel.itemsCount
        
        (0..<viewModel.itemsCount).forEach { index in
            let item = try! viewModel.item(at: index)
            item.toggleFavoriteState()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    // Just making sure it's the instance of the specific class is enough since that class is tested separately
    func testSortingSelectorViewModel() {
        let viewModel = self.viewModel(with: .success(initialRestaurants))
        let sortingSelectorViewModel = viewModel.sortingSelectorViewModel
        XCTAssertTrue(type(of: sortingSelectorViewModel) == SortingSelectorViewModel.self)
    }

}

extension RestaurantListViewModelTests {
    
    private enum MockError: Error { case some }
    
    private func mockedRestaurantsProvider(with result: Result<[RestaurantDetails]>) -> RestaurantsProviderProtocol {
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
                           actions: ((RestaurantListViewModel) -> Int)? = nil,
                           file: StaticString = #file,
                           line: UInt = #line) -> RestaurantListViewModel {
        var expectation = self.expectation(description: "RestaurantListViewModel.loadRestaurants")

        let provider = mockedRestaurantsProvider(with: result.map { $0.map(RestaurantDetails.init) })
        let defaultDelegate = RestaurantListViewModelDelegateMock(
            itemsDidUpdate: {
                XCTAssertTrue(OperationQueue.current! === OperationQueue.main, "Delegate method has to be called on the main thread")
                switch result {
                case .success: expectation.fulfill()
                case .failure: XCTFail("Should be called in this test", file: file, line: line)
                }
            },
            itemsUpdateDidFail: { error in
                XCTAssertTrue(OperationQueue.current! === OperationQueue.main, "Delegate method has to be called on the main thread")
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
        
        if let actions = actions {
            expectation = self.expectation(description: "RestaurantListViewModelDelegate.itemsDidUpdate")
            expectation.expectedFulfillmentCount = actions(viewModel)
            wait(for: [expectation], timeout: 1)
        }
        
        return viewModel
    }
    
    private func compareItems(in viewModel: RestaurantListViewModel, with restaurants: [Restaurant], file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(viewModel.itemsCount, restaurants.count, "RestaurantViewModel contains \(viewModel.itemsCount) items but expected \(restaurants.count)", file: file, line: line)
        
        for (index, restaurant) in restaurants.enumerated() {
            let item = try! viewModel.item(at: index)
            XCTAssertTrue(item.isEqual(to: restaurant, sorting: viewModel.sortingOption), "RestaurantViewModel at index \(index) does not match corresponding Restaurant objct", file: file, line: line)
        }
    }

}
