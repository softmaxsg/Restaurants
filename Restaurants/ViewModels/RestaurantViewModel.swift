//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol RestaurantViewModelProtocol {

    var isFavorite: Bool { get }
    var name: String { get }
    var openingState: String { get }
    
    var sortingOptionLabel: String { get }
    var sortingOptionValue: String { get }
    
    func toggleFavoriteState()
    
}

final class RestaurantViewModel: RestaurantViewModelProtocol {

    let isFavorite: Bool
    let name: String
    let openingState: String
    
    let sortingOptionLabel: String
    let sortingOptionValue: String
    
    private let toggleFavoriteStateCallback: () -> Void

    init(_ restaurant: Restaurant, sorting option: SortingOptionViewModelProtocol, toggleFavoriteStateCallback: @escaping () -> Void) {
        self.toggleFavoriteStateCallback = toggleFavoriteStateCallback

        isFavorite = restaurant.isFavorite
        name = restaurant.name
        openingState = restaurant.openingState.displayValue

        sortingOptionLabel = option.title
        let sortingValues = restaurant.sortingValues
        
        switch option.value {
        case .bestMatch:
            sortingOptionValue = RestaurantViewModel.sortingValuesFormatter().string(from: NSNumber(value: sortingValues.bestMatch))!
        case .newest:
            sortingOptionValue = RestaurantViewModel.sortingValuesFormatter().string(from: NSNumber(value: sortingValues.newest))!
        case .averageRating:
            sortingOptionValue = RestaurantViewModel.ratingFormatter().string(from: NSNumber(value: sortingValues.averageRating))!
        case .distance:
            sortingOptionValue = "\(sortingValues.distance)"
        case .popularity:
            sortingOptionValue = RestaurantViewModel.sortingValuesFormatter().string(from: NSNumber(value: sortingValues.popularity))!
        case .averageProductPrice:
            sortingOptionValue = RestaurantViewModel.moneyFormatter().string(from: NSDecimalNumber(decimal: sortingValues.averageProductPrice))!
        case .deliveryCost:
            sortingOptionValue = RestaurantViewModel.moneyFormatter().string(from: NSDecimalNumber(decimal: sortingValues.deliveryCost))!
        case .minimalCost:
            sortingOptionValue = RestaurantViewModel.moneyFormatter().string(from: NSDecimalNumber(decimal: sortingValues.minimalCost))!
        }
    }
    
    func toggleFavoriteState() {
        toggleFavoriteStateCallback()
    }

}

extension RestaurantViewModel {
    
    private class func sortingValuesFormatter() -> NumberFormatter {
        return numberFormatter(fractionDigits: 0)
    }
    
    private class func ratingFormatter() -> NumberFormatter {
        return numberFormatter(fractionDigits: 1)
    }
    
    private class func moneyFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        return formatter
    }
    
    private class func numberFormatter(fractionDigits: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter
    }

}

extension OpeningState {
    
    fileprivate var displayValue: String {
        return rawValue.localizedCapitalized
    }
    
}
