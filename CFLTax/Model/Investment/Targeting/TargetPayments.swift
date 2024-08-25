//
//  Targeting.swift
//  CFLTax
//
//  Created by Steven Williams on 8/24/24.
//

import Foundation


extension Investment {
//    public func solveForUnlockedPayments(targetYield: Decimal, isAfterTax: Bool) {
//        var yield: Decimal = targetYield
//        if isAfterTax == false {
//            yield = yield * (1.0 - self.taxAssumptions.federalTaxRate.toDecimal())
//        }
//        
//        var x1: Decimal = 1.0
//        var y1: Decimal = afterTaxCashflows.XNPV(aDiscountRate: yield, aDayCountMethod: self.economics.dayCountMethod)
//        
//        let myResult = result(aInvestment: self, aYield: yield, x1: x1, y1: y1)
//        x1 = myResult.x2
//        y1 = myResult.y2
//        
//        for x in 0..<self.rent.groups.count {
//            if self.rent.groups[x].locked == false {
//                if self.rent.groups[x].isCalculatedPaymentType() == false {
//                    let decAmount:Decimal = self.rent.groups[x].amount.toDecimal() * x1
//                    self.rent.groups[x].amount = decAmount.toString()
//                }
//            }
//        }
//    }
//    
//    private func result(aInvestment: Investment, aYield: Decimal, x1: Decimal, y1: Decimal) -> (x2: Decimal, y2: Decimal) {
//        let tempInvestment = aInvestment.clone()
//        var y2:Decimal = y1
//        var x2:Decimal = x1
//        let adjFactor:Decimal = 0.33
//        
//        if y1 < 0.00 {
//            x2 = x2 - (x2 * adjFactor)
//            y2 = getNPVAfterNewFactor(aInvestment: tempInvestment, aYield: aYield, aFactor: x2)
//        } else {
//            x2 = x2 + (x2 * adjFactor)
//            y2 = getNPVAfterNewFactor(aInvestment: tempInvestment, aYield: aYield, aFactor: x2)
//        }
//        
//        let newX: Decimal = mxbFactor(factor1: x1, value1: y1, factor2: x2, value2: y2)
//        let newY:Decimal = getNPVAfterNewFactor(aInvestment: tempInvestment, aYield: aYield, aFactor: newX)
//        
//        return (newX, newY)
//    }
                                                        
   

   //Secant Method
    public func solveForPayments(targetYield: Decimal, isAfterTax: Bool) {
        let tempInvestment: Investment = self.clone()
        var x1: Decimal = 1.0
        var x2 = getInitialSecondGuess(aInvestment: tempInvestment, aTargetYield: targetYield, aFactor: x1)
        var myNPV = getNPVAfterNewFactor(aInvestment: tempInvestment, aYield: targetYield, aFactor: x2)
        
        //adjust the payments in tempInvestment until NPV  = 0
        while abs(myNPV) > toleranceAmounts {
            let x3 = getSecantMethodGuess(aInvestment: tempInvestment, aTargetYield: targetYield, x1: x1, x2: x2)
            myNPV = getNPVAfterNewFactor(aInvestment: tempInvestment, aYield: targetYield, aFactor: x3)
            x1 = x2
            x2 = x3
        }
        //Then adjust the payments in the actual investment
        for x in 0..<self.rent.groups.count {
            if self.rent.groups[x].locked == false {
                let newAmount = self.rent.groups[x].amount.toDecimal() * x2
                self.rent.groups[x].amount = newAmount.toString()
            }
        }
    }
    
    private func getInitialSecondGuess(aInvestment: Investment, aTargetYield: Decimal, aFactor: Decimal) -> Decimal {
        let tempInvestment: Investment = aInvestment.clone()
        var myPV = tempInvestment.afterTaxCashflows.XNPV(aDiscountRate: aTargetYield, aDayCountMethod: aInvestment.economics.dayCountMethod)
        let myFactor: Decimal = aFactor
        
        if myPV > 0.0 {
            while myPV > 0.0 {
                let myFactor = myFactor / 2.0
                    myPV = getNPVAfterNewFactor(aInvestment: tempInvestment, aYield: aTargetYield, aFactor: myFactor)
            }
        } else {
            while myPV < 0.0 {
                let myFactor = myFactor * 2.0
                    myPV = getNPVAfterNewFactor(aInvestment: tempInvestment, aYield: aTargetYield, aFactor: myFactor)
            }
        }
        
        return myFactor
    }
    
    private func getNPVAfterNewFactor(aInvestment: Investment, aYield: Decimal, aFactor: Decimal) -> Decimal {
        let tempInvestment = aInvestment.clone()
                    
         for x in 0..<tempInvestment.rent.groups.count {
             if tempInvestment.rent.groups[x].locked == false {
                 let newAmount: Decimal = tempInvestment.rent.groups[x].amount.toDecimal() * aFactor
                 tempInvestment.rent.groups[x].amount = newAmount.toString()
             }
         }
         
         tempInvestment.calculate()
         let myNPV: Decimal = tempInvestment.afterTaxCashflows.XNPV(aDiscountRate: aYield, aDayCountMethod: aInvestment.economics.dayCountMethod)
         
         return myNPV
    }
    
    private func getSecantMethodGuess(aInvestment: Investment, aTargetYield: Decimal, x1: Decimal, x2: Decimal) -> Decimal {
        let npvX1: Decimal = getNPVAfterNewFactor(aInvestment: aInvestment, aYield: aTargetYield, aFactor: x1)
        let npvX2: Decimal = getNPVAfterNewFactor(aInvestment: aInvestment, aYield: aTargetYield, aFactor: x2)
        
        let x3: Decimal = (x1 * npvX2 - x2 * npvX1) / (npvX2 - npvX1)
        
        return x3
    }
    
    
    
                                                        
}
