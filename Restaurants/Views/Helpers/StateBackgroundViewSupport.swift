//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import UIKit

protocol StateBackgroundViewSupport {
    
    var loadingBackgroundView: UIView? { get }
    var emptyBackgroundView: UIView? { get }
    var errorBackgroundView: ErrorView? { get }
    
    var currentState: DataState { get }
    func configureStateBackgroundView() -> UIView?
    
}

extension StateBackgroundViewSupport {
    
    func configureStateBackgroundView() -> UIView? {
        switch currentState {
        case .loading:
            return loadingBackgroundView
        case .data(let count):
            return count <= 0 ? emptyBackgroundView : nil
        case .error(let message):
            errorBackgroundView?.display(details: message)
            return errorBackgroundView
        }
    }
    
}

extension StateBackgroundViewSupport where Self: UITableViewController {
    
    func setStateBackgroundView(in tableView: UITableView) -> UIView? {
        tableView.backgroundView = configureStateBackgroundView()
        return tableView.backgroundView
    }
    
}
