//
//  TerminationValues.swift
//  CFLTax
//
//  Created by Steven Williams on 9/14/24.
//

import Foundation


@Observable
public class TerminationValues: CollCashflows {
    var myLeaseTemplate: Cashflows = Cashflows()
    var myInvestmentBalances: PeriodicInvestmentBalances = PeriodicInvestmentBalances()
    var myDepreciableBalances: PeriodicDepreciableBalances = PeriodicDepreciableBalances()
    var myYTDIncomes: PeriodicYTDIncomes = PeriodicYTDIncomes()
    var myAdvanceRents: PeriodicAdvanceRents = PeriodicAdvanceRents()
    var myYTDTaxesPaid: PeriodicYTDTaxesPaid = PeriodicYTDTaxesPaid()
    var myITCRecaptured: PeriodicITCRecaptured = PeriodicITCRecaptured()
    
    
    public func createTable(aInvestment: Investment) -> Cashflows {
        // AfterTaxTValue = IBAL - DepreciableBasis * FedTaxRate + (IncomeYTD - AdvanceRent) * FedTaxRate - TaxesPaidTYD + ITC Recaptured
        // TV = AfterTaxTValue / (1.0 - FedTaxRate)
        createLeaseTemplate(aInvestment: aInvestment)
        
        
        
        let myCashflows = Cashflows()
        return myCashflows
    }
    
    public func createTerminationValue(aInvestment: Investment) -> Cashflows {
        self.createTable(aInvestment: aInvestment)
        //items[0] - Lease Template, items[1] - InvestmentBalances, items[2] - Depreciable Balances, items[3] - YTDIncomes
        //items[4] - Advance Rents, items[5] - YTDTaxesPaid, items[6] - ITCRecaptured
    }
    
    public func createLeaseTemplate(aInvestment: Investment) {
        let myCashflow: Cashflow = Cashflow(dueDate: aInvestment.asset.fundingDate, amount: "0.0")
        myLeaseTemplate.add(item: myCashflow)
        
        if aInvestment.leaseTerm.baseCommenceDate !=  aInvestment.asset.fundingDate {
            let myCashflow: Cashflow = Cashflow(dueDate: aInvestment.leaseTerm.baseCommenceDate, amount: "0.0")
            myLeaseTemplate.add(item: myCashflow)
        }
        
        var nextLeaseDate: Date = addOnePeriodToDate(dateStart: aInvestment.leaseTerm.baseCommenceDate, payPerYear: aInvestment.leaseTerm.paymentFrequency, dateRefer: aInvestment.leaseTerm.baseCommenceDate, bolEOMRule: aInvestment.leaseTerm.endOfMonthRule)
        while nextLeaseDate <= aInvestment.getLeaseMaturityDate() {
            let myCashflow: Cashflow = Cashflow(dueDate: nextLeaseDate, amount: "0.0")
            myLeaseTemplate.add(item: myCashflow)
            nextLeaseDate = addOnePeriodToDate(dateStart: nextLeaseDate, payPerYear: aInvestment.leaseTerm.paymentFrequency, dateRefer: aInvestment.leaseTerm.baseCommenceDate, bolEOMRule: aInvestment.leaseTerm.endOfMonthRule)
        }
    }
    
}
