//
//  LeaseTerm.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


public struct LeaseTerm {
    public var baseCommenceDate: Date
    public var baseTermInMonths: Int
    public var paymentFrequency: Frequency
    public var endOfMonthRule: Bool = true
    
    init(baseCommenceDate: Date, baseTermInMonths: Int, paymentFrequency: Frequency) {
        self.baseCommenceDate = baseCommenceDate
        self.baseTermInMonths = baseTermInMonths
        self.paymentFrequency = paymentFrequency
    }
}
