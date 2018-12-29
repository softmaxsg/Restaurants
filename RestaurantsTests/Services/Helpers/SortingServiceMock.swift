//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

final class SortingServiceMock: SortingServiceProtocol {
    
    typealias SortedImpl = ([Restaurant], SortingOption, IsFavoriteCallback) -> [Restaurant]
    
    private let sortedImpl: SortedImpl
    
    init(sorted sortedImpl: @escaping SortedImpl) {
        self.sortedImpl = sortedImpl
    }
    
    func sorted(_ restaurants: [Restaurant], option: SortingOption, isFavoriteCallback: IsFavoriteCallback) -> [Restaurant] {
        return sortedImpl(restaurants, option, isFavoriteCallback)
    }

}

extension SortingServiceMock {

    static var empty: SortingServiceMock {
        return SortingServiceMock { restaurants, _, _ in restaurants }
    }
    
}
