//
//  ResidualIncomes.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation

@Observable
public class ResidualIncomes: Cashflows {
    
    public func createTable(myAsset: Asset, aMaturityDate: Date, aFiscalMonth: Int) {
        var currentFiscalDate = getFiscalYearEnd(askDate: myAsset.fundingDate, fiscalMonthEnd: aFiscalMonth)
        
        while currentFiscalDate <= aMaturityDate {
            let residualIncomeAmount = Cashflow(dueDate: currentFiscalDate, amount: "0.00")
            items.append(residualIncomeAmount)
            currentFiscalDate = addNextFiscalYearEnd(aDateIn: currentFiscalDate)
        }
    
        let residualIncomeAmount = Cashflow(dueDate: currentFiscalDate, amount: myAsset.residualValue)
        items.append(residualIncomeAmount)
    }
    
}
