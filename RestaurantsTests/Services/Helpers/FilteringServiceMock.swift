//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

final class FilteringServiceMock: FilteringServiceProtocol {
    
    typealias FilteredImpl = ([Restaurant], String) -> [Restaurant]
    
    private let filteredImpl: FilteredImpl
    
    init(filtered filteredImpl: @escaping FilteredImpl) {
        self.filteredImpl = filteredImpl
    }
    
    func filtered(_ restaurants: [Restaurant], using text: String) -> [Restaurant] {
        return filteredImpl(restaurants, text)
    }
    
}

extension FilteringServiceMock {
    
    static var empty: FilteringServiceMock {
        return FilteringServiceMock { restaurants, _ in restaurants }
    }
    
}
