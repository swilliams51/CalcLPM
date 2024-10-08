//
//  LeaseTerm.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


public struct LeaseTerm {
    public var baseCommenceDate: Date
    public var paymentFrequency: Frequency
    public var endOfMonthRule: Bool
    
    init(baseCommenceDate: Date, paymentFrequency: Frequency, eomRule: Bool = true) {
        self.baseCommenceDate = baseCommenceDate
        self.paymentFrequency = paymentFrequency
        self.endOfMonthRule = eomRule
    }
    
    public func isEqual(to other: LeaseTerm) -> Bool {
        var isEqual = false
        if baseCommenceDate != other.baseCommenceDate && paymentFrequency == other.paymentFrequency && endOfMonthRule == other.endOfMonthRule{
            isEqual = true
        }
        
        return isEqual
    }
}
