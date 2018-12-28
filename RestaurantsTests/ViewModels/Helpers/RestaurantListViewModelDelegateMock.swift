//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

final class RestaurantListViewModelDelegateMock: RestaurantListViewModelDelegate {
    
    typealias ItemsDidUpdateImpl = () -> Void
    typealias ItemsUpdateDidFailImpl = (Error) -> Void

    private let itemsDidUpdateImpl: ItemsDidUpdateImpl
    private let itemsUpdateDidFailImpl: ItemsUpdateDidFailImpl

    init(itemsDidUpdate itemsDidUpdateImpl: @escaping ItemsDidUpdateImpl,
         itemsUpdateDidFail itemsUpdateDidFailImpl: @escaping ItemsUpdateDidFailImpl) {
        self.itemsDidUpdateImpl = itemsDidUpdateImpl
        self.itemsUpdateDidFailImpl = itemsUpdateDidFailImpl
    }
    
    func itemsDidUpdate() {
        itemsDidUpdateImpl()
    }
    
    func itemsUpdateDidFail(with error: Error) {
        itemsUpdateDidFailImpl(error)
    }

}
