//
//  Amortizations.swift
//  CFLTax
//
//  Created by Steven Williams on 9/11/24.
//

import Foundation


public struct Amortization: Identifiable {
    public let id = UUID()
    public let dueDate: Date
    public let endBalance: Decimal
    public let interest: Decimal
    public let cashflow: Decimal
    public let principal: Decimal
    
    public init(dueDate: Date, endBalance: Decimal, interest: Decimal, cashflow: Decimal, principal: Decimal) {
        self.dueDate = dueDate
        self.endBalance = endBalance
        self.interest = interest
        self.cashflow = cashflow
        self.principal = principal
    }
}

@Observable
public class Amortizations {
    public var items: [Amortization]
    
    public init () {
        self.items = [Amortization]()
    }
    
    public func createAmortizations (investCashflows: Cashflows, interestRate: Decimal, dayCountMethod: DayCountMethod) {
        // handle initial cashflow
        var currentDate = investCashflows.items[0].dueDate
        var cf: Decimal = investCashflows.items[0].amount.toDecimal()
        var accruedInterest: Decimal = 0.0
        var principalPaid: Decimal = cf - accruedInterest
        var endingBalance: Decimal = 0.0 - principalPaid
        
        let startAmortization:Amortization = Amortization(dueDate: currentDate, endBalance: endingBalance, interest: accruedInterest, cashflow: cf, principal: principalPaid)
        self.items.append(startAmortization)
        
        //handle remaining cashflows
        for x in 1..<investCashflows.items.count {
            currentDate = investCashflows.items[x].dueDate
            cf = investCashflows.items[x].amount.toDecimal()
            
            if self.items[x - 1].endBalance < 0.0 { //amortization in sinking fund phase
                accruedInterest = 0.0
            } else {
                accruedInterest = periodicInterest(currentBalance: self.items[x - 1].endBalance, startDate: self.items[x - 1].dueDate, endDate: currentDate, interestRate: interestRate, aDayCount: dayCountMethod)
            }
            principalPaid = cf - accruedInterest
            endingBalance = self.items[x - 1].endBalance - principalPaid
            
            let currentAmortization: Amortization = Amortization(dueDate: currentDate, endBalance: endingBalance, interest: accruedInterest, cashflow: cf, principal: principalPaid)
            items.append(currentAmortization)
        }
        
    }
    
    public func periodicInterest(currentBalance: Decimal, startDate: Date, endDate: Date, interestRate: Decimal, aDayCount: DayCountMethod) -> Decimal {
        let days: Int = dayCount(aDate1: startDate, aDate2: endDate, aDayCount: aDayCount)
        let daysInYear = daysInYear(aDate1: startDate, aDate2: endDate, aDayCountMethod: aDayCount)
        let interest: Decimal = currentBalance * interestRate * Decimal(days) / Decimal(daysInYear)
        
        return interest
    }
  
    
    public func getEndingBalance() -> Decimal {
        return items.last!.endBalance
    }
    
    public func getTotalPrincipalPaid() -> Decimal {
        var runTotal: Decimal = 0.0
        
        for x in 1..<items.count {
            let principal: Decimal = items[x].principal
            runTotal = runTotal + principal
        }
        
        return runTotal
    }
    
    public func getTotalInterest() -> Decimal {
        var runTotal: Decimal = 0.0
        
        for x in 1..<items.count {
            let interest: Decimal = items[x].interest
            runTotal = runTotal + interest
        }
        
        return runTotal
    }
}
