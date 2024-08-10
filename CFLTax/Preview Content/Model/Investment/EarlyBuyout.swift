//
//  EarlyBuyout.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


public struct EarlyBuyout {
    public var amount: String
    public var exerciseDate: Date
    public var rentDueIsPaid: Bool
    
    
    init(amount: String, exerciseDate: Date, rentDueIsPaid: Bool) {
        self.amount = amount
        self.exerciseDate = exerciseDate
        self.rentDueIsPaid = rentDueIsPaid
    }
    
}
