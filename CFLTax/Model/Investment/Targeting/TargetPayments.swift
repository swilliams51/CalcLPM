//
//  Targeting.swift
//  CFLTax
//
//  Created by Steven Williams on 8/24/24.
//

import Foundation


extension Investment {

   //Secant Method
    public func solveForPayments(aYieldMethod: YieldMethod, aTargetYield: Decimal, isAfterTax: Bool) {
        if aYieldMethod == .MISF_AT  || aYieldMethod == .MISF_BT {
            solveForPayments_MISF(aTargetYield: aTargetYield, isAfterTax: isAfterTax)
        } else if aYieldMethod == .IRR_PTCF {
            solveForPayments_IRROfPTCF(aTargetYield: aTargetYield)
        } else {
            //solveForPayments_ImplicitRate(aTargetYield: aTargetYield)
        }
    }

    private func solveForPayments_MISF(aTargetYield: Decimal, isAfterTax: Bool) {
        let tempInvestment: Investment = self.clone()
        tempInvestment.setAfterTaxCashflows()
        var yield: Decimal = aTargetYield
        if isAfterTax == false {
            yield = yield * (1.0 - self.taxAssumptions.federalTaxRate.toDecimal())
        }
        
        let initialNPV: Decimal = tempInvestment.afterTaxCashflows.XNPV(aDiscountRate: yield, aDayCountMethod: self.economics.dayCountMethod)
        if abs(initialNPV) > tolerancePaymentAmounts {
            var x1: Decimal = 1.0
            var x2 = getInitialSecondGuess_MISF(aInvestment: tempInvestment, aTargetYield: yield, aFactor: x1)
            var myNPV = getNPVAfterNewFactor_MISF(aInvestment: tempInvestment, aYield: yield, aFactor: x2)
            var iCounter = 0
            //adjust the payments in tempInvestment until NPV  = 0
            while abs(myNPV) > tolerancePaymentAmounts {
                if iCounter == 4 {
                    break
                }
                let x3 = getSecantMethodGuess_MISF(aInvestment: tempInvestment, aTargetYield: yield, x1: x1, x2: x2)
                myNPV = getNPVAfterNewFactor_MISF(aInvestment: tempInvestment, aYield: yield, aFactor: x3)
                x1 = x2
                x2 = x3
                iCounter += 1
            }
            //Then adjust the payments in the actual investment
            for x in 0..<self.rent.groups.count {
                if self.rent.groups[x].locked == false {
                    let newAmount = self.rent.groups[x].amount.toDecimal() * x2
                    self.rent.groups[x].amount = newAmount.toString()
                }
            }
            tempInvestment.afterTaxCashflows.items.removeAll()
        }
    }
    
    private func getInitialSecondGuess_MISF(aInvestment: Investment, aTargetYield: Decimal, aFactor: Decimal) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        tempInvestment.setAfterTaxCashflows()
        var myPV = tempInvestment.afterTaxCashflows.XNPV(aDiscountRate: aTargetYield, aDayCountMethod: aInvestment.economics.dayCountMethod)
        var myFactor: Decimal = aFactor
        
        if myPV > 0.0 {
            while myPV > 0.0 {
                myFactor = myFactor / 2.0
                myPV = getNPVAfterNewFactor_MISF(aInvestment: tempInvestment, aYield: aTargetYield, aFactor: myFactor)
            }
        } else {
            while myPV < 0.0 {
                myFactor = myFactor * 2.0
                myPV = getNPVAfterNewFactor_MISF(aInvestment: tempInvestment, aYield: aTargetYield, aFactor: myFactor)
            }
        }
        
        return myFactor
    }
    
    private func getNPVAfterNewFactor_MISF(aInvestment: Investment, aYield: Decimal, aFactor: Decimal) -> Decimal {
        let tempInvestment = aInvestment.clone()
                    
         for x in 0..<tempInvestment.rent.groups.count {
             if tempInvestment.rent.groups[x].locked == false {
                 let newAmount: Decimal = tempInvestment.rent.groups[x].amount.toDecimal() * aFactor
                 tempInvestment.rent.groups[x].amount = newAmount.toString()
             }
         }
         
        tempInvestment.setAfterTaxCashflows()
         let myNPV: Decimal = tempInvestment.afterTaxCashflows.XNPV(aDiscountRate: aYield, aDayCountMethod: aInvestment.economics.dayCountMethod)
         
         return myNPV
    }
    
    private func getSecantMethodGuess_MISF(aInvestment: Investment, aTargetYield: Decimal, x1: Decimal, x2: Decimal) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        tempInvestment.setAfterTaxCashflows()
        
        let npvX1: Decimal = getNPVAfterNewFactor_MISF(aInvestment: aInvestment, aYield: aTargetYield, aFactor: x1)
        let npvX2: Decimal = getNPVAfterNewFactor_MISF(aInvestment: aInvestment, aYield: aTargetYield, aFactor: x2)
        
        let x3: Decimal = (x1 * npvX2 - x2 * npvX1) / (npvX2 - npvX1)
        
        return x3
    }
    
    
    
    
    // IRR of PTCF
    private func solveForPayments_IRROfPTCF(aTargetYield: Decimal) {
        let tempInvestment: Investment = self.clone()
        tempInvestment.setBeforeTaxCashflows()
      
        let initialNPV: Decimal = tempInvestment.beforeTaxCashflows.XNPV(aDiscountRate: aTargetYield, aDayCountMethod: self.economics.dayCountMethod)
        if abs(initialNPV) > tolerancePaymentAmounts {
            var x1: Decimal = 1.0
            var x2 = getInitialSecondGuess_IRR(aInvestment: tempInvestment, aTargetYield: aTargetYield, aFactor: x1)
            var myNPV = getNPVAfterNewFactor_IRR(aInvestment: tempInvestment, aYield: aTargetYield, aFactor: x2)
            var iCounter = 0
            //adjust the payments in tempInvestment until NPV  = 0
            while abs(myNPV) > tolerancePaymentAmounts {
                if iCounter == 4 {
                    break
                }
                let x3 = getSecantMethodGuess_IRR(aInvestment: tempInvestment, aTargetYield: aTargetYield, x1: x1, x2: x2)
                myNPV = getNPVAfterNewFactor_IRR(aInvestment: tempInvestment, aYield: aTargetYield, aFactor: x3)
                x1 = x2
                x2 = x3
                iCounter += 1
            }
            //Then adjust the payments in the actual investment
            for x in 0..<self.rent.groups.count {
                if self.rent.groups[x].locked == false {
                    let newAmount = self.rent.groups[x].amount.toDecimal() * x2
                    self.rent.groups[x].amount = newAmount.toString()
                }
            }
            tempInvestment.beforeTaxCashflows.items.removeAll()
        }
    }
    
    private func getInitialSecondGuess_IRR(aInvestment: Investment, aTargetYield: Decimal, aFactor: Decimal) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        tempInvestment.setBeforeTaxCashflows()
        var myPV = tempInvestment.beforeTaxCashflows.XNPV(aDiscountRate: aTargetYield, aDayCountMethod: aInvestment.economics.dayCountMethod)
        var myFactor: Decimal = aFactor
        
        if myPV > 0.0 {
            while myPV > 0.0 {
                myFactor = myFactor / 2.0
                myPV = getNPVAfterNewFactor_IRR(aInvestment: tempInvestment, aYield: aTargetYield, aFactor: myFactor)
            }
        } else {
            while myPV < 0.0 {
                myFactor = myFactor * 2.0
                myPV = getNPVAfterNewFactor_IRR(aInvestment: tempInvestment, aYield: aTargetYield, aFactor: myFactor)
            }
        }
        
        return myFactor
    }
    
    private func getNPVAfterNewFactor_IRR(aInvestment: Investment, aYield: Decimal, aFactor: Decimal) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        
        for x in 0..<tempInvestment.rent.groups.count {
            if tempInvestment.rent.groups[x].locked == false {
                let newAmount: Decimal = tempInvestment.rent.groups[x].amount.toDecimal() * aFactor
                tempInvestment.rent.groups[x].amount = newAmount.toString()
            }
        }
        
       tempInvestment.setBeforeTaxCashflows()
        let myNPV: Decimal = tempInvestment.beforeTaxCashflows.XNPV(aDiscountRate: aYield, aDayCountMethod: aInvestment.economics.dayCountMethod)
        
        return myNPV
    }
    
    private func getSecantMethodGuess_IRR(aInvestment: Investment, aTargetYield: Decimal, x1: Decimal, x2: Decimal) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        
        tempInvestment.setBeforeTaxCashflows()
        
        let npvX1: Decimal = getNPVAfterNewFactor_IRR(aInvestment: aInvestment, aYield: aTargetYield, aFactor: x1)
        let npvX2: Decimal = getNPVAfterNewFactor_IRR(aInvestment: aInvestment, aYield: aTargetYield, aFactor: x2)
        
        let x3: Decimal = (x1 * npvX2 - x2 * npvX1) / (npvX2 - npvX1)
        
        return x3
    }
    
    
    
    
    
    
    private func solveForPayments_ImplicitRate(aTargetYield: Decimal) {
        
    }
    
                                                        
}
