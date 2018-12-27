//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

extension OpeningState {
    
    static func random() -> OpeningState {
        return OpeningState.allCases.randomElement()!
    }
    
}
