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
    
    public func createTable(aInvestment: Investment) {
        myPeriodicLeaseCashflows.removeAll()
        myPeriodicTaxesPaid.removeAll()
        myPeriodicLeaseCashflows.addAll(aCFs: PeriodicLeaseCashflows().createPeriodicLeaseCashflows(aInvestment: aInvestment))
        self.addCashflows(myPeriodicLeaseCashflows)
        myPeriodicTaxesPaid.addAll(aCFs: AnnualTaxableIncomes().createPeriodicTaxesPaid_STD(aInvestment: aInvestment))
        self.addCashflows(myPeriodicTaxesPaid)
    }
    
    public func createNetAfterTaxCashflows(aInvestment: Investment) -> Cashflows {
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
