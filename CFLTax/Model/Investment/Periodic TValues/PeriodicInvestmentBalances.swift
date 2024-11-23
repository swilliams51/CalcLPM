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
        let aLeaseTemplate: Cashflows = aInvestment.createLeaseTemplate()
        let myLeaseTemplate: Cashflows = aLeaseTemplate.clone()
        
        tempInvestment.calculate()
        myAmortizations.createAmortizations(investCashflows: tempInvestment.afterTaxCashflows, interestRate: tempInvestment.getMISF_AT_Yield(), dayCountMethod: tempInvestment.economics.dayCountMethod)
        
        let myTempCashflow: Cashflows = Cashflows()
        for x in 0..<myAmortizations.items.count {
            let dueDate: Date = myAmortizations.items[x].dueDate
            let endBalance: Decimal = myAmortizations.items[x].endBalance
            let myCF: Cashflow = Cashflow(dueDate: dueDate, amount: endBalance.toString(decPlaces: 4))
            myTempCashflow.items.append(myCF)
        }
        
        for x in 0..<myTempCashflow.items.count {
            let askDate: Date = myTempCashflow.items[x].dueDate
            if isAskDateALeaseDate(askDate: askDate, aLeaseTemplate: myLeaseTemplate) {
                let leaseAmount: String = myTempCashflow.items[x].amount
                self.items.append(Cashflow(dueDate: askDate, amount: leaseAmount))
            }
        }
        
    }
    
    public func isAskDateALeaseDate(askDate: Date, aLeaseTemplate: Cashflows) -> Bool {
        var askDateIsLeaseDate = false
        
        for x in 0..<aLeaseTemplate.items.count {
            if aLeaseTemplate.items[x].dueDate.isEqualTo(date: askDate) {
                askDateIsLeaseDate = true
                break
            }
        }
        
        return askDateIsLeaseDate
    }
    
    
}
