//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

final class RestaurantsProviderMock: RestaurantsProviderProtocol {

    typealias LoadAllImpl = (@escaping (Result<[RestaurantDetails]>) -> Void) -> Cancellable
    
    private let loadAllImpl: LoadAllImpl
    
    init(loadAll: @escaping LoadAllImpl) {
        self.loadAllImpl = loadAll
    }
    
    @discardableResult
    func loadAll(completion handler: @escaping (Result<[RestaurantDetails]>) -> Void) -> Cancellable {
        return loadAllImpl(handler)
    }

}
