//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

enum DataState {
    
    case loading
    case data(count: Int)
    case error(message: String)
    
}
