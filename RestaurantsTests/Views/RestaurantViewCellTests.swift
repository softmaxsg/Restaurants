//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Restaurants

class RestaurantViewCellTests: XCTestCase {
    
    private let defaultWidth = 350
    
    private lazy var cell: RestaurantViewCell = {
        return view(nibName: "RestaurantViewCell") as RestaurantViewCell
    }()

    func testNormalAppearance() {
        let cell = self.cell
        let viewModel = RestaurantViewModel(
            Restaurant(
                isFavorite: false,
                name: "Just one of those restaurants",
                openingState: .preorder,
                sortingValues: .random(averageProductPrice: 12.5)
            ), sorting: .averageProductPrice) { }
        
        cell.configure(with: viewModel)
        adjustSize(for: cell)
        
        snapshotVerifyView(cell)
    }

    func testFavoritedAppearance() {
        let cell = self.cell
        let viewModel = RestaurantViewModel(
            Restaurant(
                isFavorite: true,
                name: "My favorite restaurant",
                openingState: .open,
                sortingValues: .random(minimalCost: 7.5)
        ), sorting: .minimalCost) { }
        
        cell.configure(with: viewModel)
        adjustSize(for: cell)
        
        snapshotVerifyView(cell)
    }
    
}

extension RestaurantViewCellTests {
    
    func adjustSize(for view: UIView) {
        let height = view.systemLayoutSizeFitting(CGSize(width: defaultWidth, height: Int.max)).height
        cell.frame = CGRect(x: 0, y: 0, width: CGFloat(defaultWidth), height: height)
    }
    
}
