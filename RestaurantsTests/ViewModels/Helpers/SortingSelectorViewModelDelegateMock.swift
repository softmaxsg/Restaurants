//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

final class SortingSelectorViewModelDelegateMock: SortingSelectorViewModelDelegate {
        
    typealias SortingDidChangeImpl = (SortingOption) -> Void
    
    private let sortingDidChangeImpl: SortingDidChangeImpl
    
    init(sortingDidChange sortingDidChangeImpl: @escaping SortingDidChangeImpl) {
        self.sortingDidChangeImpl = sortingDidChangeImpl
    }
    
    func sortingDidChange(to option: SortingOption) {
        sortingDidChangeImpl(option)
    }

}
