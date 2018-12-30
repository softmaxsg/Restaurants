//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

final class SortingSelectorControllerTests: XCTestCase {
    
    func testInitialization() {
        let sortingOptions = SortingOption.allCases.filter({ _ in .random() }).map(SortingOptionViewModel.init)
        let viewModel = SortingSelectorViewModelMock(options: sortingOptions) { _ in }
        let controller = SortingSelectorController(viewModel: viewModel).viewController as! UIAlertController
        XCTAssertEqual(controller.preferredStyle, .actionSheet)
        
        for (index, action) in controller.actions.dropLast().enumerated() {
            XCTAssertTrue(action.isEnabled)
            XCTAssertEqual(action.style, .default)
            XCTAssertEqual(action.title, sortingOptions[index].title)
        }
        
        XCTAssertEqual(controller.actions.last!.style, .cancel)
    }
    
}
