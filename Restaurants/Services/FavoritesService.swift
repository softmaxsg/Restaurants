//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

enum FavoritesServiceError: Error {
    
    case alreadyExists
    case notFound
    
}

protocol FavoritesServiceDelegate: class {
    
    func favoriteRestaurantAdded(with name: String)
    func favoriteRestaurantRemoved(with name: String)
    
}

protocol FavoritesServiceProtocol {

    func isRestaurantFavorite(with name: String) -> Bool
    
    func addRestaurant(with name: String) throws
    func removeRestaurant(with name: String) throws
    
    func addDelegate(_ delegate: FavoritesServiceDelegate)
    func removeDelegate(_ delegate: FavoritesServiceDelegate)
    
}

final class FavoritesService: FavoritesServiceProtocol {
    
    private struct DelegateWrapper {
        
        weak var delegate: FavoritesServiceDelegate?
        
    }
    
    private var delegates: [DelegateWrapper] = []
    private var favorites: [FavoriteRestaurant]
    
    // For testing purpose
    init(initial favorites: [FavoriteRestaurant] = []) {
        self.favorites = favorites
    }
    
    func isRestaurantFavorite(with name: String) -> Bool {
        return favorites.contains { $0.name == name }
    }
    
    func addRestaurant(with name: String) throws {
        guard !favorites.contains(where: { $0.name == name }) else { throw FavoritesServiceError.alreadyExists }
        favorites.append(FavoriteRestaurant(name: name))
        delegates.forEach { $0.delegate?.favoriteRestaurantAdded(with: name) }
    }
    
    func removeRestaurant(with name: String) throws {
        guard let index = favorites.firstIndex(where: { $0.name == name }) else { throw FavoritesServiceError.notFound }
        favorites.remove(at: index)
        delegates.forEach { $0.delegate?.favoriteRestaurantRemoved(with: name) }
    }
    
    func addDelegate(_ delegate: FavoritesServiceDelegate) {
        guard delegates.first(where: searchPredicate(for: delegate)) == nil else { assertionFailure(); return }
        delegates.append(DelegateWrapper(delegate: delegate))
    }
    
    func removeDelegate(_ delegate: FavoritesServiceDelegate) {
        guard let index = delegates.firstIndex(where: searchPredicate(for: delegate)) else {
            // It's OK when one is not found in case called from deinit. In that case weak property is already `nil`
            return
        }
        delegates.remove(at: index)
    }
    
}

extension FavoritesService {
    
    private func searchPredicate(for delegate: FavoritesServiceDelegate) -> (DelegateWrapper) -> Bool {
        return { wrapper in
            guard let wrappedDelegate = wrapper.delegate else { return false }
            return delegate === wrappedDelegate
        }
    }
    
}
