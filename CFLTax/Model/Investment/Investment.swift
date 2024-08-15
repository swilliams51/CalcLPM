//
//  Investment.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


@Observable
public class Investment {
    var asset: Asset = simple2Asset
    var leaseTerm: LeaseTerm = simple2LeaseTerm
    var rent: Rent = simple2Rent
    var depreciation: Depreciation = simpleDepreciation
    var taxAssumptions: TaxAssumptions = simpleTaxAssumptions
    var economics: Economics = simpleEconomics
    var fee: Fee = simpleFee
    var earlyBuyout: EarlyBuyout = eboEx1
    
   public init() {
        self.asset = asset
        self.leaseTerm = leaseTerm
        self.rent = rent
        self.depreciation = depreciation
        self.taxAssumptions = taxAssumptions
        self.economics = economics
        self.fee = fee
        self.earlyBuyout = earlyBuyout
    }
    
    public init(aAsset: Asset, aLeaseTerm: LeaseTerm, aRent: Rent, aDepreciation: Depreciation, aTaxAssumptions: TaxAssumptions, aEconomics: Economics, aFee: Fee, aEarlyBuyout: EarlyBuyout) {
        self.asset = aAsset
        self.leaseTerm = aLeaseTerm
        self.rent = aRent
        self.depreciation = aDepreciation
        self.taxAssumptions = aTaxAssumptions
        self.economics = aEconomics
        self.fee = aFee
        self.earlyBuyout = aEarlyBuyout
        
    }
    
    public func feeExists() -> Bool {
        if fee.amount.toDecimal() != 0.0 {
            return true
        } else {
            return false
        }
    }
    
    public func eboExists() -> Bool {
        if earlyBuyout.amount.toDecimal() != 0.0 {
            return true
        } else {
            return false
        }
    }
    
    
    public func getBaseTermInMonths() -> Int {
        var runTotalPeriods: Int = 0
        
        for x in 0..<rent.groups.count {
            if rent.groups[x].isInterim == false {
                let numberOfPeriods = rent.groups[x].noOfPayments
                runTotalPeriods = runTotalPeriods + numberOfPeriods
            }
        }
        
        return runTotalPeriods * 12 / leaseTerm.paymentFrequency.rawValue
    }
    
    public func getLeaseMaturityDate() -> Date {
         return addPeriodsToDate(dateStart: leaseTerm.baseCommenceDate, payPerYear: .monthly, noOfPeriods: getBaseTermInMonths(), referDate: leaseTerm.baseCommenceDate, bolEOMRule: false)
    }
    
    public func clone() -> Investment {
        let strInvestment = self.writeInvestment()
        let strInvestmentCopy = readInvestment(file: strInvestment)
        
        return strInvestmentCopy
    }
        
    
   
}
