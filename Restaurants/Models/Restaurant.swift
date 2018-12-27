//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

struct Restaurant: Equatable {
    
    let name: String
    let openingState: OpeningState
    let sortingValues: SortingValues
    
}

extension Restaurant: Decodable {
    
    enum CodingKeys: String, CaseIterable, CodingKey {
        
        case name
        case openingState = "status"
        case sortingValues
        
    }

}
