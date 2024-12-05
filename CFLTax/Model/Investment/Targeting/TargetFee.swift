//
//  TargetFee.swift
//  CFLTax
//
//  Created by Steven Williams on 8/27/24.
//

import Foundation


extension Investment {
    public func solveForFee(aYieldMethod: YieldMethod, aTargetYield: Decimal) {
        let myInvestment: Investment = self.clone()
        var feeType: FeeType = .expense
        
        switch aYieldMethod {
        case .MISF_AT:
            feeType = getFeeType_MISF(aInvestment: myInvestment, aTargetYield: aTargetYield, isAfterTax: true)
        case .MISF_BT:
            feeType = getFeeType_MISF(aInvestment: myInvestment, aTargetYield: aTargetYield, isAfterTax: false)
        case .IRR_PTCF:
            feeType = getFeeType_IRR(aInvestment: myInvestment, aTargetYield: aTargetYield)
        }
    
        
        if feeType == .income {
            switch aYieldMethod {
            case .MISF_AT:
                solveForFee_MISF(aInvestment: myInvestment, aTargetYield: aTargetYield, isAfterTax: true, aFeeType: .income)
            case .MISF_BT:
                solveForFee_MISF(aInvestment: myInvestment, aTargetYield: aTargetYield, isAfterTax: false, aFeeType: .income)
            case .IRR_PTCF:
                solveForFee_IRROfPTCF(aInvestment: myInvestment, aTargetYield: aTargetYield, aFeeType: .income)
            }
        } else {
            switch aYieldMethod {
            case .MISF_AT:
                solveForFee_MISF(aInvestment: myInvestment ,aTargetYield: aTargetYield, isAfterTax: true, aFeeType: .expense)
            case .MISF_BT:
                solveForFee_MISF(aInvestment: myInvestment, aTargetYield: aTargetYield, isAfterTax: false, aFeeType: .expense)
            case .IRR_PTCF:
                solveForFee_IRROfPTCF(aInvestment: myInvestment, aTargetYield: aTargetYield, aFeeType: .expense)
            }
        }
    }
    
    private func getFeeType_MISF(aInvestment: Investment, aTargetYield: Decimal, isAfterTax: Bool) -> FeeType {
        var myFeeType: FeeType = .expense
        let tempInvestment: Investment = aInvestment.clone()
        tempInvestment.setFeeToDefault()
        tempInvestment.fee.amount = (0.0).toString()
        tempInvestment.economics.solveFor = .yield
        tempInvestment.calculate()
        var baseRate: Decimal = tempInvestment.getMISF_AT_Yield()
        if isAfterTax == false {
            baseRate = baseRate / (1.0 - tempInvestment.taxAssumptions.federalTaxRate.toDecimal())
        }
        
        if aTargetYield > baseRate {
            myFeeType = .income
        }
        
        return myFeeType
    }
    
    
    private func getFeeType_IRR(aInvestment: Investment, aTargetYield: Decimal) -> FeeType {
        var myFeeType: FeeType = .expense
        let tempInvestment: Investment = aInvestment.clone()
        tempInvestment.setFeeToDefault()
        tempInvestment.fee.amount = (0.0).toString()
        tempInvestment.economics.solveFor = .yield
        tempInvestment.calculate()
        let baseRate: Decimal = tempInvestment.getIRR_PTCF()
        
        if aTargetYield > baseRate {
            myFeeType = .income
        }
        
        return myFeeType
    }

    private func solveForFee_MISF(aInvestment: Investment, aTargetYield: Decimal, isAfterTax: Bool, aFeeType: FeeType) {
        let tempInvestment: Investment = aInvestment.clone()
        tempInvestment.setFeeToDefault()
        var x1: Decimal = tempInvestment.asset.lessorCost.toDecimal() * 0.025
        var x2: Decimal = 0.0
        var mxbFee: Decimal = 0.0
        var iCounter: Int = 1
        tempInvestment.fee.amount = (x1).toString()
        tempInvestment.fee.feeType = aFeeType

        //1. Set target yield to after tax if input is before tax
        var yield: Decimal = aTargetYield
        if isAfterTax == false {
            yield = yield * (1.0 - self.taxAssumptions.federalTaxRate.toDecimal())
        }
        
       //2. Get NPV for y1, x = 0.025
        var y1 = getNPVAfterNewFee_AT(aInvestment: tempInvestment, discountRate: yield)
        if abs(y1) > toleranceLumpSums {
            if y1 > 0.0 {
                x2 = incrementFee(aInvestment: tempInvestment, aFeeStartingValue: x1, aTargetYield: yield, aCounter: 1)
            } else {
                x2 = decrementFee(aInvestment: tempInvestment, aFeeStartingValue: x1, aTargetYield: yield, aCounter: 1)
            }
            
            tempInvestment.fee.amount = x2.toString()
            var y2: Decimal = getNPVAfterNewFee_AT(aInvestment: tempInvestment, discountRate: yield)
           
            iCounter = 2
            while iCounter < 4 {
                mxbFee = mxbFactor(factor1: x1, value1: y1, factor2: x2, value2: y2)
                tempInvestment.fee.amount = mxbFee.toString()
                let newNPV = getNPVAfterNewFee_AT(aInvestment: tempInvestment, discountRate: yield)
                if abs(newNPV) < toleranceLumpSums {
                    break
                }
                
                x1 = mxbFee
                y1 = newNPV
                
                if newNPV > 0.0 {
                    x2 = incrementFee(aInvestment: tempInvestment, aFeeStartingValue: mxbFee, aTargetYield: yield, aCounter: iCounter)
                    tempInvestment.fee.amount = x2.toString()
                } else {
                    x2 = decrementFee(aInvestment: tempInvestment, aFeeStartingValue: mxbFee, aTargetYield: yield, aCounter: iCounter)
                    tempInvestment.fee.amount = x2.toString()
                }
                y2 = getNPVAfterNewFee_AT(aInvestment: tempInvestment, discountRate: yield)
                
                iCounter += 1
            }
            
            if mxbFee.isEquivalentToZero(aTolerance: 1.0) {
                mxbFee = 0.0
            }
            
            self.fee.amount = mxbFee.toString(decPlaces: 4)
            self.fee.feeType = aFeeType
            self.setFee()
        }
       
    }
   
    private func getNPVAfterNewFee_AT(aInvestment: Investment, discountRate: Decimal) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        tempInvestment.setAfterTaxCashflows()
        let newNPV: Decimal = tempInvestment.afterTaxCashflows.ModXNPV(aDiscountRate: discountRate, aDayCountMethod: self.economics.dayCountMethod)
        tempInvestment.afterTaxCashflows.items.removeAll()
        
        return newNPV
    }
    
    private func incrementFee(aInvestment: Investment, aFeeStartingValue: Decimal, aTargetYield: Decimal, aCounter: Int) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        var startingFeeAmount: Decimal = aFeeStartingValue
        let factor: Decimal = power(base: 10.0, exp: aCounter)
        var factor2: Decimal = 1.0
        if tempInvestment.fee.feeType == .income {
            factor2 = -1.0
        }
        tempInvestment.fee.amount = startingFeeAmount.toString()
        
        var npv: Decimal = getNPVAfterNewFee_AT(aInvestment: tempInvestment, discountRate: aTargetYield)
        while npv > 0.0 {
            startingFeeAmount =  startingFeeAmount + startingFeeAmount / factor * factor2
            tempInvestment.fee.amount = startingFeeAmount.toString()
            npv = getNPVAfterNewFee_AT(aInvestment: tempInvestment, discountRate: aTargetYield)
        }
        
        return startingFeeAmount
    }
    
    private func decrementFee(aInvestment: Investment, aFeeStartingValue: Decimal, aTargetYield: Decimal, aCounter: Int) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        var startingFeeAmount: Decimal = aFeeStartingValue
        let factor: Decimal = power(base: 10.0, exp: aCounter)
        var factor2: Decimal = 1.0
        if tempInvestment.fee.feeType == .income {
            factor2 = -1.0
        }
        tempInvestment.fee.amount = startingFeeAmount.toString()
        
        var npv: Decimal = getNPVAfterNewFee_AT(aInvestment: tempInvestment, discountRate: aTargetYield)
        while npv < 0.0 {
            startingFeeAmount =  startingFeeAmount - startingFeeAmount / factor * factor2
            tempInvestment.fee.amount = startingFeeAmount.toString()
            npv = getNPVAfterNewFee_AT(aInvestment: tempInvestment, discountRate: aTargetYield)
        }
        
        return startingFeeAmount
    }
    
    private func solveForFee_IRROfPTCF(aInvestment: Investment, aTargetYield: Decimal, aFeeType: FeeType) {
        let tempInvestment: Investment = aInvestment.clone()
        let x1: Decimal = 0.0
        var x2: Decimal = 0.0
        
        tempInvestment.fee.amount = x1.toString()
        tempInvestment.fee.feeType = aFeeType
        
        //2. Get NPV for y1, x = 0.0
        let y1: Decimal = getNPVAfterNewFee_IRR(aInvestment: tempInvestment, discountRate: aTargetYield)
        
        if y1 > 0.0 {
            x2 = incrementFee_IRR(aInvestment: tempInvestment, aTargetYield: aTargetYield, aCounter: 1)
        } else {
            x2 = decrementFee_IRR(aInvestment: tempInvestment, aTargetYield: aTargetYield, aCounter: 1)
        }
        
        tempInvestment.fee.amount = x2.toString()
        let y2: Decimal = getNPVAfterNewFee_IRR(aInvestment: tempInvestment, discountRate: aTargetYield)
        var newFeeAmount:Decimal = mxbFactor(factor1: x1, value1: y1, factor2: x2, value2: y2)
        
        if newFeeAmount.isEquivalentToZero(aTolerance: 1.0) {
            newFeeAmount = 0.0
        }
        self.fee.amount = newFeeAmount.toString(decPlaces: 4)
        self.fee.feeType = aFeeType
        self.setFee()
    }
    
    private func getNPVAfterNewFee_IRR(aInvestment: Investment, discountRate: Decimal) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        tempInvestment.setBeforeTaxCashflows()
        let newNPV: Decimal = tempInvestment.beforeTaxCashflows.ModXNPV(aDiscountRate: discountRate, aDayCountMethod: self.economics.dayCountMethod)
        tempInvestment.beforeTaxCashflows.items.removeAll()
        
        return newNPV
    }
    
    private func incrementFee_IRR(aInvestment: Investment, aTargetYield: Decimal, aCounter: Int) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        var startingFeeAmount: Decimal = aInvestment.asset.lessorCost.toDecimal() * 0.02
        let factor: Decimal = power(base: 10.0, exp: aCounter)
        var factor2: Decimal = 1.0
        if tempInvestment.fee.feeType == .income {
            factor2 = -1.0
        }
        tempInvestment.fee.amount = startingFeeAmount.toString()
        
        var npv: Decimal = getNPVAfterNewFee_IRR(aInvestment: tempInvestment, discountRate: aTargetYield)
        while npv > 0.0 {
            startingFeeAmount =  startingFeeAmount + startingFeeAmount / factor * factor2
            tempInvestment.fee.amount = startingFeeAmount.toString()
            npv = getNPVAfterNewFee_IRR(aInvestment: tempInvestment, discountRate: aTargetYield)
        }
        
        return startingFeeAmount
        
    }
    
    
    private func decrementFee_IRR(aInvestment: Investment, aTargetYield: Decimal, aCounter: Int) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        var startingFeeAmount: Decimal = aInvestment.asset.lessorCost.toDecimal() * 0.02
        let factor: Decimal = power(base: 10.0, exp: aCounter)
        var factor2: Decimal = 1.0
        if tempInvestment.fee.feeType == .income {
            factor2 = -1.0
        }
        tempInvestment.fee.amount = startingFeeAmount.toString()
        
        var npv: Decimal = getNPVAfterNewFee_IRR(aInvestment: tempInvestment, discountRate: aTargetYield)
        while npv > 0.0 {
            startingFeeAmount =  startingFeeAmount + startingFeeAmount / factor * factor2
            tempInvestment.fee.amount = startingFeeAmount.toString()
            npv = getNPVAfterNewFee_IRR(aInvestment: tempInvestment, discountRate: aTargetYield)
        }
        
        return startingFeeAmount
    }
    
    

    
}
