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
    
    public func createTable(aInvestment: Investment, aLeaseTemplate: Cashflows) {
        myDepreciationIncomes.createTable(aInvestment: aInvestment)
        myFeeIncomes.createTable(aInvestment: aInvestment)
        
        let myCombinedCashflows: CollCashflows = CollCashflows()
        myCombinedCashflows.addCashflows(aLeaseTemplate)
        myCombinedCashflows.addCashflows(myDepreciationIncomes)
        myCombinedCashflows.addCashflows(myFeeIncomes)
        myCombinedCashflows.netCashflows()
        
        var remainingBalance: Decimal = myCombinedCashflows.items[0].getTotal()
        var y: Int = 0
        
        for x in 0..<aLeaseTemplate.count() {
            var periodicBalance: Decimal = 0.0
            if getYearComponent(dateIn: aLeaseTemplate.items[x].dueDate) == getYearComponent(dateIn: myCombinedCashflows.items[0].items[y].dueDate) {
                periodicBalance = remainingBalance
            } else {
                remainingBalance = remainingBalance - myCombinedCashflows.items[0].items[x].amount.toDecimal()
                periodicBalance = remainingBalance
                y += 1
            }
            let periodicDueDate: Date = aLeaseTemplate.items[x].dueDate
            let periodicDepreciation: Cashflow = Cashflow(dueDate: periodicDueDate, amount: periodicBalance.toString(decPlaces: 4))
            self.items.append(periodicDepreciation)
        }
    }
    
}
