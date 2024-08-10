//
//  Validations.swift
//  CFLTax
//
//  Created by Steven Williams on 8/9/24.
//

import Foundation


func isAmountValid(strAmount: String, decLow: Decimal, decHigh: Decimal, inclusiveLow:  Bool, inclusiveHigh: Bool) -> Bool {
    // IsDecimal
    if strAmount.isDecimal() == false {
        return false
    }
    // Convert to decimal
    let decAmount = strAmount.toDecimal()
    
    if inclusiveLow == true {
        if decAmount < decLow {
            return false
        }
    } else {
        if decAmount <= decLow {
            return false
        }
    }
    if inclusiveHigh == true {
        if decAmount > decHigh {
            return false
        }
    } else {
        if decAmount >= decHigh {
            return false
        }
    }

    return true
}
