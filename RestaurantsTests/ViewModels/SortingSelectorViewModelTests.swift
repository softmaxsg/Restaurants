//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

final class SortingSelectorViewModelTests: XCTestCase {
    
    func testOptionsProperty() {
        let expectedOptions = SortingOption.allCases.map(SortingOptionViewModel.init)
        let viewModel = SortingSelectorViewModel(delegate: SortingSelectorViewModelDelegateMock { _ in })
        XCTAssertEqual(viewModel.options as? [SortingOptionViewModel], expectedOptions)
    }

    func testChangeSorting() {
        let expectation = self.expectation(description: "SortingSelectorViewModelDelegate.sortingDidChange")
        let expectedOption = SortingOption.allCases.randomElement()!
        
        let delegate = SortingSelectorViewModelDelegateMock { option in
            XCTAssertEqual(option, expectedOption)
            expectation.fulfill()
        }
        
        let viewModel = SortingSelectorViewModel(delegate: delegate)
        viewModel.changeSorting(to: expectedOption)
        
        wait(for: [expectation], timeout: 1)
    }
}
