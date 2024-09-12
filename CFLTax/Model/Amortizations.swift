//
//  Amortizations.swift
//  CFLTax
//
//  Created by Steven Williams on 9/11/24.
//

import Foundation


public struct Amortization: Identifiable {
    public let id = UUID()
    let beginDate: Date
    let balance: Decimal
    let days: Int
    let interest: Decimal
    let principal: Decimal
    
    init(beginDate: Date, balance: Decimal, days: Int, interest: Decimal, principal: Decimal) {
        self.beginDate = beginDate
        self.balance = balance
        self.days = days
        self.interest = interest
        self.principal = principal
    }
}

public struct Amortizations {
    public var items: [Amortization]
    
    public init () {
        self.items = [Amortization]()
    }
    
    public mutating func createAmortizations (investCashflows: Cashflows, interestRate: Decimal, dayCountMethod: DayCountMethod) {
        var investmentFound: Bool = false
        let startDate = investCashflows.items[0].dueDate
        var startBalance: Decimal = investCashflows.items[0].amount.toDecimal()
        if investCashflows.items[0].amount.toDecimal() < 0.0 {
            investmentFound = true
        }
        startBalance = startBalance * -1.0
        
        let startDays: Int = 0
        let startInterest: Decimal = 0.0
        let startPrincipal: Decimal = 0.0
        
        let startAmortization:Amortization = Amortization(beginDate: startDate, balance: startBalance, days: startDays, interest: startInterest, principal: startPrincipal)
        self.items.append(startAmortization)
        
        for x in 1..<investCashflows.items.count {
            var cashflow: Decimal = investCashflows.items[x].amount.toDecimal()
            if investmentFound == false {
                if cashflow < 0.0 {
                    cashflow = cashflow * -1.0
                    investmentFound = true
                }
            }
            let currentDate: Date = investCashflows.items[x].dueDate
            let currentBalance: Decimal = items[x - 1].balance
            let days: Int = dayCount(aDate1: items[x - 1].beginDate, aDate2: currentDate, aDayCount: dayCountMethod)
            let daysInYear = daysInYear(aDate1: startDate, aDate2: currentDate, aDayCountMethod: dayCountMethod)
            let interest: Decimal = currentBalance * interestRate * Decimal(days) / Decimal(daysInYear)
           
            let principal: Decimal = cashflow - interest
            var endBalance: Decimal = currentBalance - principal
            if currentBalance < 0.0 {
                endBalance = principal + currentBalance
            }
            
            let currentAmortization: Amortization = Amortization(beginDate: currentDate, balance: endBalance, days: days, interest: interest, principal: principal)
            items.append(currentAmortization)
        }
        
    }
  
    
    public func getEndingBalance() -> Decimal {
        return items.last!.balance
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
