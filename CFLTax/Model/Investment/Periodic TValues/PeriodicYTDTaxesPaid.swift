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
    
    public func createTable(aInvestment: Investment) {
        let myPeriodicTaxesPaid: Cashflows = myTaxableIncomes.createPeriodicTaxesPaid_STD(aInvestment: aInvestment)
        let aLeaseTemplate: Cashflows = aInvestment.createLeaseTemplate()
        let myLeaseTemplate: Cashflows = aLeaseTemplate.clone()
        
        let myCombinedCashflows = CollCashflows()
        myCombinedCashflows.addCashflows(aLeaseTemplate)
        myCombinedCashflows.addCashflows(myPeriodicTaxesPaid)
        myCombinedCashflows.netCashflows()
        
        
        let myTempCashflow: Cashflows = Cashflows()
        var ytdTotal: Decimal = 0.0
        var nextFiscalYearEnd: Date = getFiscalYearEnd(askDate: aInvestment.asset.fundingDate, fiscalMonthEnd: aInvestment.taxAssumptions.fiscalMonthEnd.rawValue)
        var x = 0
        
        while x < myCombinedCashflows.items[0].items.count {
            if myCombinedCashflows.items[0].items[x].dueDate.isLessThanOrEqualTo(date: nextFiscalYearEnd) {
                ytdTotal += myCombinedCashflows.items[0].items[x].amount.toDecimal() * -1.0
                let periodicYTDTaxesPaid: Cashflow = Cashflow(dueDate: myCombinedCashflows.items[0].items[x].dueDate, amount: ytdTotal.toString(decPlaces: 4))
                myTempCashflow.items.append(periodicYTDTaxesPaid)
                x += 1
            } else {
                ytdTotal = 0.0
                nextFiscalYearEnd = addNextFiscalYearEnd(aDateIn: nextFiscalYearEnd)
            }
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

