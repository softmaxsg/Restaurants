//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol FavoritesStorageServiceProtocol {
    
    func loadAll() -> [FavoriteRestaurant]
    func saveAll(_ restaurants: [FavoriteRestaurant])
    
}

final class FavoritesStorageService: FavoritesStorageServiceProtocol {
    
    private static let storageURL: URL = {
        let fileManager = FileManager.default
        // That's really weird if there is no documents directory and there is no way to recover from this error. So, `!` should be fine here
        let documentDirectory = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documentDirectory.appendingPathComponent("favorites.dat")
    }()
    
    private let storageURL: URL
    
    // For testing purposes
    init(url: URL = FavoritesStorageService.storageURL) {
        self.storageURL = url
    }
    
    func loadAll() -> [FavoriteRestaurant] {
        guard let data = try? Data(contentsOf: storageURL) else { return [] }
        return (try? PropertyListDecoder().decode([FavoriteRestaurant].self, from: data)) ?? []
    }
    
    func saveAll(_ restaurants: [FavoriteRestaurant]) {
        guard let data = try? PropertyListEncoder().encode(restaurants) else { return }
        try? data.write(to: storageURL)
    }
    
}
