//
//  Rent.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


public struct Rent {
    public var groups: [Group]
    
    init(groups: [Group]) {
        self.groups = groups
    }
    
    public func getTotalNumberOfPayments() -> Int {
        var runTotalPayments: Int = 0
        
        for x in 0..<groups.count {
            runTotalPayments = runTotalPayments + groups[x].noOfPayments
        }
        
        return runTotalPayments
    }

    public func getTotalAmountOfPayments(aFreq: Frequency) -> Decimal {
        var runTotalAmount: Decimal = 0.00
        var amount:Decimal = 0.0
        var counter:Int = 0
        
        if groups[0].isInterim == true {
            if groups[0].amount == "CALCULATED" {
                if groups[0].paymentType == .dailyEquivAll {
                    amount = getDailyRentForAll(aRent: self, aFreq: aFreq)
                } else {
                    amount = getDailyRentForNext(aRent: self, aFreq: aFreq)
                }
            } else {
                amount = groups[0].amount.toDecimal()
            }
            runTotalAmount = runTotalAmount + amount
            counter += 1
        }
        
        for x in counter..<groups.count {
            amount = groups[x].amount.toDecimal() * Decimal(groups[x].noOfPayments)
            runTotalAmount = runTotalAmount + amount
        }
          
        return runTotalAmount
    }
    
    
}


public func getDailyRentForNext(aRent: Rent, aFreq: Frequency) -> Decimal {
    let nextAmount:Decimal = aRent.groups[1].amount.toDecimal()
    let daysInPeriod: Decimal = 360.0 / Decimal(aFreq.rawValue)
    
    return nextAmount / daysInPeriod
}

public func getDailyRentForAll (aRent: Rent, aFreq: Frequency) -> Decimal {
    var runTotalAmount: Decimal = 0.00
    var runTotalNumber: Decimal = 0.00
    
    for x in 0..<aRent.groups.count {
        if aRent.groups[x].paymentType == .baseRental {
            let decAmount = aRent.groups[x].amount.toDecimal()
            let decNumber = Decimal(aRent.groups[x].noOfPayments)
            let totalAmount = decAmount * decNumber
            runTotalAmount = runTotalAmount + totalAmount
            runTotalNumber = runTotalNumber + decNumber
        }
    }
    let average: Decimal = safeDivision(aNumerator: runTotalAmount, aDenominator: runTotalNumber)
    let daysInPeriod: Decimal = 360.0 / Decimal(aFreq.rawValue)
    
    return average / daysInPeriod
}
