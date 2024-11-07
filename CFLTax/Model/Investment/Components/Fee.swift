//
//  Fee.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


public struct Fee {
    public var amount: String
    public var feeType: FeeType
    public var datePaid: Date
    public var hasChanged: Bool = false
    
    init(amount: String, feeType: FeeType = .expense, datePaid: Date = Date()) {
        self.amount = amount
        self.datePaid = datePaid
        self.feeType = feeType
    }
    
    init() {
        amount = "0.00"
        feeType = .expense
        datePaid = Date()
    }
    
    
    func isEqual(to other: Fee) -> Bool {
        var isEqual: Bool = false
        if amount == other.amount && feeType == other.feeType && datePaid == other.datePaid {
            isEqual = true
        }
        return isEqual
    }

}
