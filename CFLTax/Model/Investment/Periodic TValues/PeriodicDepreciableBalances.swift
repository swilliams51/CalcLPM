//
//  PeriodicDepreciableBalances.swift
//  CFLTax
//
//  Created by Steven Williams on 9/14/24.
//

import Foundation

@Observable
public class PeriodicDepreciableBalances: Cashflows {
    
    var myDepreciationIncomes: DepreciationIncomes = DepreciationIncomes()
    var myFeeIncomes: FeeIncomes = FeeIncomes()
    
    public func createTable(aInvestment: Investment) {
        myDepreciationIncomes.createTable(aInvestment: aInvestment)
        myFeeIncomes.createTable(aInvestment: aInvestment)
        
        let aLeaseTemplate: Cashflows  = aInvestment.createLeaseTemplate()
        let myLeaseTemplate: Cashflows = aLeaseTemplate.clone()
        let myCombinedCashflows: CollCashflows = CollCashflows()
        myCombinedCashflows.addCashflows(myDepreciationIncomes)
        myCombinedCashflows.addCashflows(myFeeIncomes)
        myCombinedCashflows.netCashflows()
        
        var remainingBalance: Decimal = myCombinedCashflows.items[0].getTotal() * -1.0
        var y: Int = 0
        var periodicBalance: Decimal = 0.0
        
        for x in 0..<myLeaseTemplate.count() {
            if getYearComponent(dateIn: myLeaseTemplate.items[x].dueDate) <= getYearComponent(dateIn: myCombinedCashflows.items[0].items[y].dueDate) {
                periodicBalance = remainingBalance
            } else {
                remainingBalance = remainingBalance - myCombinedCashflows.items[0].items[y].amount.toDecimal() * -1.0
                periodicBalance = remainingBalance
                y += 1
            }
            let periodicDueDate: Date = myLeaseTemplate.items[x].dueDate
            let periodicDepreciation: Cashflow = Cashflow(dueDate: periodicDueDate, amount: periodicBalance.toString(decPlaces: 4))
            self.items.append(periodicDepreciation)
        }
    }
    
}
