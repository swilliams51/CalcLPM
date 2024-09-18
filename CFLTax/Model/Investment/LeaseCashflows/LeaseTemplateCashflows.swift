//
//  LeaseTemplateCashflows.swift
//  CFLTax
//
//  Created by Steven Williams on 9/18/24.
//

import Foundation

@Observable
public class LeaseTemplateCashflows: Cashflows {
    
    public func createTemplate(aInvestment: Investment) {
        let myCashflow: Cashflow = Cashflow(dueDate: aInvestment.asset.fundingDate, amount: "0.0")
        self.add(item: myCashflow)
        
        if aInvestment.leaseTerm.baseCommenceDate !=  aInvestment.asset.fundingDate {
            let myCashflow: Cashflow = Cashflow(dueDate: aInvestment.leaseTerm.baseCommenceDate, amount: "0.0")
            self.add(item: myCashflow)
        }
        
        var nextLeaseDate: Date = addOnePeriodToDate(dateStart: aInvestment.leaseTerm.baseCommenceDate, payPerYear: aInvestment.leaseTerm.paymentFrequency, dateRefer: aInvestment.leaseTerm.baseCommenceDate, bolEOMRule: aInvestment.leaseTerm.endOfMonthRule)
        while nextLeaseDate <= aInvestment.getLeaseMaturityDate() {
            let myCashflow: Cashflow = Cashflow(dueDate: nextLeaseDate, amount: "0.0")
            self.add(item: myCashflow)
            nextLeaseDate = addOnePeriodToDate(dateStart: nextLeaseDate, payPerYear: aInvestment.leaseTerm.paymentFrequency, dateRefer: aInvestment.leaseTerm.baseCommenceDate, bolEOMRule: aInvestment.leaseTerm.endOfMonthRule)
        }
        
    }
    
}
