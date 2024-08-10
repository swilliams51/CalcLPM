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
    
}
