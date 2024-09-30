//
//  TerminationValues.swift
//  CFLTax
//
//  Created by Steven Williams on 9/14/24.
//

import Foundation


@Observable
public class TerminationValues: Cashflows {
    var myLeaseTemplate: LeaseTemplateCashflows = LeaseTemplateCashflows()
    var myInvestmentBalances: PeriodicInvestmentBalances = PeriodicInvestmentBalances()
    var myDepreciableBalances: PeriodicDepreciableBalances = PeriodicDepreciableBalances()
    var myYTDIncomes: PeriodicYTDIncomes = PeriodicYTDIncomes()
    var myAdvanceRents: PeriodicAdvanceRents = PeriodicAdvanceRents()
    var myYTDTaxesPaid: PeriodicYTDTaxesPaid = PeriodicYTDTaxesPaid()
    var myITCRecaptured: PeriodicITCRecaptured = PeriodicITCRecaptured()
    var myFederalTaxRate: Decimal = 0.15
    let myPeriodicValues: CollCashflows = CollCashflows()
    
    public func createTable(aInvestment: Investment) {
        // AfterTaxTValue = (IBAL + AdvanceRent) + DepreciableBasis * FedTaxRate + (IncomeYTD - AdvanceRent) * FedTaxRate - TaxesPaidTYD + ITC Recaptured
        // TV = AfterTaxTValue / (1.0 - FedTaxRate)
        myFederalTaxRate = aInvestment.taxAssumptions.federalTaxRate.toDecimal()
        
        myInvestmentBalances.removeAll()
        myDepreciableBalances.removeAll()
        myYTDIncomes.removeAll()
        myYTDTaxesPaid.removeAll()
        myAdvanceRents.removeAll()
        
        
        myInvestmentBalances.createInvestmentBalances(aInvestment: aInvestment)
            myPeriodicValues.items.append(myInvestmentBalances)
        myDepreciableBalances.createTable(aInvestment: aInvestment)
            myPeriodicValues.items.append(myDepreciableBalances)
        myYTDIncomes.createTable(aInvestment: aInvestment)
            myPeriodicValues.items.append(myYTDIncomes)
        myYTDTaxesPaid.createTable(aInvestment: aInvestment)
            myPeriodicValues.items.append(myYTDTaxesPaid)
        myAdvanceRents.createTable(aInvestment: aInvestment)
            myPeriodicValues.items.append(myAdvanceRents)
    }
    
    public func createTerminationValues(aInvestment: Investment) {
        self.createTable(aInvestment: aInvestment)
        
        for x in 0..<myPeriodicValues.items[0].items.count {
            let asOfDate: Date = myPeriodicValues.items[0].items[x].dueDate
            let investmentBalance: Decimal = myPeriodicValues.items[0].items[x].amount.toDecimal()
            let deprecBalance: Decimal = myPeriodicValues.items[1].items[x].amount.toDecimal()
            let incomeYTD: Decimal = myPeriodicValues.items[2].items[x].amount.toDecimal()
            let taxYTD: Decimal = myPeriodicValues.items[3].items[x].amount.toDecimal()
            let advRent: Decimal = myPeriodicValues.items[4].items[x].amount.toDecimal()
            let tValue: Decimal = terminationValue(iBalance: investmentBalance, dBalance: deprecBalance, income: incomeYTD, taxPaid: taxYTD, advRent: advRent)
            let myTV: Cashflow = Cashflow(dueDate: asOfDate, amount: tValue.toString(decPlaces: 4))
            self.items.append(myTV)
        }
        
    }
    
    private func terminationValue(iBalance: Decimal, dBalance: Decimal, income: Decimal, taxPaid: Decimal, advRent: Decimal) -> Decimal {
        let taxOnGain: Decimal = dBalance * myFederalTaxRate
        let taxOnIncome: Decimal = (income - advRent) * myFederalTaxRate
        let netTaxDue: Decimal = taxOnIncome + taxOnGain + taxPaid
        let afterTaxTV: Decimal = (iBalance + advRent) - netTaxDue
        
        let preTaxTV: Decimal = afterTaxTV / (1 - myFederalTaxRate)
        
        return preTaxTV
    }
    
    
    
   
    
}
