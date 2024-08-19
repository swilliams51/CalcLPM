//
//  Resets.swift
//  CFLTax
//
//  Created by Steven Williams on 8/10/24.
//

import Foundation


extension Investment {
    // Mark - Date Resets
    func resetForBaseTermCommenceDateChange() {
        if self.rent.groups[0].isInterim == true {
            if self.leaseTerm.baseCommenceDate == self.asset.fundingDate {
                self.rent.groups.remove(at: 0)
                resetFirstGroup(isInterim: false)
            } else {
                resetFirstGroup(isInterim: true)
            }
        } else {
            if self.leaseTerm.baseCommenceDate == self.asset.fundingDate {
                resetFirstGroup(isInterim: false)
            } else {
                let newGroup = Group(amount: "CALCULATED", endDate: self.leaseTerm.baseCommenceDate, locked: true, noOfPayments: 1, startDate: self.asset.fundingDate, timing: TimingType.arrears, paymentType: .dailyEquivNext, isInterim: true, unDeletable: true)
                self.rent.groups.insert(newGroup, at: 0)
                resetFirstGroup(isInterim: true)
            }
        }
    }
    
    func resetForFundingDateChange() {
        self.leaseTerm.baseCommenceDate = self.asset.fundingDate

        if self.rent.groups[0].isInterim {
            self.rent.groups.remove(at: 0)
        }
        resetFirstGroup(isInterim: false)
    }
    
    //Mark - Frequency Resets
    func resetForFrequencyChange() {
        var bolInterimExists: Bool = true
        if self.leaseTerm.baseCommenceDate == self.asset.fundingDate {
            bolInterimExists = false
        }
        
        for x in 0..<self.rent.groups.count {
            let groupTermInMons: Decimal = Decimal(monthsDiff(start: self.rent.groups[x].startDate, end: self.rent.groups[x].endDate))
            var newNoOfPayments: Decimal = 1.0
            
            if self.rent.groups[x].isInterim == false {
                switch self.leaseTerm.paymentFrequency {
                case .monthly:
                    newNoOfPayments = groupTermInMons
                case .quarterly:
                    newNoOfPayments = groupTermInMons / 3
                case .semiannual:
                    newNoOfPayments = groupTermInMons / 6
                case .annual:
                    newNoOfPayments = groupTermInMons / 12
                }
            }
            self.rent.groups[x].noOfPayments = newNoOfPayments.toInteger()
        }

        resetFirstGroup(isInterim: bolInterimExists)
    }
    
    //Mark - Group Resets
    func copyGroup(aGroup: Group, item: Int) {
        self.rent.groups[item].amount = aGroup.amount
        self.rent.groups[item].endDate = aGroup.endDate
        self.rent.groups[item].locked = aGroup.locked
        self.rent.groups[item].noOfPayments = aGroup.noOfPayments
        self.rent.groups[item].startDate = aGroup.startDate
        self.rent.groups[item].timing = aGroup.timing
        self.rent.groups[item].paymentType = aGroup.paymentType
    }
    
    func resetFirstGroup(isInterim: Bool) {
        if isInterim == true {
            self.rent.groups[0].startDate = self.asset.fundingDate
            self.rent.groups[0].endDate = self.leaseTerm.baseCommenceDate
        } else {
            if self.rent.groups[0].noOfPayments > 1 {
                self.rent.groups[0].startDate = self.asset.fundingDate
                self.rent.groups[0].endDate = addPeriodsToDate(dateStart: self.asset.fundingDate, payPerYear: self.leaseTerm.paymentFrequency, noOfPeriods: self.rent.groups[0].noOfPayments, referDate: self.asset.fundingDate, bolEOMRule: self.leaseTerm.endOfMonthRule)
            } else {
                self.rent.groups[0].startDate = self.asset.fundingDate
                self.rent.groups[0].endDate = addOnePeriodToDate(dateStart: self.asset.fundingDate, payPerYear: self.leaseTerm.paymentFrequency, dateRefer: self.asset.fundingDate, bolEOMRule: self.leaseTerm.endOfMonthRule)
            }
        }
        if self.rent.groups.count > 1 {
            resetRemainderOfGroups(startGrp: 1)
        }
    }
    
    
    func resetRemainderOfGroups(startGrp: Int) {
        var x: Int = startGrp
        
        while x < self.rent.groups.count {
            let lastEndDate: Date = self.rent.groups[x - 1].endDate
            self.rent.groups[x].startDate = lastEndDate
            let dateEnd: Date = addPeriodsToDate(dateStart: lastEndDate, payPerYear: self.leaseTerm.paymentFrequency, noOfPeriods: self.rent.groups[x].noOfPayments, referDate: self.leaseTerm.baseCommenceDate, bolEOMRule: self.leaseTerm.endOfMonthRule)
            self.rent.groups[x].endDate = dateEnd
            x = x + 1
        }
    }
    
    func resetToDefault() {
        self.asset = simple2Asset
        self.leaseTerm = simple2LeaseTerm
        self.rent = simple2Rent
        self.depreciation = simpleDepreciation
        self.taxAssumptions = simpleTaxAssumptions
        self.economics = simpleEconomics
        self.fee = simpleFee
        self.earlyBuyout = eboEx1
    }
    
}
