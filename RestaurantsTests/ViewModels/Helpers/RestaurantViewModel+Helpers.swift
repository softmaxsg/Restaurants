//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Restaurants

extension RestaurantViewModelProtocol {
    
    func isEqual(to restaurant: Restaurant, sorting option: SortingOption) -> Bool {
        let sortingValuesFormatter = numberFormatter(fractionDigits: 0)
        let ratingFormatter = numberFormatter(fractionDigits: 1)
        let moneyFormatter = self.moneyFormatter()
        
        guard isFavorite == restaurant.isFavorite else { return false }
        guard name == restaurant.name else { return false }
        guard openingState == restaurant.openingState.rawValue.localizedCapitalized else { return false }
        guard sortingOptionLabel == option.rawValue else { return false }

        let sortingValues = restaurant.sortingValues
        switch option {
        case .bestMatch: return sortingOptionValue == sortingValuesFormatter.string(from: NSNumber(value: sortingValues.bestMatch))!
        case .newest: return sortingOptionValue == sortingValuesFormatter.string(from: NSNumber(value: sortingValues.newest))!
        case .averageRating: return sortingOptionValue == ratingFormatter.string(from: NSNumber(value: sortingValues.averageRating))!
        case .distance: return sortingOptionValue == "\(sortingValues.distance)"
        case .popularity: return sortingOptionValue == sortingValuesFormatter.string(from: NSNumber(value: sortingValues.popularity))!
        case .averageProductPrice: return sortingOptionValue == moneyFormatter.string(from: NSDecimalNumber(decimal: sortingValues.averageProductPrice))!
        case .deliveryCost: return sortingOptionValue == moneyFormatter.string(from: NSDecimalNumber(decimal: sortingValues.deliveryCost))!
        case .minimalCost: return sortingOptionValue == moneyFormatter.string(from: NSDecimalNumber(decimal: sortingValues.minimalCost))!
        }
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
