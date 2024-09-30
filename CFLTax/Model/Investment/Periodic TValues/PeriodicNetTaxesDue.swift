//
//  PeriodicNetTaxesDue.swift
//  CFLTax
//
//  Created by Steven Williams on 9/29/24.
//

import Foundation

@Observable
public class PeriodicNetTaxesDue: Cashflows {
    var myDepreciableBalances: PeriodicDepreciableBalances = PeriodicDepreciableBalances()
    var myYTDIncomes: PeriodicYTDIncomes = PeriodicYTDIncomes()
    var myAdvanceRents: PeriodicAdvanceRents = PeriodicAdvanceRents()
    var myYTDTaxesPaid: PeriodicYTDTaxesPaid = PeriodicYTDTaxesPaid()
    var myFederalTaxRate: Decimal = 0.15
    let myPeriodicValues: CollCashflows = CollCashflows()
    
    public func createTable(aInvestment: Investment) {
        myFederalTaxRate = aInvestment.taxAssumptions.federalTaxRate.toDecimal()
        myDepreciableBalances.removeAll()
        myYTDIncomes.removeAll()
        myYTDTaxesPaid.removeAll()
        myAdvanceRents.removeAll()
        
        myDepreciableBalances.createTable(aInvestment: aInvestment)
            myPeriodicValues.items.append(myDepreciableBalances)
        myYTDIncomes.createTable(aInvestment: aInvestment)
            myPeriodicValues.items.append(myYTDIncomes)
        myYTDTaxesPaid.createTable(aInvestment: aInvestment)
            myPeriodicValues.items.append(myYTDTaxesPaid)
        myAdvanceRents.createTable(aInvestment: aInvestment)
            myPeriodicValues.items.append(myAdvanceRents)
    }
    
    public func createNetTaxesDue(aInvestment: Investment) {
        self.createTable(aInvestment: aInvestment)
        
        for x in 0..<myPeriodicValues.items[0].items.count {
            let asOfDate: Date = myPeriodicValues.items[0].items[x].dueDate
            let deprecBalance: Decimal = myPeriodicValues.items[0].items[x].amount.toDecimal()
            let incomeYTD: Decimal = myPeriodicValues.items[1].items[x].amount.toDecimal()
            let taxYTD: Decimal = myPeriodicValues.items[2].items[x].amount.toDecimal()
            let advRent: Decimal = myPeriodicValues.items[3].items[x].amount.toDecimal()
            let netTaxesDue: Decimal = netTaxesDue(dBalance: deprecBalance, income: incomeYTD, taxPaid: taxYTD, advRent: advRent)
            let myNetTaxesDue: Cashflow = Cashflow(dueDate: asOfDate, amount: netTaxesDue.toString(decPlaces: 4))
            self.items.append(myNetTaxesDue)
        }
    }
        
    private func netTaxesDue(dBalance: Decimal, income: Decimal, taxPaid: Decimal, advRent: Decimal) -> Decimal {
        let taxOnGain: Decimal = dBalance * myFederalTaxRate
        let taxOnIncome: Decimal = (income - advRent) * myFederalTaxRate
        let netTaxDue: Decimal = taxOnGain + taxOnIncome + taxPaid
        
        return netTaxDue
    }
        
}

