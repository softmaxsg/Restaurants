//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import UIKit

final class SortingSelectorController {
    
    let viewController: UIViewController
    
    init(viewModel: SortingSelectorViewModelProtocol) {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        for option in viewModel.options {
            actionSheetController.addAction(UIAlertAction(
                title: option.title,
                style: .default) { _ in
                    viewModel.changeSorting(to: option.value)
                }
            )
        }
        
        actionSheetController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        viewController = actionSheetController
    }
    
}
