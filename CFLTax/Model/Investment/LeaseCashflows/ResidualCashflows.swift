//
//  ResidualCashflows.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation

@Observable
public class ResidualCashflows: Cashflows {
    
    public func createTable(aInvestment: Investment, aLeaseTemplate: Cashflows) {
        for x in 0..<aLeaseTemplate.count() - 1 {
            let myCashflow = aLeaseTemplate.items[x]
            items.append(myCashflow)
        }
        
        
        let amount:String = aInvestment.asset.residualValue
        let dateDue: Date = aInvestment.getLeaseMaturityDate()
        let myCashflow = Cashflow(dueDate: dateDue, amount: amount)
        items.append(myCashflow)
    }
}
