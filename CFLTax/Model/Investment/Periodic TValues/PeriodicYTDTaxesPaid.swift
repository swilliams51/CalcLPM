//
//  PeriodicYTDTaxesPaid.swift
//  CFLTax
//
//  Created by Steven Williams on 9/14/24.
//

import Foundation

@Observable
public class PeriodicYTDTaxesPaid: Cashflows {
    
    var myTaxableIncomes: AnnualTaxableIncomes = AnnualTaxableIncomes()
    
    public func createTable(aInvestment: Investment, aLeaseTemplate: Cashflows) {
        let myPeriodicTaxesPaid: Cashflows = myTaxableIncomes.createPeriodicTaxesPaid_STD(aInvestment: aInvestment)
        let myCombinedCashflows = CollCashflows()
        myCombinedCashflows.addCashflows(aLeaseTemplate)
        myCombinedCashflows.addCashflows(myPeriodicTaxesPaid)
        myCombinedCashflows.netCashflows()
        
        var ytdTotal: Decimal = 0.0
        var nextFiscalYearEnd: Date = getFiscalYearEnd(askDate: aInvestment.asset.fundingDate, fiscalMonthEnd: aInvestment.taxAssumptions.fiscalMonthEnd.rawValue)
        for x in 0..<myCombinedCashflows.items.count {
            if myCombinedCashflows.items[0].items[x].dueDate <= nextFiscalYearEnd {
                ytdTotal += myCombinedCashflows.items[0].items[x].amount.toDecimal()
                let periodicYTDTaxesPaid: Cashflow = Cashflow(dueDate: myCombinedCashflows.items[0].items[x].dueDate, amount: ytdTotal.toString(decPlaces: 4))
                self.items.append(periodicYTDTaxesPaid)
            } else {
                ytdTotal = 0.0
                let periodicYTDTaxesPaid: Cashflow = Cashflow(dueDate: myCombinedCashflows.items[0].items[x].dueDate, amount: ytdTotal.toString(decPlaces: 4))
                self.items.append(periodicYTDTaxesPaid)
                nextFiscalYearEnd = addNextFiscalYearEnd(aDateIn: nextFiscalYearEnd)
            }
        }
        
    }
    
}

