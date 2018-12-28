//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

final class SortingServiceMock: SortingServiceProtocol {
    
    typealias SortedImpl = ([Restaurant], SortingOption) -> [Restaurant]
    
    private let sortedImpl: SortedImpl
    
    init(sorted sortedImpl: @escaping SortedImpl) {
        self.sortedImpl = sortedImpl
    }
    
    func sorted(_ restaurants: [Restaurant], option: SortingOption) -> [Restaurant] {
        return sortedImpl(restaurants, option)
    }
    
}
