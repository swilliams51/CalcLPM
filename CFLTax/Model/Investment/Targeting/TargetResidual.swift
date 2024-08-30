//
//  TargetResidual.swift
//  CFLTax
//
//  Created by Steven Williams on 8/27/24.
//

import Foundation

extension Investment {
    public func solveForResidual(aYieldMethod: YieldMethod, aTargetYield: Decimal) {
        switch aYieldMethod {
        case .MISF_AT:
            solveForResidual_MISF(aTargetYield: aTargetYield, isAfterTax: true)
        case .MISF_BT:
            solveForResidual_MISF(aTargetYield: aTargetYield, isAfterTax: false)
        case .IRR_PTCF:
            solveForResidual_IRROfPTCF(aTargetYield: aTargetYield)
        }
    }
    
    private func solveForResidual_MISF(aTargetYield: Decimal, isAfterTax: Bool) {
        let tempInvestment: Investment = self.clone()
        let x1: String = "0.0"
        tempInvestment.asset.residualValue = x1
       
        //1. Set target yield to after tax if input is before tax
        var yield: Decimal = aTargetYield
        if isAfterTax == false {
            yield = yield * (1.0 - self.taxAssumptions.federalTaxRate.toDecimal())
        }
       //2. Get NPV for y1, x = 0.0
        tempInvestment.setAfterTaxCashflows()
        let y1: Decimal = tempInvestment.afterTaxCashflows.XNPV(aDiscountRate: yield, aDayCountMethod: self.economics.dayCountMethod)
        tempInvestment.afterTaxCashflows.items.removeAll()
        
        //3. Set x2 = 20.0% of Asset Cost
        let x2:Decimal = self.getAssetCost(asCashflow: false) * 0.20
        tempInvestment.asset.residualValue = x2.toString(decPlaces: 4)
        
        //4. Calculate y2, then use mxbFactor function to calculate final fee
        tempInvestment.setAfterTaxCashflows()
        let y2: Decimal = tempInvestment.afterTaxCashflows.XNPV(aDiscountRate: yield, aDayCountMethod: self.economics.dayCountMethod)
        var newResidualAmount:Decimal = mxbFactor(factor1: x1.toDecimal(), value1: y1, factor2: x2, value2: y2)

        if newResidualAmount < 0.0 {
            newResidualAmount = 0.0
        }
        //5. Then set the fee in the actual investment to the value of the mxbFactor function
        self.asset.residualValue = newResidualAmount.toString(decPlaces: 4)
        tempInvestment.afterTaxCashflows.items.removeAll()
    }
    
    private func solveForResidual_IRROfPTCF(aTargetYield: Decimal) {
        let tempInvestment: Investment = self.clone()
        let x1: String = "0.0"
        tempInvestment.asset.residualValue = x1
       
       //2. Get NPV for y1, x = 0.0
        tempInvestment.setBeforeTaxCashflows()
        let y1: Decimal = tempInvestment.beforeTaxCashflows.XNPV(aDiscountRate: aTargetYield, aDayCountMethod: self.economics.dayCountMethod)
        tempInvestment.beforeTaxCashflows.items.removeAll()
        
        //3. Set x2 = 20.0% of Asset Cost
        let x2:Decimal = self.getAssetCost(asCashflow: false) * 0.20
        tempInvestment.asset.residualValue = x2.toString(decPlaces: 4)
        
        //4. Calculate y2, then use mxbFactor function to calculate final fee
        tempInvestment.setBeforeTaxCashflows()
        let y2: Decimal = tempInvestment.beforeTaxCashflows.XNPV(aDiscountRate: aTargetYield, aDayCountMethod: self.economics.dayCountMethod)
        var newResidualAmount:Decimal = mxbFactor(factor1: x1.toDecimal(), value1: y1, factor2: x2, value2: y2)

        if newResidualAmount < 0.0 {
            newResidualAmount = 0.0
        }
        //5. Then set the fee in the actual investment to the value of the mxbFactor function
        self.asset.residualValue = newResidualAmount.toString(decPlaces: 4)
        tempInvestment.beforeTaxCashflows.items.removeAll()
        
        
        
    }
}
