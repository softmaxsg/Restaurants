//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol RestaurantListViewModelProtocol {
    
    var itemsCount: Int { get }
    func item(at index: Int) throws -> RestaurantViewModelProtocol
    
}

final class RestaurantListViewModel: RestaurantListViewModelProtocol {
    
    private var items: [RestaurantViewModelProtocol]

    // Temporary for testing purposes
    init(_ items: [Restaurant] = []) {
        self.items = items.map(RestaurantViewModel.init)
    }
    
    var itemsCount: Int { return items.count }
    
    func item(at index: Int) throws -> RestaurantViewModelProtocol {
        return try items.item(at: index)
    }
    
}
