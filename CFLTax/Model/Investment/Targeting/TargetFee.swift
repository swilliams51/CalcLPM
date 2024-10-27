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
        
        var bolIsAfterTax: Bool = true
        
        switch aYieldMethod {
        case .MISF_AT:
            bolIsAfterTax = true
        case .MISF_BT:
            bolIsAfterTax = false
        case .IRR_PTCF:
            bolIsAfterTax = false
        }
        
        let feeType: FeeType = getFeeType(aInvestment: myInvestment, aTargetYield: aTargetYield, isAfterTax: bolIsAfterTax)
        
        if feeType == .income {
            switch aYieldMethod {
            case .MISF_AT:
                solveForFeeIncome_MISF(aInvestment: myInvestment, aTargetYield: aTargetYield, isAfterTax: true)
            case .MISF_BT:
                solveForFeeIncome_MISF(aInvestment: myInvestment, aTargetYield: aTargetYield, isAfterTax: false)
            case .IRR_PTCF:
                solveForFee_IRROfPTCF(aInvestment: myInvestment, aTargetYield: aTargetYield)
            }
        } else {
            switch aYieldMethod {
            case .MISF_AT:
                solveForFeeExpense_MISF(aInvestment: myInvestment ,aTargetYield: aTargetYield, isAfterTax: true)
            case .MISF_BT:
                solveForFeeExpense_MISF(aInvestment: myInvestment, aTargetYield: aTargetYield, isAfterTax: false)
            case .IRR_PTCF:
                solveForFee_IRROfPTCF(aInvestment: myInvestment, aTargetYield: aTargetYield)
            }
        }
    }
    
    private func getFeeType(aInvestment: Investment, aTargetYield: Decimal, isAfterTax: Bool) -> FeeType {
        var myFeeType: FeeType = .expense
        let tempInvestment: Investment = aInvestment.clone()
        
        tempInvestment.setFeeToDefault()
        tempInvestment.fee.amount = (0.0).toString()
        tempInvestment.economics.solveFor = .yield
        tempInvestment.calculate()
        var baseRate: Decimal = tempInvestment.getMISF_AT_Yield()
        if isAfterTax == false {
            baseRate = baseRate * (1.0 - tempInvestment.taxAssumptions.federalTaxRate.toDecimal())
        }
        
        if aTargetYield > baseRate {
            myFeeType = .income
        }
        
        return myFeeType
    }
    
    private func solveForFeeIncome_MISF(aInvestment: Investment,aTargetYield: Decimal, isAfterTax: Bool) {
        let tempInvestment: Investment = aInvestment.clone()
        tempInvestment.setFeeToDefault()
        tempInvestment.fee.amount = (0.0).toString()
        var myTargetYield = aTargetYield
        
        if isAfterTax == false {
            myTargetYield = myTargetYield * (1.0 - tempInvestment.taxAssumptions.federalTaxRate.toDecimal())
        }
        
        tempInvestment.setAfterTaxCashflows()
        let netPresentValue: Decimal = tempInvestment.afterTaxCashflows.ModXNPV(aDiscountRate: myTargetYield, aDayCountMethod: tempInvestment.economics.dayCountMethod)
        var feeAmount: Decimal = netPresentValue / (1.0 - tempInvestment.taxAssumptions.federalTaxRate.toDecimal())
        feeAmount = feeAmount * -1.0
        self.fee.amount = feeAmount.toString()
        self.fee.feeType = .income
        self.setFee()
    }

    private func solveForFeeExpense_MISF(aInvestment: Investment, aTargetYield: Decimal, isAfterTax: Bool) {
        let tempInvestment: Investment = aInvestment.clone()
        tempInvestment.setFeeToDefault()
        var x1: Decimal = tempInvestment.asset.lessorCost.toDecimal() * 0.025
        var x2: Decimal = 0.0
        var mxbFee: Decimal = 0.0
        var iCounter: Int = 1
        tempInvestment.fee.amount = (x1).toString()

        //1. Set target yield to after tax if input is before tax
        var yield: Decimal = aTargetYield
        if isAfterTax == false {
            yield = yield * (1.0 - self.taxAssumptions.federalTaxRate.toDecimal())
        }
        
       //2. Get NPV for y1, x = 0.0
        var y1 = getNPVAfterNewFee_AT(aInvestment: tempInvestment, discountRate: aTargetYield)
        if abs(y1) > toleranceLumpSums {
            if y1 > 0.0 {
                x2 = incrementFee(aInvestment: tempInvestment, aFeeStartingValue: x1, aTargetYield: aTargetYield, aCounter: 1)
            } else {
                x2 = decrementFee(aInvestment: tempInvestment, aFeeStartingValue: x1, aTargetYield: aTargetYield, aCounter: 1)
            }
            
            tempInvestment.fee.amount = x2.toString()
            var y2: Decimal = getNPVAfterNewFee_AT(aInvestment: tempInvestment, discountRate: aTargetYield)
           
            iCounter = 2
            while iCounter < 4 {
                mxbFee = mxbFactor(factor1: x1, value1: y1, factor2: x2, value2: y2)
                tempInvestment.fee.amount = mxbFee.toString()
                let newNPV = getNPVAfterNewFee_AT(aInvestment: tempInvestment, discountRate: aTargetYield)
                print("Count: \(iCounter): MxbFee: \(mxbFee) NPV: \(newNPV)")
                if abs(newNPV) < toleranceLumpSums {
                    break
                }
                
                x1 = mxbFee
                y1 = newNPV
                
                if newNPV > 0.0 {
                    x2 = incrementFee(aInvestment: tempInvestment, aFeeStartingValue: mxbFee, aTargetYield: aTargetYield, aCounter: iCounter)
                    tempInvestment.fee.amount = x2.toString()
                    y2 = getNPVAfterNewFee_AT(aInvestment: tempInvestment, discountRate: aTargetYield)
                } else {
                    x2 = decrementFee(aInvestment: tempInvestment, aFeeStartingValue: mxbFee, aTargetYield: aTargetYield, aCounter: iCounter)
                    tempInvestment.fee.amount = x2.toString()
                    y2 = getNPVAfterNewFee_AT(aInvestment: tempInvestment, discountRate: aTargetYield)
                }
                iCounter += 1
            }
            
            self.fee.amount = mxbFee.toString(decPlaces: 4)
            self.fee.feeType = .expense
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
        tempInvestment.fee.amount = startingFeeAmount.toString()
        
        var npv: Decimal = getNPVAfterNewFee_AT(aInvestment: tempInvestment, discountRate: aTargetYield)
        while npv > 0.0 {
            startingFeeAmount =  startingFeeAmount + startingFeeAmount / factor
            tempInvestment.fee.amount = startingFeeAmount.toString()
            npv = getNPVAfterNewFee_AT(aInvestment: tempInvestment, discountRate: aTargetYield)
        }
        
        return startingFeeAmount
    }
    
    private func decrementFee(aInvestment: Investment, aFeeStartingValue: Decimal, aTargetYield: Decimal, aCounter: Int) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        var startingFeeAmount: Decimal = aFeeStartingValue
        let factor: Decimal = power(base: 10.0, exp: aCounter)
        tempInvestment.fee.amount = startingFeeAmount.toString()
        
        var npv: Decimal = getNPVAfterNewFee_AT(aInvestment: tempInvestment, discountRate: aTargetYield)
        while npv < 0.0 {
            startingFeeAmount =  startingFeeAmount - startingFeeAmount / factor
            tempInvestment.fee.amount = startingFeeAmount.toString()
            npv = getNPVAfterNewFee_AT(aInvestment: tempInvestment, discountRate: aTargetYield)
        }
        
        return startingFeeAmount
    }
    
    private func solveForFee_IRROfPTCF(aInvestment: Investment,aTargetYield: Decimal) {
        //Clone the investment and set x1 = 0.0
        let tempInvestment: Investment = aInvestment.clone()
        let x1: String = "0.0"
        tempInvestment.fee.amount = x1
        
        //2. Get NPV for y1, x = 0.0
         tempInvestment.setBeforeTaxCashflows()
        let y1: Decimal = tempInvestment.beforeTaxCashflows.ModXNPV(aDiscountRate: aTargetYield, aDayCountMethod: self.economics.dayCountMethod)
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
        let y2: Decimal = tempInvestment.beforeTaxCashflows.ModXNPV(aDiscountRate: aTargetYield, aDayCountMethod: self.economics.dayCountMethod)
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
