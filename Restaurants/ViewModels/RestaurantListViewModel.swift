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
    private let favoritesService: FavoritesServiceProtocol

    private let operationQueue = OperationQueue()
    private var restaurants: [Restaurant] = [] { didSet { updateItems() } }
    private var items: [RestaurantViewModelProtocol] = []

    init(delegate: RestaurantListViewModelDelegate,
         restaurantsProvider: RestaurantsProviderProtocol,
         sortingService: SortingServiceProtocol,
         filteringService: FilteringServiceProtocol,
         favoritesService: FavoritesServiceProtocol) {
        self.delegate = delegate
        self.restaurantsProvider = restaurantsProvider
        self.sortingService = sortingService
        self.filteringService = filteringService
        self.favoritesService = favoritesService
        
        favoritesService.addDelegate(self)
    }

    var sortingOption: SortingOption = .bestMatch { didSet { updateItems() } }
    var filteringText: String = "" { didSet { updateItems() } }
    
    var itemsCount: Int { return items.count }
    
    func item(at index: Int) throws -> RestaurantViewModelProtocol {
        return try items.item(at: index)
    }
    
    func loadRestaurants() {
        restaurantsProvider.loadAll { [weak self] result in
            self?.operationQueue.addOperation {
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

extension RestaurantListViewModel: FavoritesServiceDelegate {
    
    func favoriteRestaurantAdded(with name: String) {
        updateItems()
    }
    
    func favoriteRestaurantRemoved(with name: String) {
        updateItems()
    }
    
}

extension RestaurantListViewModel {

    private func updateItems() {
        let filteredRestaurants = filteringService.filtered(restaurants, using: filteringText)

        let favoriteStatesMap = filteredRestaurants.reduce(into: [String: Bool]()) { result, restaurant in
            result[restaurant.name] = favoritesService.isRestaurantFavorite(with: restaurant.name)
        }
        
        let sortedRestaurants = sortingService.sorted(filteredRestaurants, option: sortingOption) { restaurant in
            favoriteStatesMap[restaurant.name] ?? false
        }
        
        let items = sortedRestaurants.map { restaurant -> RestaurantViewModel in
            let restaurantName = restaurant.name
            return RestaurantViewModel(restaurant, isFavorite: favoriteStatesMap[restaurantName] ?? false) { [weak self] in
                self?.toggleFavoriteState(for: restaurantName)
            }
        }
        
        OperationQueue.main.addOperation {
            self.items = items
            self.delegate?.itemsDidUpdate()
        }
    }
    
    private func handleLoadingError(_ error: Error) {
        OperationQueue.main.addOperation {
            self.delegate?.itemsLoadDidFail(with: error)
        }
    }
    
    private func toggleFavoriteState(for restaurantName: String) {
        if favoritesService.isRestaurantFavorite(with: restaurantName) {
            try? favoritesService.removeRestaurant(with: restaurantName)
        } else {
            try? favoritesService.addRestaurant(with: restaurantName)
        }
    }

}
