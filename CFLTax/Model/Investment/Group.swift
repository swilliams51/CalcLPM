//
//  Group.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


public struct Group: Identifiable {
    public let id = UUID()
    public var amount: String
    public var endDate: Date
    public var locked: Bool
    public var noOfPayments: Int
    public var startDate: Date
    public var timing: TimingType
    public var paymentType: PaymentType
    public var isInterim: Bool
    public var unDeletable: Bool
    
    public init(amount: String, endDate: Date, locked: Bool, noOfPayments: Int, startDate: Date, timing: TimingType, paymentType: PaymentType, isInterim: Bool, unDeletable: Bool) {
        self.amount = amount
        self.endDate = endDate
        self.locked = locked
        self.noOfPayments = noOfPayments
        self.startDate = startDate
        self.timing = timing
        self.paymentType = paymentType
        self.isInterim = isInterim
        self.unDeletable = unDeletable
    }
    
    init() {
        amount = "18357.37"
        endDate = addPeriodsToDate(dateStart: Date(), payPerYear: .monthly, noOfPeriods: 60, referDate: Date(), bolEOMRule: true)
        locked = false
        noOfPayments = 60
        startDate = Date()
        timing = .arrears
        paymentType = .baseRental
        isInterim = false
        unDeletable = true
    }
    
    func clone() -> Group {
        return Group(amount: amount, endDate: endDate, locked: locked, noOfPayments: noOfPayments, startDate: startDate, timing: timing, paymentType: paymentType, isInterim: isInterim, unDeletable: unDeletable)
    }
    
    
    func isCalculatedPaymentType() -> Bool {
        var bolIsCalcPayment: Bool = false
        
        if self.paymentType == .dailyEquivAll || self.paymentType == .dailyEquivNext {
            bolIsCalcPayment = true
        }
        
        return bolIsCalcPayment
    }
    
}
