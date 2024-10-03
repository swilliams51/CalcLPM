//
//  TerminationValues.swift
//  CFLTax
//
//  Created by Steven Williams on 9/14/24.
//

import Foundation


@Observable
public class TerminationValues: CollCashflows {
    var myLeaseTemplate: LeaseTemplateCashflows = LeaseTemplateCashflows()
    var myInvestmentBalances: PeriodicInvestmentBalances = PeriodicInvestmentBalances()
    var myDepreciableBalances: PeriodicDepreciableBalances = PeriodicDepreciableBalances()
    var myYTDIncomes: PeriodicYTDIncomes = PeriodicYTDIncomes()
    var myAdvanceRents: PeriodicAdvanceRents = PeriodicAdvanceRents()
    var myYTDTaxesPaid: PeriodicYTDTaxesPaid = PeriodicYTDTaxesPaid()
    var myITCRecaptured: PeriodicITCRecaptured = PeriodicITCRecaptured()
    var myFederalTaxRate: Decimal = 0.15
    
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
            self.items.append(myInvestmentBalances)
        myDepreciableBalances.createTable(aInvestment: aInvestment)
            self.items.append(myDepreciableBalances)
        myYTDIncomes.createTable(aInvestment: aInvestment)
            self.items.append(myYTDIncomes)
        myYTDTaxesPaid.createTable(aInvestment: aInvestment)
            self.items.append(myYTDTaxesPaid)
        myAdvanceRents.createTable(aInvestment: aInvestment)
            self.items.append(myAdvanceRents)
    }
    
    public func createTerminationValues() -> Cashflows {
        let myTValues: Cashflows = Cashflows()
        
        for x in 0..<self.items[0].items.count {
            let asOfDate: Date = self.items[0].items[x].dueDate
            let investmentBalance: Decimal = self.items[0].items[x].amount.toDecimal()
            let deprecBalance: Decimal = self.items[1].items[x].amount.toDecimal()
            let incomeYTD: Decimal = self.items[2].items[x].amount.toDecimal()
            let taxPaidYTD: Decimal = self.items[3].items[x].amount.toDecimal()
            let advRent: Decimal = self.items[4].items[x].amount.toDecimal()
            let tValue: Decimal = terminationValue(iBalance: investmentBalance, dBalance: deprecBalance, income: incomeYTD, taxPaid: taxPaidYTD, advRent: advRent)
            let myTV: Cashflow = Cashflow(dueDate: asOfDate, amount: tValue.toString(decPlaces: 4))
            myTValues.add(item: myTV)
        }
        
        return myTValues
        
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
