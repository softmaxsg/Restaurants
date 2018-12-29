//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

final class SortingServiceMock: SortingServiceProtocol {
    
    typealias SortedImpl = ([RestaurantDetails], SortingOption) -> [RestaurantDetails]
    
    private let sortedImpl: SortedImpl
    
    init(sorted sortedImpl: @escaping SortedImpl) {
        self.sortedImpl = sortedImpl
    }
    
    func sorted(_ restaurants: [RestaurantDetails], option: SortingOption) -> [RestaurantDetails] {
        return sortedImpl(restaurants, option)
    }

}

extension SortingServiceMock {

    static var empty: SortingServiceMock {
        return SortingServiceMock { restaurants, _ in restaurants }
    }
    
}
