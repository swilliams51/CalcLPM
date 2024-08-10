//
//  AssetCashflows.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


@Observable
public class AssetCashflows: Cashflows {
    
    public func createTable(aInvestment: Investment, aLeaseTemplate: Cashflows) {
        let amount: String = aInvestment.asset.lessorCost
        let decAmount: Decimal = amount.toDecimal() * -1.0
        var feeAmount: Decimal = 0.0
        var factor: Decimal = 1.0
        if aInvestment.feeExists() == true {
            feeAmount = aInvestment.fee.amount.toDecimal()
            if aInvestment.fee.feeType == .expense {
                factor = -1.0
            }
        }
        let investmentAmount: Decimal = decAmount + feeAmount * factor
        let myCashflow: Cashflow = Cashflow(dueDate: aInvestment.asset.fundingDate, amount: investmentAmount.toString(decPlaces: 4))
        items.append(myCashflow)
        
        for x in 1..<aLeaseTemplate.count() {
            let myCashflow = aLeaseTemplate.items[x]
            items.append(myCashflow)
        }
    }
    
}
