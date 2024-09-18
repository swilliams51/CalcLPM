//
//  PeriodicYTDIncomes.swift
//  CFLTax
//
//  Created by Steven Williams on 9/14/24.
//

import Foundation


@Observable
public class PeriodicYTDIncomes: Cashflows {
    
    var myPeriodicRentalIncomes: RentalCashflows = RentalCashflows()
    
    public func createTable(aInvestment: Investment, aLeaseTemplate: LeaseTemplateCashflows) {
        myPeriodicRentalIncomes.createTable(aInvestment: aInvestment)
        var currFiscalYearEnd: Date = getFiscalYearEnd(askDate: aLeaseTemplate.items[0].dueDate, fiscalMonthEnd: aInvestment.taxAssumptions.fiscalMonthEnd.rawValue)
        var runTotal: Decimal = 0.0
        
        for x in 0..<myPeriodicRentalIncomes.items.count {
            
            while myPeriodicRentalIncomes.items[x].dueDate <= currFiscalYearEnd {
                runTotal += myPeriodicRentalIncomes.items[x].amount.toDecimal()
                let periodicYTDIncome: Cashflow = Cashflow(dueDate: myPeriodicRentalIncomes.items[x].dueDate, amount: runTotal.toString(decPlaces: 4))
                self.items.append(periodicYTDIncome)
                
            }
            currFiscalYearEnd = addNextFiscalYearEnd(aDateIn: currFiscalYearEnd)
            runTotal = 0.0
        }
        
        
    }
        
}

