//
//  TargetCost.swift
//  CFLTax
//
//  Created by Steven Williams on 8/27/24.
//

import Foundation


extension Investment{
    public func solveForLessorCost(aYieldMethod: YieldMethod, aTargetYield: Decimal) {
        switch aYieldMethod {
        case .MISF_AT:
            solveForCost_MISF(aTargetYield: aTargetYield, isAfterTax: true)
        case .MISF_BT:
            solveForCost_MISF(aTargetYield: aTargetYield, isAfterTax: false)
        case .IRR_PTCF:
            solveForCost_IRROfPTCF(aTargetYield: aTargetYield)
        }
    }
    
    private func solveForCost_MISF(aTargetYield: Decimal, isAfterTax: Bool){
        let tempInvestment: Investment = self.clone()
        let x1 = tempInvestment.asset.lessorCost.toDecimal()
       
        //1. Set target yield to after tax if input is before tax
        var yield: Decimal = aTargetYield
        if isAfterTax == false {
            yield = yield * (1.0 - self.taxAssumptions.federalTaxRate.toDecimal())
        }
       //2. Get NPV for y1, x = current asset cost
        tempInvestment.setAfterTaxCashflows()
        let y1: Decimal = tempInvestment.afterTaxCashflows.ModXNPV(aDiscountRate: yield, aDayCountMethod: self.economics.dayCountMethod)
        tempInvestment.afterTaxCashflows.items.removeAll()
        
        //3a. Set x2 = 50.0% of Asset Cost
        let x2:Decimal = self.getAssetCost(asCashflow: false) * 0.50
        tempInvestment.asset.lessorCost = x2.toString(decPlaces: 4)
        
        //4. Calculate y2, then use mxbFactor function to calculate final fee
        tempInvestment.setAfterTaxCashflows()
        let y2: Decimal = tempInvestment.afterTaxCashflows.ModXNPV(aDiscountRate: yield, aDayCountMethod: self.economics.dayCountMethod)
        var newAmount = mxbFactor(factor1: x1, value1: y1, factor2: x2, value2: y2)

        if newAmount < 0.0 {
            newAmount = 0.0
        }
        
        //5. Then set the asset cost in the actual investment to the value of the mxbFactor function
        self.asset.lessorCost = newAmount.toString(decPlaces: 4)
        tempInvestment.afterTaxCashflows.items.removeAll()
    }
    
    private func solveForCost_IRROfPTCF(aTargetYield: Decimal){
        let tempInvestment: Investment = self.clone()
        let x1 = tempInvestment.asset.lessorCost.toDecimal()

       //2. Get NPV for y1, x = current asset cost
        tempInvestment.setBeforeTaxCashflows()
        let y1: Decimal = tempInvestment.beforeTaxCashflows.ModXNPV(aDiscountRate: aTargetYield, aDayCountMethod: self.economics.dayCountMethod)
        tempInvestment.beforeTaxCashflows.items.removeAll()
        
        //3a. Set x2 = 50.0% of Asset Cost
        let x2:Decimal = self.getAssetCost(asCashflow: false) * 0.50
        tempInvestment.asset.lessorCost = x2.toString(decPlaces: 4)
        
        //4. Calculate y2, then use mxbFactor function to calculate final fee
        tempInvestment.setBeforeTaxCashflows()
        let y2: Decimal = tempInvestment.beforeTaxCashflows.ModXNPV(aDiscountRate: aTargetYield, aDayCountMethod: self.economics.dayCountMethod)
        var newAmount = mxbFactor(factor1: x1, value1: y1, factor2: x2, value2: y2)
        
        if newAmount < 0.0 {
            newAmount = 0.0
        }
        
        //5. Then set the asset cost in the actual investment to the value of the mxbFactor function
        self.asset.lessorCost = newAmount.toString(decPlaces: 4)
        tempInvestment.beforeTaxCashflows.items.removeAll()
    }
    
    
}
