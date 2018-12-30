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
        
        configureSearchController()
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

extension RestaurantsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filteringText = searchController.searchBar.text ?? ""
    }
    
}

extension RestaurantsViewController {
    
    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Filter restaurants"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
}
