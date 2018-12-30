//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

final class SortingSelectorViewModelMock: SortingSelectorViewModelProtocol {

    typealias ChangeSortingImpl = (SortingOption) -> Void

    private let changeSortingImpl: ChangeSortingImpl

    private(set) var options: [SortingOptionViewModelProtocol]

    init(options: [SortingOptionViewModelProtocol], changeSorting changeSortingImpl: @escaping ChangeSortingImpl) {
        self.options = options
        self.changeSortingImpl = changeSortingImpl
    }
    
    func changeSorting(to option: SortingOption) {
        changeSortingImpl(option)
    }
    
}
