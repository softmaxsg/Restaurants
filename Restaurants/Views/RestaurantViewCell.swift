//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import UIKit

final class RestaurantViewCell: UITableViewCell {
 
    @IBOutlet weak var favoriteButton: UIButton?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var openingStateLabel: UILabel?
    @IBOutlet weak var sortingTypeLabel: UILabel?
    @IBOutlet weak var sortingValueLabel: UILabel?
    
    private var viewModel: RestaurantViewModelProtocol?
    
    func configure(with viewModel: RestaurantViewModelProtocol) {
        self.viewModel = viewModel
        
        favoriteButton?.isSelected = viewModel.isFavorite
        nameLabel?.text = viewModel.name
        openingStateLabel?.text = viewModel.openingState
        sortingTypeLabel?.text = viewModel.sortingOptionLabel
        sortingValueLabel?.text = viewModel.sortingOptionValue
    }
    
    @IBAction func favoriteButtonDidTap() {
        viewModel?.toggleFavoriteState()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
    
}

