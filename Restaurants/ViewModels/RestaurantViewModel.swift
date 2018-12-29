//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol RestaurantViewModelProtocol {

    var isFavorite: Bool { get }
    var name: String { get }
    var openingState: String { get }
    var bestMatch: String { get }
    var newest: String { get }
    var averageRating: String { get }
    var distance: String { get }
    var popularity: String { get }
    var averageProductPrice: String { get }
    var deliveryCost: String { get }
    var minimalCost: String { get }
    
    func toggleFavoriteState()
    
}

final class RestaurantViewModel: RestaurantViewModelProtocol {

    let isFavorite: Bool
    let name: String
    let openingState: String
    let bestMatch: String
    let newest: String
    let averageRating: String
    let distance: String
    let popularity: String
    let averageProductPrice: String
    let deliveryCost: String
    let minimalCost: String
    
    private let toggleFavoriteStateCallback: () -> Void

    init(_ restaurant: Restaurant, isFavorite: Bool, toggleFavoriteStateCallback: @escaping () -> Void) {
        self.toggleFavoriteStateCallback = toggleFavoriteStateCallback
        self.isFavorite = isFavorite

        name = restaurant.name
        openingState = restaurant.openingState.displayValue
        distance = "\(restaurant.sortingValues.distance)"

        let sortingValuesFormatter = RestaurantViewModel.numberFormatter(fractionDigits: 0)
        bestMatch = sortingValuesFormatter.string(from: NSNumber(value: restaurant.sortingValues.bestMatch))!
        newest = sortingValuesFormatter.string(from: NSNumber(value: restaurant.sortingValues.newest))!
        popularity = sortingValuesFormatter.string(from: NSNumber(value: restaurant.sortingValues.popularity))!
        
        let ratingFormatter = RestaurantViewModel.numberFormatter(fractionDigits: 1)
        averageRating = ratingFormatter.string(from: NSNumber(value: restaurant.sortingValues.averageRating))!
        
        let moneyFormatter = RestaurantViewModel.moneyFormatter()
        averageProductPrice = moneyFormatter.string(from: NSDecimalNumber(decimal: restaurant.sortingValues.averageProductPrice))!
        deliveryCost = moneyFormatter.string(from: NSDecimalNumber(decimal: restaurant.sortingValues.deliveryCost))!
        minimalCost = moneyFormatter.string(from: NSDecimalNumber(decimal: restaurant.sortingValues.minimalCost))!
    }
    
    func toggleFavoriteState() {
        toggleFavoriteStateCallback()
    }

}

extension RestaurantViewModel {
    
    private class func numberFormatter(fractionDigits: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter
    }
    
    private class func moneyFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        return formatter
    }
    
}

extension OpeningState {
    
    fileprivate var displayValue: String {
        return rawValue.localizedCapitalized
    }
    
}
