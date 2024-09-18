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
    public var amortizationMethod: FeeAmortizationMethod = .daily
    
    init(amount: String, feeType: FeeType = .expense, datePaid: Date = Date()) {
        self.amount = amount
        self.datePaid = datePaid
        self.feeType = feeType
    }
}
