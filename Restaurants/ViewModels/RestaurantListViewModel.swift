//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol RestaurantListViewModelDelegate: class {
    
    func itemsDidUpdate()
    func itemsLoadDidFail(with error: Error)
    
}

protocol RestaurantListViewModelProtocol {
    
    var sortingOption: SortingOption { get set }
    var filteringText: String { get set }
    
    var itemsCount: Int { get }
    func item(at index: Int) throws -> RestaurantViewModelProtocol
    
    func loadRestaurants()
}

final class RestaurantListViewModel: RestaurantListViewModelProtocol {
    
    private weak var delegate: RestaurantListViewModelDelegate?
    
    private let restaurantsProvider: RestaurantsProviderProtocol
    private let sortingService: SortingServiceProtocol
    private let filteringService: FilteringServiceProtocol
    
    private var restaurants: [Restaurant] = [] { didSet { updateItems() } }
    private var items: [RestaurantViewModelProtocol] = []

    init(delegate: RestaurantListViewModelDelegate,
         restaurantsProvider: RestaurantsProviderProtocol,
         sortingService: SortingServiceProtocol,
         filteringService: FilteringServiceProtocol) {
        self.delegate = delegate
        self.restaurantsProvider = restaurantsProvider
        self.sortingService = sortingService
        self.filteringService = filteringService
    }

    var sortingOption: SortingOption = .bestMatch { didSet { updateItems() } }
    var filteringText: String = "" { didSet { updateItems() } }
    
    var itemsCount: Int { return items.count }
    
    func item(at index: Int) throws -> RestaurantViewModelProtocol {
        return try items.item(at: index)
    }
    
    func loadRestaurants() {
        restaurantsProvider.loadAll { [weak self] result in
            OperationQueue.main.addOperation {
                switch result {
                case .success(let restaurants):
                    self?.restaurants = restaurants
                    
                case .failure(let error):
                    self?.handleLoadingError(error)
                }
            }
        }
    }
    
}

extension RestaurantListViewModel {

    private func updateItems() {
        let filteredRestaurants = filteringService.filtered(restaurants, using: filteringText)
        let sortedRestaurants = sortingService.sorted(filteredRestaurants, option: sortingOption)
        items = sortedRestaurants.map(RestaurantViewModel.init)        
        delegate?.itemsDidUpdate()
    }
    
    private func handleLoadingError(_ error: Error) {
        delegate?.itemsLoadDidFail(with: error)
    }

}
