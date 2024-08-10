//
//  Fee.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


public struct Fee {
    public var amount: String
    public var datePaid: Date
    public var feeType: FeeType = .expense
    
    init(amount: String, datePaid: Date) {
        self.amount = amount
        self.datePaid = datePaid
    }
}
