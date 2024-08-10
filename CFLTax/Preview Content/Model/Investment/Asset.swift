//
//  Asset.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


public struct Asset {
    public var name: String
    public var fundingDate: Date
    public var lessorCost: String
    public var residualValue: String
    public var lesseeGuarantyAmount: String = "0.00"
    public var thirdPartyGuarantyAmount: String = "0.00"
    
    init(name: String, fundingDate: Date, lessorCost: String, residualValue: String) {
        self.name = name
        self.fundingDate = fundingDate
        self.lessorCost = lessorCost
        self.residualValue = residualValue
    }
    
}
