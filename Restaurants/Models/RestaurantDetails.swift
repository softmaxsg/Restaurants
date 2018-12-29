//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

struct RestaurantDetails: Equatable {
    
    let name: String
    let openingState: OpeningState
    let sortingValues: SortingValues
    
}

extension RestaurantDetails: Decodable {
    
    enum CodingKeys: String, CaseIterable, CodingKey {
        
        case name
        case openingState = "status"
        case sortingValues
        
    }

}
