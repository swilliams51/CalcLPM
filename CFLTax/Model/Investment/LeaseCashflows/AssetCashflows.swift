//
//  AssetCashflows.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


@Observable
public class AssetCashflows: Cashflows {
    
    public func createTable_Lessor(aInvestment: Investment, aLeaseTemplate: Cashflows) {
        //if lessee perspective is true then the fee amount is excluded from the asset cost
        let amount: Decimal = aInvestment.getAssetCost(asCashflow: true)
        let feeAmount: Decimal = aInvestment.getFeeAmount()
        let investmentAmount: Decimal = amount + feeAmount
        let myCashflow: Cashflow = Cashflow(dueDate: aInvestment.asset.fundingDate, amount: investmentAmount.toString(decPlaces: 4))
        items.append(myCashflow)
        
        for x in 1..<aLeaseTemplate.count() {
            let myCashflow = aLeaseTemplate.items[x]
            items.append(myCashflow)
        }
    }
    
    public func createTable_Lessee(aInvestment: Investment, aLeaseTemplate: Cashflows) {
        let amount: Decimal = aInvestment.getAssetCost(asCashflow: true)
        let myCashflow: Cashflow = Cashflow(dueDate: aInvestment.asset.fundingDate, amount: amount.toString(decPlaces: 4))
        items.append(myCashflow)
        
        for x in 1..<aLeaseTemplate.count() {
            let myCashflow = aLeaseTemplate.items[x]
            items.append(myCashflow)
        }
        
    }
    
}
