//
//  NetAfterTaxCashflows.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


@Observable
public class NetAfterTaxCashflows: CollCashflows {
    var myPeriodicLeaseCashflows: Cashflows = Cashflows()
    var myPeriodicTaxesPaid: Cashflows = Cashflows()
    
    public func createTable(aInvestment: Investment, plannedIncome: String = "0.00", unplannedDate: Date = Date()) {
        myPeriodicLeaseCashflows.removeAll()
        myPeriodicTaxesPaid.removeAll()
        myPeriodicLeaseCashflows.addAll(aCFs: PeriodicLeaseCashflows().createPeriodicLeaseCashflows(aInvestment: aInvestment, lesseePerspective: false))
        self.addCashflows(myPeriodicLeaseCashflows)
        
        if plannedIncome.toDecimal() == 0.0 {
            myPeriodicTaxesPaid.addAll(aCFs: AnnualTaxableIncomes().createPeriodicTaxesPaid_STD(aInvestment: aInvestment))
        } else {
            myPeriodicTaxesPaid.addAll(aCFs: AnnualTaxableIncomes().createPeriodicTaxesPaid_EBO(aInvestment: aInvestment, plannedIncome: plannedIncome, unplannedDate: unplannedDate))
        }
        
        self.addCashflows(myPeriodicTaxesPaid)
    }
    
    public func createNetAfterTaxCashflows(aInvestment: Investment, plannedIncome: String = "0.00", unplannedDate: Date = Date()) -> Cashflows {
        self.createTable(aInvestment: aInvestment)
        self.netCashflows()
        
        let myATLeaseCashflows: Cashflows = Cashflows()
        for x in 0..<self.items[0].count() {
            let myCashflow: Cashflow = self.items[0].items[x]
            myATLeaseCashflows.add(item: myCashflow)
        }
        self.removeAll()
        
        return myATLeaseCashflows
    }
    
}
