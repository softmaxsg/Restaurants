//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

public func == (lhs: RestaurantViewModelProtocol, rhs: Restaurant) -> Bool {
    return lhs.isEqual(to: rhs)
}

public func == (lhs: Restaurant, rhs: RestaurantViewModelProtocol) -> Bool {
    return rhs.isEqual(to: lhs)
}

extension RestaurantViewModelProtocol {
    
    func isEqual(to restaurant: Restaurant) -> Bool {
        let sortingValuesFormatter = numberFormatter(fractionDigits: 0)
        let ratingFormatter = numberFormatter(fractionDigits: 1)
        let moneyFormatter = self.moneyFormatter()
        
        return isFavorite == restaurant.isFavorite &&
            name == restaurant.name &&
            openingState == restaurant.openingState.rawValue.localizedCapitalized &&
            distance == "\(restaurant.sortingValues.distance)" &&
            bestMatch == sortingValuesFormatter.string(from: NSNumber(value: restaurant.sortingValues.bestMatch))! &&
            newest == sortingValuesFormatter.string(from: NSNumber(value: restaurant.sortingValues.newest))! &&
            popularity == sortingValuesFormatter.string(from: NSNumber(value: restaurant.sortingValues.popularity))! &&
            averageRating == ratingFormatter.string(from: NSNumber(value: restaurant.sortingValues.averageRating))! &&
            averageProductPrice == moneyFormatter.string(from: NSDecimalNumber(decimal: restaurant.sortingValues.averageProductPrice))! &&
            deliveryCost == moneyFormatter.string(from: NSDecimalNumber(decimal: restaurant.sortingValues.deliveryCost))! &&
            minimalCost == moneyFormatter.string(from: NSDecimalNumber(decimal: restaurant.sortingValues.minimalCost))!
    }

}

extension RestaurantViewModelProtocol {

    private func numberFormatter(fractionDigits: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter
    }
    
    private func moneyFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        return formatter
    }

}
