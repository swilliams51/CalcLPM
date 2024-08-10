//
//  Economics.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


public struct Economics {
    public var yieldMethod: YieldType
    public var yieldTarget: String
    public var solveFor: SolveForOption
    public var dayCountMethod: DayCountMethod
    public var discountRateForRent: String
    public var sinkingFundDate: String = "0.00"
   
    init(yieldMethod: YieldType, yieldTarget: String, solveFor: SolveForOption, dayCountMethod: DayCountMethod, discountRateForRent: String) {
        self.yieldMethod = yieldMethod
        self.yieldTarget = yieldTarget
        self.solveFor = solveFor
        self.dayCountMethod = dayCountMethod
        self.discountRateForRent = discountRateForRent
    }
}
