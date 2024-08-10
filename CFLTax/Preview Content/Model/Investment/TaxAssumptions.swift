//
//  TaxAssumptions.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


public struct TaxAssumptions {
    public var federalTaxRate: String
    public var fiscalMonthEnd: TaxYearEnd
    public var dayOfMonPaid: Int
    
    init(federalTaxRate: String, fiscalMonthEnd: TaxYearEnd, dayOfMonPaid: Int) {
        self.federalTaxRate = federalTaxRate
        self.fiscalMonthEnd = fiscalMonthEnd
        self.dayOfMonPaid = dayOfMonPaid
    }
    
    
}
