//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

final class SortingOptionViewModelTests: XCTestCase {
    
    func testInitialization() {
        for option in SortingOption.allCases {
            let viewModel = SortingOptionViewModel(option: option)
            XCTAssertEqual(viewModel.title, option.rawValue)
            XCTAssertEqual(viewModel.value, option)
        }
    }
    
}
