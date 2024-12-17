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
        let startingResidual: Decimal = tempInvestment.asset.lessorCost.toDecimal() * 0.10
        tempInvestment.asset.residualValue = startingResidual.toString(decPlaces: 4)
        
        var x1: Decimal = startingResidual
        var x2: Decimal = 0.0
        var mxbResidual: Decimal = 0.0
        var iCounter: Int = 1

        //1. Set target yield to after tax if input is before tax
        var yield: Decimal = aTargetYield
        if isAfterTax == false {
            yield = yield * (1.0 - self.taxAssumptions.federalTaxRate.toDecimal())
        }
        
       //2. Get NPV for y1, x = 0.0
        var y1 = getNPVAfterNewResidual_AT(aInvestment: tempInvestment, aResidual: x1, discountRate: yield)
        if abs(y1) > toleranceLumpSums {
            if y1 > 0.0 {
                x2 = decrementResidual_AT(aInvestment: tempInvestment, discountRate: yield, aResidual: x1, aNPV: y1, iCounter: 1)
            } else {
                x2 = incrementResidual_AT(aInvestment: tempInvestment, discountRate: yield, aResidual: x1, aNPV: y1, iCounter: 1)
            }
            var y2: Decimal = getNPVAfterNewResidual_AT(aInvestment: tempInvestment, aResidual: x2, discountRate: yield)
            
            iCounter = 2
            while iCounter < 7 {
                mxbResidual = mxbFactor(factor1: x1, value1: y1, factor2: x2, value2: y2)
                let newNPV = getNPVAfterNewResidual_AT(aInvestment: tempInvestment, aResidual: mxbResidual, discountRate: yield)
                
                if abs(newNPV) < 0.05 {
                    break
                }
                
                x1 = mxbResidual
                y1 = newNPV
                
                if newNPV > 0.0 {
                    x2 = decrementResidual_AT(aInvestment: tempInvestment, discountRate: yield, aResidual: mxbResidual, aNPV: newNPV, iCounter: iCounter)
                } else {
                    x2 = incrementResidual_AT(aInvestment: tempInvestment, discountRate: yield, aResidual: mxbResidual, aNPV: newNPV, iCounter: iCounter)
                }
                y2 = getNPVAfterNewResidual_AT(aInvestment: tempInvestment, aResidual: x2, discountRate: aTargetYield)
                
                iCounter += 1
            }
            
            self.asset.residualValue = mxbResidual.toString(decPlaces: 4)
        }
    }
    
    private func getNPVAfterNewResidual_AT(aInvestment: Investment, aResidual: Decimal, discountRate: Decimal) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        tempInvestment.asset.residualValue = aResidual.toString(decPlaces: 4)
        tempInvestment.setAfterTaxCashflows()
        let newNPV: Decimal = tempInvestment.afterTaxCashflows.ModXNPV(aDiscountRate: discountRate, aDayCountMethod: self.economics.dayCountMethod)
        tempInvestment.afterTaxCashflows.items.removeAll()
        
        return newNPV
    }
    
    private func decrementResidual_AT(aInvestment: Investment, discountRate: Decimal, aResidual: Decimal, aNPV: Decimal, iCounter: Int) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        var newResidual: Decimal = aResidual
        var newNPV: Decimal = aNPV
        let factor = min(power(base: 10.0, exp: iCounter), 100000.00)
        var i: Decimal = 1.0
        
        while newNPV > 0.0 {
            newResidual =  newResidual - (newResidual / factor) * i
            newNPV = getNPVAfterNewResidual_AT(aInvestment: tempInvestment, aResidual: newResidual, discountRate: discountRate)
            i += 1.0
        }
        
        return newResidual
    }

    private func incrementResidual_AT(aInvestment: Investment, discountRate: Decimal, aResidual: Decimal, aNPV: Decimal, iCounter: Int) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        var newResidual: Decimal = aResidual
        var newNPV: Decimal = aNPV
        let factor = min(power(base: 10.0, exp: iCounter), 100000.00)
        var i: Decimal = 1.0
        
        while newNPV < 0.0 {
            newResidual =  newResidual + (newResidual / factor) * i
            newNPV = getNPVAfterNewResidual_AT(aInvestment: tempInvestment, aResidual: newResidual, discountRate: discountRate)
            i += 1
        }
        
        return newResidual
    }
    
    private func solveForResidual_IRROfPTCF(aTargetYield: Decimal) {
        let tempInvestment: Investment = self.clone()
        let yield: Decimal = aTargetYield
        var newFactor: Decimal = 0.0
        var x1: Decimal = 0.0
        var y1: Decimal = getNPVAfterNewFactor_BT(aInvestment: tempInvestment, aFactor: x1, discountRate: yield)
        var x2: Decimal = 0.30
        var y2: Decimal = getNPVAfterNewFactor_BT(aInvestment: tempInvestment, aFactor: x2, discountRate: yield)
        
        var counter:Int = 1
        while counter < 10 {
            newFactor = mxbFactor(factor1: x1, value1: y1, factor2: x2, value2: y2)
            if newFactor < 0.0 {
                newFactor = 0.0
                break
            }
            let myBalance = getNPVAfterNewFactor_BT(aInvestment: tempInvestment, aFactor: newFactor, discountRate: yield)
            if abs(myBalance) < 0.05 {
                break
            }
            x1 = newFactor
            y1 = myBalance
            
            if myBalance < 0.0 {
                x2 = incrementFactor_BT(aInvestment: tempInvestment, discountRate: yield, x1: x1, y1: y1, iCounter: counter)
                y2 = getNPVAfterNewFactor_BT(aInvestment: tempInvestment, aFactor: x2, discountRate: yield)
            } else {
                x2 = decrementFactor_BT(aInvestment: tempInvestment, discountRate: yield, x1: x1, y1: y1, iCounter: counter)
                y2 = getNPVAfterNewFactor_BT(aInvestment: tempInvestment, aFactor: x2, discountRate: yield)
            }
            counter += 1
        }
        
        let myResidual: Decimal = tempInvestment.getAssetCost(asCashflow: false) * newFactor
        self.asset.residualValue = myResidual.toString(decPlaces: 4)
    }
    
    private func decrementFactor_BT(aInvestment: Investment, discountRate: Decimal, x1: Decimal, y1: Decimal, iCounter: Int) -> Decimal {
        let tempInvestment = aInvestment.clone()
        var newX: Decimal = x1
        var newY : Decimal = y1
        let factor: Decimal = power(base: 10.0, exp: iCounter)
        
        while newY > 0.0 {
            newX = newX - newX / factor
            newY = getNPVAfterNewFactor_BT(aInvestment: tempInvestment, aFactor: newX, discountRate: discountRate)
        }
        
        return newX
    }
    
    private func incrementFactor_BT(aInvestment: Investment, discountRate: Decimal, x1: Decimal, y1: Decimal, iCounter: Int) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        var newX: Decimal = x1
        var newY: Decimal = y1
        let factor: Decimal = power(base: 10.0, exp: iCounter)
        
        while newY < 0.0 {
            newX = newX + newX / factor
            newY = getNPVAfterNewFactor_BT(aInvestment: tempInvestment, aFactor: newX, discountRate: discountRate)
        }
        
        return newX
    }
    
    private func getNPVAfterNewFactor_BT(aInvestment: Investment, aFactor: Decimal, discountRate: Decimal) -> Decimal{
        let tempInvestment: Investment = aInvestment.clone()
        let myResidual: Decimal = tempInvestment.getAssetCost(asCashflow: false) * aFactor
        tempInvestment.asset.residualValue = myResidual.toString(decPlaces: 4)
        tempInvestment.setBeforeTaxCashflows()
        let newNPV: Decimal = tempInvestment.beforeTaxCashflows.ModXNPV(aDiscountRate: discountRate, aDayCountMethod: self.economics.dayCountMethod)
        tempInvestment.beforeTaxCashflows.items.removeAll()
        
        return newNPV
        
    }
}
