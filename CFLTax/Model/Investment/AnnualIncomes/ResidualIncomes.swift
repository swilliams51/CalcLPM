//
//  ResidualIncomes.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation

@Observable
public class ResidualIncomes: Cashflows {
    
    public func createTable(aInvestment: Investment) {
        
        let myAsset = aInvestment.asset
        let aMaturityDate: Date = aInvestment.getLeaseMaturityDate()
        let aFiscalMonthEnd: Int = aInvestment.taxAssumptions.fiscalMonthEnd.rawValue
        var currentFiscalDate = getFiscalYearEnd(askDate: myAsset.fundingDate, fiscalMonthEnd: aFiscalMonthEnd)
        
        while currentFiscalDate.isLessThanOrEqualTo(date: aMaturityDate) {
            let residualIncomeAmount = Cashflow(dueDate: currentFiscalDate, amount: "0.00")
            items.append(residualIncomeAmount)
            currentFiscalDate = addNextFiscalYearEnd(aDateIn: currentFiscalDate)
        }
    
        let residualIncomeAmount = Cashflow(dueDate: currentFiscalDate, amount: myAsset.residualValue)
        items.append(residualIncomeAmount)
    }
    
}
