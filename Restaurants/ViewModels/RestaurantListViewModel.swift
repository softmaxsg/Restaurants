//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol RestaurantListViewModelDelegate: class {
    
    func itemsDidUpdate()
    func itemsUpdateDidFail(with error: Error)
    
}

protocol RestaurantListViewModelProtocol {
    
    var itemsCount: Int { get }
    func item(at index: Int) throws -> RestaurantViewModelProtocol
    
    func loadRestaurants()
}

final class RestaurantListViewModel: RestaurantListViewModelProtocol {
    
    private weak var delegate: RestaurantListViewModelDelegate?
    private let restaurantsProvider: RestaurantsProviderProtocol
    private var items: [RestaurantViewModelProtocol] = []

    init(delegate: RestaurantListViewModelDelegate,
         restaurantsProvider: RestaurantsProviderProtocol) {
        self.delegate = delegate
        self.restaurantsProvider = restaurantsProvider
    }
    
    var itemsCount: Int { return items.count }
    
    func item(at index: Int) throws -> RestaurantViewModelProtocol {
        return try items.item(at: index)
    }
    
    func loadRestaurants() {
        restaurantsProvider.loadAll { [weak self] result in
            OperationQueue.main.addOperation {
                switch result {
                case .success(let restaurants):
                    self?.updateItems(with: restaurants)
                    
                case .failure(let error):
                    self?.handleLoadingError(error)
                }
            }
        }
    }
    
}

extension RestaurantListViewModel {

    private func updateItems(with restaurants: [Restaurant]) {
        items = restaurants.map(RestaurantViewModel.init)
        delegate?.itemsDidUpdate()
    }
    
    private func handleLoadingError(_ error: Error) {
        delegate?.itemsUpdateDidFail(with: error)
    }

}
