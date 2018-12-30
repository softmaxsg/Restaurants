//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

extension SortingOption {
    
    static func random() -> SortingOption {
        return SortingOption.allCases.randomElement()!
    }
    
}
