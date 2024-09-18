//
//  PeriodicInvestmentBalances.swift
//  CFLTax
//
//  Created by Steven Williams on 9/14/24.
//

import Foundation

@Observable
public class PeriodicInvestmentBalances: Cashflows {
    var myAmortizations: Amortizations  = Amortizations()
    
    public func createInvestmentBalances(aInvestment: Investment) {
        let tempInvestment: Investment = aInvestment.clone()
        
        tempInvestment.calculate()
        myAmortizations.createAmortizations(investCashflows: tempInvestment.afterTaxCashflows, interestRate: tempInvestment.getMISF_AT_Yield(), dayCountMethod: tempInvestment.economics.dayCountMethod)
        
        for x in 0..<myAmortizations.items.count {
            let dueDate: Date = myAmortizations.items[x].dueDate
            let endBalance: Decimal = myAmortizations.items[x].endBalance
            let myCF: Cashflow = Cashflow(dueDate: dueDate, amount: endBalance.toString(decPlaces: 4))
            self.items.append(myCF)
        }
        
    }
    
}
