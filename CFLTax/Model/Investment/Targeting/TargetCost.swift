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
        var x1 = tempInvestment.asset.lessorCost.toDecimal()
        var x2: Decimal = 0.0
        var y2: Decimal = 0.0
        var iCounter: Int = 1
        var mxbCost: Decimal = 0.0
       
        var yield: Decimal = aTargetYield
        if isAfterTax == false {
            yield = yield * (1.0 - self.taxAssumptions.federalTaxRate.toDecimal())
        }
        
        var y1 = getNPVAfterNewCost_AT(aInvestment: tempInvestment, aDiscountRate: yield)
        if abs(y1) > toleranceLumpSums {
            if y1 > 0.0 {
                x2 = incrementCost(aInvestment: tempInvestment, aStartCost: x1, aTargetYield: yield, aCounter: iCounter)
                tempInvestment.asset.lessorCost = x2.toString(decPlaces: 4)
                y2 = getNPVAfterNewCost_AT(aInvestment: tempInvestment, aDiscountRate: yield)
            } else {
                x2 = decrementCost(aInvestment: tempInvestment, aStartCost: x1, aTargetYield: yield, aCounter: iCounter)
                tempInvestment.asset.lessorCost = x2.toString(decPlaces: 4)
                y2 = getNPVAfterNewCost_AT(aInvestment: tempInvestment, aDiscountRate: yield)
            }
            
            iCounter = 2
            while iCounter < 4 {
                mxbCost = mxbFactor(factor1: x1, value1: y1, factor2: x2, value2: y2)
                tempInvestment.asset.lessorCost = mxbCost.toString()
                let newNPV = getNPVAfterNewCost_AT(aInvestment: tempInvestment, aDiscountRate: yield)
                print("Count: \(iCounter): MxbCost: \(mxbCost) NPV: \(newNPV)")
                if abs(newNPV) < toleranceLumpSums {
                    break
                }
                x1 = mxbCost
                y1 = newNPV
                
                if newNPV > 0.0 {
                    x2 = incrementCost(aInvestment: tempInvestment, aStartCost: x1, aTargetYield: yield, aCounter: iCounter)
                    tempInvestment.asset.lessorCost = x2.toString()
                    y2 = getNPVAfterNewCost_AT(aInvestment: tempInvestment, aDiscountRate: yield)
                } else {
                    x2 = decrementCost(aInvestment: tempInvestment, aStartCost: x1, aTargetYield: yield, aCounter: iCounter)
                    tempInvestment.asset.lessorCost = x2.toString()
                    y2 = getNPVAfterNewCost_AT(aInvestment: tempInvestment, aDiscountRate: yield)
                }
                iCounter += 1
            }
            self.asset.lessorCost = mxbCost.toString(decPlaces: 4)
        }
        
    }
    
    private func incrementCost(aInvestment: Investment, aStartCost: Decimal, aTargetYield: Decimal, aCounter: Int) -> Decimal{
        let tempInvestment: Investment = aInvestment.clone()
        var startingCost: Decimal = aStartCost
        let factor: Decimal = power(base: 10.0, exp: aCounter)

        tempInvestment.asset.lessorCost = startingCost.toString()
        
        var npv: Decimal = getNPVAfterNewCost_AT(aInvestment: tempInvestment, aDiscountRate: aTargetYield)
        while npv > 0.0 {
            startingCost =  startingCost + startingCost / factor
            tempInvestment.asset.lessorCost = startingCost.toString()
            npv = getNPVAfterNewCost_AT(aInvestment: tempInvestment, aDiscountRate: aTargetYield)
        }
        
        return startingCost
    }
    
    private func decrementCost(aInvestment: Investment, aStartCost: Decimal, aTargetYield: Decimal, aCounter: Int) -> Decimal{
        let tempInvestment: Investment = aInvestment.clone()
        var startingCost: Decimal = aStartCost
        let factor: Decimal = power(base: 10.0, exp: aCounter)
        
        tempInvestment.asset.lessorCost = startingCost.toString()
        
        var npv: Decimal = getNPVAfterNewCost_AT(aInvestment: tempInvestment, aDiscountRate: aTargetYield)
        while npv < 0.0 {
            startingCost =  startingCost - startingCost / factor
            tempInvestment.asset.lessorCost = startingCost.toString()
            npv = getNPVAfterNewCost_AT(aInvestment: tempInvestment, aDiscountRate: aTargetYield)
        }
        
        return startingCost
    }
    
    private func getNPVAfterNewCost_AT(aInvestment: Investment, aDiscountRate: Decimal) -> Decimal{
        let tempInvestment: Investment = aInvestment.clone()
        tempInvestment.setAfterTaxCashflows()
        let newNPV: Decimal = tempInvestment.afterTaxCashflows.ModXNPV(aDiscountRate: aDiscountRate, aDayCountMethod: self.economics.dayCountMethod)
        tempInvestment.afterTaxCashflows.items.removeAll()
        
        return newNPV
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
