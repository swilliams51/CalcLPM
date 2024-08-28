//
//  TargetFee.swift
//  CFLTax
//
//  Created by Steven Williams on 8/27/24.
//

import Foundation


extension Investment {
    public func solveForFee(aYieldMethod: YieldMethod, aTargetYield: Decimal, isAfterTax: Bool) {
        if aYieldMethod == .MISF_AT  || aYieldMethod == .MISF_BT {
            solveForFee_MISF(aTargetYield: aTargetYield, isAfterTax: isAfterTax)
        } else {
            //solveForFee_IRROfPTCF(aTargetYield: aTargetYield)
        }
    }
    
    private func solveForFee_MISF(aTargetYield: Decimal, isAfterTax: Bool) {
        let tempInvestment: Investment = self.clone()
        let x1 = tempInvestment.fee.amount.toDecimal()
       
        var yield: Decimal = aTargetYield
        if isAfterTax == false {
            yield = yield * (1.0 - self.taxAssumptions.federalTaxRate.toDecimal())
        }
       
        tempInvestment.setAfterTaxCashflows()
        var y1: Decimal = tempInvestment.afterTaxCashflows.XNPV(aDiscountRate: yield, aDayCountMethod: self.economics.dayCountMethod)
        if isAfterTax == false {
            y1 = y1 * (1.0 - self.taxAssumptions.federalTaxRate.toDecimal())
        }
        tempInvestment.afterTaxCashflows.items.removeAll()
        
        let x2:Decimal = tempInvestment.fee.amount.toDecimal() * 2.0
        tempInvestment.fee.amount = x2.toString(decPlaces: 4)
        if yield < y1 {
            tempInvestment.fee.feeType = .expense
        } else {
            tempInvestment.fee.feeType = .income
        }
        
        tempInvestment.setAfterTaxCashflows()
        let y2: Decimal = tempInvestment.afterTaxCashflows.XNPV(aDiscountRate: yield, aDayCountMethod: self.economics.dayCountMethod)
        let newFeeAmount = mxbFactor(factor1: x1, value1: y1, factor2: x2, value2: y2)
        

        //Then adjust fee in the actual investment
        self.fee.amount = newFeeAmount.toString(decPlaces: 4)
        tempInvestment.afterTaxCashflows.items.removeAll()
    }
    
   
    
}
