//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

extension Decimal {
    
    init(cents value: Int) {
        let sign: FloatingPointSign = value >= 0 ? .plus : .minus
        let mantissa = abs(value)
        self.init(sign: sign, exponent: -2, significand: Decimal(mantissa))
    }
    
    var cents: Int {
        return NSDecimalNumber(decimal: self).multiplying(byPowerOf10: 2).intValue
    }
    
}
