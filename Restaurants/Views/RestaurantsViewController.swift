//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import UIKit

final class RestaurantsViewController: UITableViewController, StateBackgroundViewSupport {

    private enum CellIdentifier: String {
        
        case restaurant = "Restaurant"
        
    }
   
    @IBOutlet weak var changeSortingButton: UIBarButtonItem?
    @IBOutlet weak var loadingBackgroundView: UIView?
    @IBOutlet weak var emptyBackgroundView: UIView?
    @IBOutlet weak var errorBackgroundView: ErrorView?

    private let assembly = RestaurantsAssembly()
    private lazy var viewModel = assembly.restaurantsViewModel(delegate: self)
    var currentState = DataState.loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RestaurantViewCell.register(in: tableView, with: CellIdentifier.restaurant.rawValue)
        
        updateControls()
        viewModel.loadRestaurants()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return setStateBackgroundView(in: tableView) == nil ? 1 : 0
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
        currentState = .data(count: viewModel.itemsCount)
        updateControls()
        
        tableView.reloadData()
    }
    
    func itemsLoadDidFail(with error: Error) {
        currentState = .error(message: error.localizedDescription)
        updateControls()
        
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
    
    private func updateControls() {
        switch currentState {
        case .data:
            changeSortingButton?.isEnabled = true
            if navigationItem.searchController == nil {
                configureSearchController()
            }
            
        default:
            changeSortingButton?.isEnabled = false
            navigationItem.searchController = nil
        }
    }

}
