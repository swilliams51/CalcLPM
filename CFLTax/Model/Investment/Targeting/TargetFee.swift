//
//  TargetFee.swift
//  CFLTax
//
//  Created by Steven Williams on 8/27/24.
//

import Foundation


extension Investment {
    public func solveForFee(aYieldMethod: YieldMethod, aTargetYield: Decimal) {
        switch aYieldMethod {
        case .MISF_AT:
            solveForFee_MISF(aTargetYield: aTargetYield, isAfterTax: true)
        case .MISF_BT:
            solveForFee_MISF(aTargetYield: aTargetYield, isAfterTax: false)
        case .IRR_PTCF:
            solveForFee_IRROfPTCF(aTargetYield: aTargetYield)
        }
    }
    
    private func solveForFee_MISF(aTargetYield: Decimal, isAfterTax: Bool) {
        let tempInvestment: Investment = self.clone()
        let x1: String = "0.0"
        tempInvestment.fee.amount = x1
       
        //1. Set target yield to after tax if input is before tax
        var yield: Decimal = aTargetYield
        if isAfterTax == false {
            yield = yield * (1.0 - self.taxAssumptions.federalTaxRate.toDecimal())
        }
       //2. Get NPV for y1, x = 0.0
        tempInvestment.setAfterTaxCashflows()
        let y1: Decimal = tempInvestment.afterTaxCashflows.XNPV(aDiscountRate: yield, aDayCountMethod: self.economics.dayCountMethod)
        tempInvestment.afterTaxCashflows.items.removeAll()
        
        //3a. Set x2 = 2.0% of Asset Cost
        let x2:Decimal = self.getAssetCost(asCashflow: false) * 0.02
        tempInvestment.fee.amount = x2.toString(decPlaces: 4)
        
        //3b. Set x2 type to either expense of income fee type
        var myFeeType: FeeType = .expense
        if y1 < 0.0 {
            tempInvestment.fee.feeType = .income
            myFeeType = .income
        } else {
            tempInvestment.fee.feeType = .expense
        }
        
        //4. Calculate y2, then use mxbFactor function to calculate final fee
        tempInvestment.setAfterTaxCashflows()
        let y2: Decimal = tempInvestment.afterTaxCashflows.XNPV(aDiscountRate: yield, aDayCountMethod: self.economics.dayCountMethod)
        var newFeeAmount = mxbFactor(factor1: x1.toDecimal(), value1: y1, factor2: x2, value2: y2)
        newFeeAmount = checkedFeeAmount(aFeeAmount: newFeeAmount, aAssetCost: self.getAssetCost(asCashflow: false))
        
        //5. Then set the fee in the actual investment to the value of the mxbFactor function
        self.fee.amount = newFeeAmount.toString(decPlaces: 4)
        self.fee.feeType = myFeeType
        tempInvestment.afterTaxCashflows.items.removeAll()
    }
   
    private func solveForFee_IRROfPTCF(aTargetYield: Decimal) {
        //Clone the investment and set x1 = 0.0
        let tempInvestment: Investment = self.clone()
        let x1: String = "0.0"
        tempInvestment.fee.amount = x1
        
        //2. Get NPV for y1, x = 0.0
         tempInvestment.setBeforeTaxCashflows()
        let y1: Decimal = tempInvestment.beforeTaxCashflows.XNPV(aDiscountRate: aTargetYield, aDayCountMethod: self.economics.dayCountMethod)
         tempInvestment.beforeTaxCashflows.items.removeAll()
        
        //3a. Set x2 = 2.0% of Asset Cost
        let x2:Decimal = self.getAssetCost(asCashflow: false) * 0.02
        tempInvestment.fee.amount = x2.toString(decPlaces: 4)
        
        //3b. Set x2 type to either expense of income fee type
        var myFeeType: FeeType = .expense
        if y1 < 0.0 {
            tempInvestment.fee.feeType = .income
            myFeeType = .income
        } else {
            tempInvestment.fee.feeType = .expense
        }
        
        //4. Calculate y2, then use mxbFactor function to calculate final fee
        tempInvestment.setBeforeTaxCashflows()
        let y2: Decimal = tempInvestment.beforeTaxCashflows.XNPV(aDiscountRate: aTargetYield, aDayCountMethod: self.economics.dayCountMethod)
        var newFeeAmount = mxbFactor(factor1: x1.toDecimal(), value1: y1, factor2: x2, value2: y2)
        newFeeAmount = checkedFeeAmount(aFeeAmount: newFeeAmount, aAssetCost: self.getAssetCost(asCashflow: false))
        
        //5. Then set the fee in the actual investment to the value of the mxbFactor function
        self.fee.amount = newFeeAmount.toString(decPlaces: 4)
        self.fee.feeType = myFeeType
        tempInvestment.beforeTaxCashflows.items.removeAll()
    }
    
    private func checkedFeeAmount(aFeeAmount: Decimal, aAssetCost: Decimal) -> Decimal {
        var checkedFeeAmount: Decimal = aFeeAmount
        if abs(checkedFeeAmount / aAssetCost) < 0.0005 {
            checkedFeeAmount = 0.0
        }
        
        return checkedFeeAmount
    }
    
}
