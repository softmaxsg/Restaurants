//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import UIKit

final class RestaurantsAssembly {
    
    func restaurantsViewModel(delegate: RestaurantListViewModelDelegate) -> RestaurantListViewModel {
        return RestaurantListViewModel(
            delegate: delegate,
            restaurantsProvider: RestaurantsProvider(),
            sortingService: SortingService(),
            filteringService: FilteringService(),
            favoritesService: FavoritesService(storageService: FavoritesStorageService())
        )
    }
    
    func sortingSelectorViewController(with viewModel: SortingSelectorViewModelProtocol) -> UIViewController {
        let sortingSelectorController = SortingSelectorController(viewModel: viewModel)
        return sortingSelectorController.viewController
    }
    
}
