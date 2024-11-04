//
//  TargetPaymentsV3.swift
//  CFLTax
//
//  Created by Steven Williams on 10/23/24.
//

import Foundation


extension Investment{
    public func solveForUnlockedPayments(aYieldMethod: YieldMethod, aTargetYield: Decimal) {
        switch aYieldMethod {
        case .MISF_AT:
            solveForPayments2_MISF(aTargetYield: aTargetYield, isAfterTax: true)
        case .MISF_BT:
            solveForPayments2_MISF(aTargetYield: aTargetYield, isAfterTax: false)
        case .IRR_PTCF:
            solveForPayment3_IRROfPTCF(aTargetYield: aTargetYield)
        }
    }
    
    private func solveForPayments2_MISF(aTargetYield: Decimal, isAfterTax: Bool) {
        let tempInvestment: Investment = self.clone()
        tempInvestment.setAfterTaxCashflows()
        
        var yield: Decimal = aTargetYield
        if isAfterTax == false {
            yield = yield * (1.0 - self.taxAssumptions.federalTaxRate.toDecimal())
        }
        
        var newFactor: Decimal = 0.0
        var x1: Decimal = 1.0
        var x2: Decimal = 1.0
        var y1 = tempInvestment.afterTaxCashflows.ModXNPV(aDiscountRate: yield, aDayCountMethod: self.economics.dayCountMethod)
        if abs(y1) > tolerancePaymentAmounts {
            var iCount = 1
            
            if y1 < 0.0 {
                x2 = incrementFactor_AT(aInvestment: tempInvestment, discountRate: yield, x1: x1, y1: y1, iCounter: iCount)
            } else {
                x2 = decrementFactor_AT(aInvestment: tempInvestment, discountRate: yield, x1: x1, y1: y1, iCounter: iCount)
            }
            var y2 = getNPVAfterNewFactor_AT(aInvestment: tempInvestment, aFactor: x2, discountRate: yield)
            
            iCount = 2
            while iCount < 10 {
                newFactor = mxbFactor(factor1: x1, value1: y1, factor2: x2, value2: y2)
                let myBalance = getNPVAfterNewFactor_AT(aInvestment: tempInvestment, aFactor: newFactor, discountRate: yield)
                //print("newFactor: \(newFactor), NPV: \(myBalance)")
                
                if abs(myBalance) < tolerancePaymentAmounts {
                    break
                }
                x1 = newFactor
                y1 = myBalance
                
                if myBalance < 0.0 {
                    x2 = incrementFactor_AT(aInvestment: tempInvestment, discountRate: yield, x1: x1, y1: y1, iCounter: iCount)
                } else {
                    x2 = decrementFactor_AT(aInvestment: tempInvestment, discountRate: yield, x1: x1, y1: y1, iCounter: iCount)
                }
                y2 = getNPVAfterNewFactor_AT(aInvestment: tempInvestment, aFactor: x2, discountRate: yield)
                iCount += 1
            }
            
            //Then adjust the payments in the actual investment
            for x in 0..<self.rent.groups.count {
                if self.rent.groups[x].locked == false {
                    let newAmount = self.rent.groups[x].amount.toDecimal() * newFactor
                    self.rent.groups[x].amount = newAmount.toString()
                }
            }
            tempInvestment.afterTaxCashflows.items.removeAll()
        }
       
    }
    
    private func decrementFactor_AT(aInvestment: Investment, discountRate: Decimal, x1: Decimal, y1: Decimal, iCounter: Int) -> Decimal {
        let tempInvestment = aInvestment.clone()
        var newX: Decimal = x1
        var newY: Decimal = y1
        let factor: Decimal = min(power(base: 10.0, exp: iCounter), 100000.00)
        var count: Int = 1
        
        while newY > 0.0 {
            newX = newX - ((newX / factor) * Decimal(count))
            newY = getNPVAfterNewFactor_AT(aInvestment: tempInvestment, aFactor: newX, discountRate: discountRate)
            count += 1
        }
        
        return newX
    }
    
    
    private func incrementFactor_AT(aInvestment: Investment, discountRate: Decimal, x1: Decimal, y1: Decimal, iCounter: Int) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        var newX: Decimal = x1
        var newY: Decimal = y1
        let factor: Decimal = min(power(base: 10.0, exp: iCounter), 100000.00)
        var count: Int = 1
        
        while newY < 0.0 {
            newX = newX + ((newX / factor) * Decimal(count))
            newY = getNPVAfterNewFactor_AT(aInvestment: tempInvestment, aFactor: newX, discountRate: discountRate)
            count += 1
        }
        
        return newX
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
    
    //IRR of Before Tax Cashflows
    public func solveForPayment3_IRROfPTCF(aTargetYield: Decimal) {
        let tempInvestment: Investment = self.clone()
        tempInvestment.setBeforeTaxCashflows()
        let yield = aTargetYield
        
        var newFactor: Decimal = 0.0
        var x1: Decimal = 1.0
        var x2: Decimal = 1.0
        var y1 = tempInvestment.beforeTaxCashflows.ModXNPV(aDiscountRate: yield, aDayCountMethod: self.economics.dayCountMethod)
        var iCount = 1
        
        if y1 < 0.0 {
            x2 = incrementFactor_BT(aInvestment: tempInvestment, discountRate: yield, x1: x1, y1: y1, iCounter: iCount)
        } else {
            x2 = decrementFactor_BT(aInvestment: tempInvestment, discountRate: yield, x1: x1, y1: y1, iCounter: iCount)
        }
        var y2 = getNPVAfterNewFactor_BT(aInvestment: tempInvestment, aFactor: x2, discountRate: yield)
        
        iCount = 2
        while iCount < 10 {
            newFactor = mxbFactor(factor1: x1, value1: y1, factor2: x2, value2: y2)
            let myBalance = getNPVAfterNewFactor_BT(aInvestment: tempInvestment, aFactor: newFactor, discountRate: yield)
            
            if abs(myBalance) < tolerancePaymentAmounts {
                break
            }
            x1 = newFactor
            y1 = myBalance
            
            if myBalance < 0.0 {
                x2 = incrementFactor_BT(aInvestment: tempInvestment, discountRate: yield, x1: x1, y1: y1, iCounter: iCount)
            } else {
                x2 = decrementFactor_BT(aInvestment: tempInvestment, discountRate: yield, x1: x1, y1: y1, iCounter: iCount)
            }
            y2 = getNPVAfterNewFactor_BT(aInvestment: tempInvestment, aFactor: x2, discountRate: yield)
            iCount += 1
        }
        
        
        //Then adjust the payments in the actual investment
        for x in 0..<self.rent.groups.count {
            if self.rent.groups[x].locked == false {
                let newAmount = self.rent.groups[x].amount.toDecimal() * newFactor
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
    
    private func tolerance() -> Decimal {
        let numberOfPayments: Decimal = self.rent.getTotalNoOfBasePayments(aFreq: self.leaseTerm.paymentFrequency, eomRule: self.leaseTerm.endOfMonthRule, interimGroupExists: self.rent.interimExists()).toString().toDecimal()
        let myTolerance = (numberOfPayments / 10.0) * 0.25
        
        return myTolerance
    }
    
}
