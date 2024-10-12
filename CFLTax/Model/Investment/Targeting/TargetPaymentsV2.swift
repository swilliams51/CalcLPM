//
//  TargetPaymentsV2.swift
//  CFLTax
//
//  Created by Steven Williams on 8/27/24.
//

import Foundation


extension Investment {
    
    public func solveForPaymentsV2(aYieldMethod: YieldMethod, aTargetYield: Decimal) {
        switch aYieldMethod {
        case .MISF_AT:
            solveForPayments2_MISF(aTargetYield: aTargetYield, isAfterTax: true)
        case .MISF_BT:
            solveForPayments2_MISF(aTargetYield: aTargetYield, isAfterTax: false)
        case .IRR_PTCF:
            solveForPayment2_IRROfPTCF(aTargetYield: aTargetYield)
        }
    }
    
    private func solveForPayments2_MISF(aTargetYield: Decimal, isAfterTax: Bool) {
        let tempInvestment: Investment = self.clone()
        tempInvestment.setAfterTaxCashflows()
        
        var yield: Decimal = aTargetYield
        if isAfterTax == false {
            yield = yield * (1.0 - self.taxAssumptions.federalTaxRate.toDecimal())
        }
        
        var prevFactor: Decimal = 1.0
        var y = tempInvestment.afterTaxCashflows.ModXNPV(aDiscountRate: yield, aDayCountMethod: self.economics.dayCountMethod)
        var iCount = 1
        var currFactor = prevFactor
        while abs(y) > tolerancePaymentAmounts {
            if y > 0.0 {
                currFactor = decrementFactor_AT(aInvestment: tempInvestment, discountRate: yield,x1: prevFactor, y1: y, iCounter: iCount)
            } else {
                currFactor = incrementFactor_AT(aInvestment:tempInvestment, discountRate: yield, x1: prevFactor, y1: y, iCounter: iCount)
            }
            y = getNPVAfterNewFactor_AT(aInvestment: tempInvestment, aFactor: currFactor, discountRate: yield)
           
            iCount += 1
            prevFactor = currFactor
        }
        //Then adjust the payments in the actual investment
        for x in 0..<self.rent.groups.count {
            if self.rent.groups[x].locked == false {
                let newAmount = self.rent.groups[x].amount.toDecimal() * currFactor
                self.rent.groups[x].amount = newAmount.toString()
            }
        }
        tempInvestment.afterTaxCashflows.items.removeAll()
    }
    
    private func decrementFactor_AT(aInvestment: Investment, discountRate: Decimal, x1: Decimal, y1: Decimal, iCounter: Int) -> Decimal {
        let tempInvestment = aInvestment.clone()
        var newX: Decimal = x1
        var newY: Decimal = y1
        let factor: Decimal = power(base: 10.0, exp: iCounter)
        
        while newY > 0.0 {
            newX = newX - newX / factor
            newY = getNPVAfterNewFactor_AT(aInvestment: tempInvestment, aFactor: newX, discountRate: discountRate)
        }
        
        return mxbFactor(factor1: x1, value1: y1, factor2: newX, value2: newY)
    }
    
    
    private func incrementFactor_AT(aInvestment: Investment, discountRate: Decimal, x1: Decimal, y1: Decimal, iCounter: Int) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        var newX: Decimal = x1
        var newY: Decimal = y1
        let factor: Decimal = power(base: 10.0, exp: iCounter)
        
        while newY < 0.0 {
            newX = newX + newX / factor
            newY = getNPVAfterNewFactor_AT(aInvestment: tempInvestment, aFactor: newX, discountRate: discountRate)
        }
        
        return mxbFactor(factor1: x1, value1: y1, factor2: newX, value2: newY)
    }
    
    private func getNPVAfterNewFactor_AT(aInvestment: Investment, aFactor: Decimal, discountRate: Decimal) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        
        for x in 0..<tempInvestment.rent.groups.count {
            if tempInvestment.rent.groups[x].locked == false {
                var newAmount: Decimal = tempInvestment.rent.groups[x].amount.toDecimal()
                newAmount = newAmount * aFactor
                tempInvestment.rent.groups[x].amount = newAmount.toString()
            }
        }
        tempInvestment.setAfterTaxCashflows()
       
        let myNPV: Decimal = tempInvestment.afterTaxCashflows.ModXNPV(aDiscountRate: discountRate, aDayCountMethod: self.economics.dayCountMethod)
        
        return myNPV
    }
    
    //Before Tax Calcs
    public func solveForPayment2_IRROfPTCF(aTargetYield: Decimal) {
        let tempInvestment: Investment = self.clone()
        tempInvestment.setBeforeTaxCashflows()
        let yield = aTargetYield
        
        var factor: Decimal = 1.0
        var y = tempInvestment.beforeTaxCashflows.ModXNPV(aDiscountRate: yield, aDayCountMethod: self.economics.dayCountMethod)
        var iCount = 1
        
        while abs(y) > tolerancePaymentAmounts {
            if y > 0.0 {
                factor = decrementFactor_BT(aInvestment: tempInvestment, discountRate: yield,x1: factor, y1: y, iCounter: iCount)
            } else {
                factor = incrementFactor_BT(aInvestment:tempInvestment, discountRate: yield, x1: factor, y1: y, iCounter: iCount)
            }
            y = getNPVAfterNewFactor_BT(aInvestment: tempInvestment, aFactor: factor, discountRate: yield)
            iCount += 1
        }
        //Then adjust the payments in the actual investment
        for x in 0..<self.rent.groups.count {
            if self.rent.groups[x].locked == false {
                let newAmount = self.rent.groups[x].amount.toDecimal() * factor
                self.rent.groups[x].amount = newAmount.toString()
            }
        }
        tempInvestment.beforeTaxCashflows.items.removeAll()
    }
    
    private func decrementFactor_BT(aInvestment: Investment, discountRate: Decimal, x1: Decimal, y1: Decimal, iCounter: Int) -> Decimal {
        let tempInvestment = aInvestment.clone()
        var newX: Decimal = x1
        var newY: Decimal = y1
        let factor: Decimal = power(base: 10.0, exp: iCounter)
        
        while newY > 0.0 {
            newX = newX - newX / factor
            newY = getNPVAfterNewFactor_BT(aInvestment: tempInvestment, aFactor: newX, discountRate: discountRate)
        }
        
        return mxbFactor(factor1: x1, value1: y1, factor2: newX, value2: newY)
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
        
        return mxbFactor(factor1: x1, value1: y1, factor2: newX, value2: newY)
    }
    
    
    private func getNPVAfterNewFactor_BT(aInvestment: Investment, aFactor: Decimal, discountRate: Decimal) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        
        for x in 0..<tempInvestment.rent.groups.count {
            if tempInvestment.rent.groups[x].locked == false {
                let newAmount: Decimal = tempInvestment.rent.groups[x].amount.toDecimal() * aFactor
                tempInvestment.rent.groups[x].amount = newAmount.toString()
            }
        }
        
        tempInvestment.setBeforeTaxCashflows()
        let myNPV: Decimal = tempInvestment.beforeTaxCashflows.ModXNPV(aDiscountRate: discountRate, aDayCountMethod: self.economics.dayCountMethod)
        
        return myNPV
    }
    
    
    
}
