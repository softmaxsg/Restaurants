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
    
    var itemsCount: Int { get }
    func item(at index: Int) throws -> RestaurantViewModelProtocol
    
    func loadRestaurants()
}

final class RestaurantListViewModel: RestaurantListViewModelProtocol {
    
    private weak var delegate: RestaurantListViewModelDelegate?
    
    private let restaurantsProvider: RestaurantsProviderProtocol
    private let sortingService: SortingServiceProtocol
    
    private var restaurants: [Restaurant] = [] { didSet { updateItems(with: restaurants) } }
    private var items: [RestaurantViewModelProtocol] = []

    init(delegate: RestaurantListViewModelDelegate,
         restaurantsProvider: RestaurantsProviderProtocol,
         sortingService: SortingServiceProtocol) {
        self.delegate = delegate
        self.restaurantsProvider = restaurantsProvider
        self.sortingService = sortingService
    }

    var sortingOption: SortingOption = .bestMatch { didSet { updateItems(with: restaurants) } }
    
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

    private func updateItems(with restaurants: [Restaurant]) {
        items = sortingService.sorted(restaurants, option: sortingOption).map(RestaurantViewModel.init)
        delegate?.itemsDidUpdate()
    }
    
    private func handleLoadingError(_ error: Error) {
        delegate?.itemsLoadDidFail(with: error)
    }

}
