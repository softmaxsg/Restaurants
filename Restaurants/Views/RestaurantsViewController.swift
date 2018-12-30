//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import UIKit

final class RestaurantsViewController: UITableViewController {

    private enum CellIdentifier: String {
        
        case restaurant = "Restaurant"
        
    }
    
    private let assembly = RestaurantsAssembly()
    private lazy var viewModel = assembly.restaurantsViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadRestaurants()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.restaurant.rawValue, for: indexPath)
        if let cell = cell as? RestaurantViewCell, let item = try? viewModel.item(at: indexPath.row) {
            cell.configure(with: item)
        } else {
            assertionFailure()
        }
        
        return cell
    }
    
    @IBAction func sortingButtonDidTap() {
        let controller = assembly.sortingSelectorViewController(with: viewModel.sortingSelectorViewModel)
        present(controller, animated: true)
    }
    
}

extension RestaurantsViewController: RestaurantListViewModelDelegate {
    
    func itemsDidUpdate() {
        tableView.reloadData()
    }
    
    func itemsLoadDidFail(with error: Error) {
        tableView.reloadData()
    }
    
}
