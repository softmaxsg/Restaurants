//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol SortingOptionViewModelProtocol {
    
    var title: String { get }
    var value: SortingOption { get }
    
}

struct SortingOptionViewModel: SortingOptionViewModelProtocol, Equatable {
    
    let title: String
    let value: SortingOption
    
    init(option: SortingOption) {
        value = option
        title = option.rawValue
    }
    
}
