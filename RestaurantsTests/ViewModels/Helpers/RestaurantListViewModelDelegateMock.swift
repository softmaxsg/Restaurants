//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

final class RestaurantListViewModelDelegateMock: RestaurantListViewModelDelegate {
    
    typealias StateDidChangeImpl = () -> Void

    private let stateDidChangeImpl: StateDidChangeImpl

    init(stateDidChange stateDidChangeImpl: @escaping StateDidChangeImpl) {
        self.stateDidChangeImpl = stateDidChangeImpl
    }
    
    func stateDidChange() {
        stateDidChangeImpl()
    }

}
