//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol SortingSelectorViewModelDelegate: class {
    
    func sortingDidChange(to option: SortingOption)
    
}

protocol SortingSelectorViewModelProtocol {

    var options: [SortingOptionViewModelProtocol] { get }
    
    func changeSorting(to option: SortingOption)
    
}

final class SortingSelectorViewModel: SortingSelectorViewModelProtocol {

    private weak var delegate: SortingSelectorViewModelDelegate?
    
    let options: [SortingOptionViewModelProtocol] = SortingOption.allCases.map(SortingOptionViewModel.init)

    init(delegate: SortingSelectorViewModelDelegate) {
        self.delegate = delegate
    }
    
    func changeSorting(to option: SortingOption) {
        delegate?.sortingDidChange(to: option)
    }
    
}
