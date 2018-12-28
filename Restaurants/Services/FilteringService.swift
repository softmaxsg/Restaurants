//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol FilteringServiceProtocol {
    
    func filtered(_ restaurants: [Restaurant], using text: String) -> [Restaurant]
    
}

final class FilteringService: FilteringServiceProtocol {

    func filtered(_ restaurants: [Restaurant], using text: String) -> [Restaurant] {
        guard !text.isEmpty else { return restaurants }
        return restaurants.filter { restaurant in
            return restaurant.name.localizedCaseInsensitiveContains(text)
        }
    }
    
}
