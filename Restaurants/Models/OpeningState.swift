//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

enum OpeningState: String, CaseIterable, Decodable {
    
    case open = "open"
    case preorder = "order ahead"
    case closed = "closed"
    
}
