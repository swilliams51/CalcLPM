//
//  TargetEBO.swift
//  CFLTax
//
//  Created by Steven Williams on 11/26/24.
//

import Foundation


extension Investment {
    
    public func solveForEarlyBuyoutAmount(aEBOInvestment: Investment, aTargetYield: Decimal, aPlannedIncome: Decimal, aUnplannedDate: Date) -> Decimal {
        let tempInvestment: Investment = aEBOInvestment.clone()
        let startingEBOAmount: Decimal = tempInvestment.asset.lessorCost.toDecimal() * 0.30
        tempInvestment.asset.residualValue = startingEBOAmount.toString(decPlaces: 4)
        
        var x1: Decimal = startingEBOAmount
        var x2: Decimal = 0.0
        var mxbEBOAmount: Decimal = 0.0
        var iCounter: Int = 1
        
        //2. Get NPV for y1, x = 0.0
        var y1 = getNPVAfterNewEBOAmount_AT(aInvestment: tempInvestment, aEBOAmount: x1, discountRate: aTargetYield, aPlannedIncome: aPlannedIncome, aUnplannedDate: aUnplannedDate)
        if abs(y1) > toleranceLumpSums {
            if y1 > 0.0 {
                x2 = decrementEBOAmount_AT(aInvestment: tempInvestment, discountRate: aTargetYield, aEBOAmount: x1, aNPV: y1, iCounter: 1, aPlannedIncome: aPlannedIncome, aUnplannedDate: aUnplannedDate)
            } else {
                x2 = incrementEBOAmount_AT(aInvestment: tempInvestment, discountRate: aTargetYield, aEBOAmount: x1, aNPV: y1, iCounter: 1, aPlannedIncome: aPlannedIncome, aUnplannedDate:aUnplannedDate)
            }
            var y2: Decimal = getNPVAfterNewEBOAmount_AT(aInvestment: tempInvestment, aEBOAmount: x2, discountRate: aTargetYield, aPlannedIncome: aPlannedIncome, aUnplannedDate: aUnplannedDate)
            
            iCounter = 2
            while iCounter < 6 {
                mxbEBOAmount = mxbFactor(factor1: x1, value1: y1, factor2: x2, value2: y2)
                let newNPV = getNPVAfterNewEBOAmount_AT(aInvestment: tempInvestment, aEBOAmount: mxbEBOAmount, discountRate: aTargetYield, aPlannedIncome: aPlannedIncome, aUnplannedDate: aUnplannedDate)
                
                if abs(newNPV) < toleranceLumpSums {
                    break
                }
                
                x1 = mxbEBOAmount
                y1 = newNPV
                
                if newNPV > 0.0 {
                    x2 = decrementEBOAmount_AT(aInvestment: tempInvestment, discountRate: aTargetYield, aEBOAmount: mxbEBOAmount, aNPV: newNPV, iCounter: iCounter, aPlannedIncome: aPlannedIncome, aUnplannedDate: aUnplannedDate)
                } else {
                    x2 = incrementEBOAmount_AT(aInvestment: tempInvestment, discountRate: aTargetYield, aEBOAmount: mxbEBOAmount, aNPV: newNPV, iCounter: iCounter, aPlannedIncome: aPlannedIncome, aUnplannedDate: aUnplannedDate)
                }
                y2 = getNPVAfterNewEBOAmount_AT(aInvestment: tempInvestment, aEBOAmount: x2, discountRate: aTargetYield, aPlannedIncome: aPlannedIncome, aUnplannedDate: aUnplannedDate)
                iCounter += 1
            }
        }
        
        return mxbEBOAmount
    }
        
    private func getNPVAfterNewEBOAmount_AT(aInvestment: Investment, aEBOAmount: Decimal, discountRate: Decimal, aPlannedIncome: Decimal, aUnplannedDate: Date) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        tempInvestment.asset.residualValue = aEBOAmount.toString(decPlaces: 4)
        tempInvestment.setAfterTaxCashflows(plannedIncome: aPlannedIncome.toString(decPlaces: 4), unplannedDate: aUnplannedDate)
        let newNPV: Decimal = tempInvestment.afterTaxCashflows.ModXNPV(aDiscountRate: discountRate, aDayCountMethod: self.economics.dayCountMethod)
        tempInvestment.afterTaxCashflows.items.removeAll()
        
        return newNPV
    }
    
    private func decrementEBOAmount_AT(aInvestment: Investment, discountRate: Decimal, aEBOAmount: Decimal, aNPV: Decimal, iCounter: Int, aPlannedIncome: Decimal, aUnplannedDate: Date) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        var newEBOAmount: Decimal = aEBOAmount
        var newNPV: Decimal = aNPV
        let factor = min(power(base: 10.0, exp: iCounter), 100000.00)
        var i: Decimal = 1.0
        
        while newNPV > 0.0 {
            newEBOAmount =  newEBOAmount - (newEBOAmount / factor) * i
            newNPV = getNPVAfterNewEBOAmount_AT(aInvestment: tempInvestment, aEBOAmount: newEBOAmount, discountRate: discountRate, aPlannedIncome: aPlannedIncome, aUnplannedDate: aUnplannedDate)
            i += 1.0
        }
        
        return newEBOAmount
    }
    
    private func incrementEBOAmount_AT(aInvestment: Investment, discountRate: Decimal, aEBOAmount: Decimal, aNPV: Decimal, iCounter: Int, aPlannedIncome: Decimal, aUnplannedDate: Date) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        var newResidual: Decimal = aEBOAmount
        var newNPV: Decimal = aNPV
        let factor = min(power(base: 10.0, exp: iCounter), 100000.00)
        var i: Decimal = 1.0
        
        while newNPV < 0.0 {
            newResidual =  newResidual + (newResidual / factor) * i
            newNPV = getNPVAfterNewEBOAmount_AT(aInvestment: tempInvestment, aEBOAmount: newResidual, discountRate: discountRate, aPlannedIncome: aPlannedIncome, aUnplannedDate: aUnplannedDate)
            i += 1
        }
        
        return newResidual
    }
        
}
    
