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
        self.fee.datePaid = self.asset.fundingDate
        resetFirstGroup(isInterim: false)
    }
    
    //Mark - Frequency Resets
    func resetForFrequencyChange(oldFrequently: Frequency) {
        var start = 0
        var bolInterimExists: Bool = false
        if self.rent.groups[0].isInterim {
            bolInterimExists = true
            start = 1
        }
        
        
        for x in start..<self.rent.groups.count {
            let groupTermInMons: Decimal = Decimal(monthsDiff(start: self.rent.groups[x].startDate, end: self.rent.groups[x].endDate))
            var newNoOfPayments: Decimal = 1.0
            var myAmount:Decimal = self.rent.groups[x].amount.toDecimal()
                switch self.leaseTerm.paymentFrequency {
                case .monthly:
                    newNoOfPayments = groupTermInMons
                    switch oldFrequently {
                    case .quarterly:
                        myAmount = myAmount / 3.0
                    case .semiannual:
                        myAmount = myAmount / 6.0
                    case .annual:
                        myAmount = myAmount / 12.0
                    default:
                        break
                    }
                case .quarterly:
                    newNoOfPayments = groupTermInMons / 3
                    switch oldFrequently {
                    case .monthly:
                        myAmount = myAmount * 3.0
                    case .semiannual:
                        myAmount = myAmount / 2.0
                    case .annual:
                        myAmount = myAmount / 4.0
                    default:
                        break
                    }
                case .semiannual:
                    newNoOfPayments = groupTermInMons / 6
                    switch oldFrequently {
                    case .monthly:
                        myAmount = myAmount * 6.0
                    case .quarterly:
                        myAmount = myAmount * 2.0
                    case .annual:
                        myAmount = myAmount / 2.0
                    default:
                        break
                    }
                case .annual:
                    newNoOfPayments = groupTermInMons / 12
                    switch oldFrequently {
                    case .monthly:
                        myAmount = myAmount * 12.0
                    case .quarterly:
                        myAmount = myAmount * 4.0
                    case .semiannual:
                        myAmount = myAmount * 2.0
                    default :
                        break
                    }
                }
            self.rent.groups[x].noOfPayments = newNoOfPayments.toInteger()
            self.rent.groups[x].amount = myAmount.toString(decPlaces: 4)
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
        let arrayInvestment: [String] = sampleFile.components(separatedBy: "*")
        
        self.asset = readAsset(arrayAsset:  arrayInvestment[0].components(separatedBy: ","))
        self.leaseTerm = readLeaseTerm(arrayLeaseTerm: arrayInvestment[1].components(separatedBy: ","))
        self.rent = readRent(arrayGroups: arrayInvestment[2].components(separatedBy: "|"))
        self.depreciation = readDepreciation(arrayDepreciation: arrayInvestment[3].components(separatedBy: ","))
        self.taxAssumptions = readTaxAssumptions(arrayTaxAssumptions: arrayInvestment[4].components(separatedBy: ","))
        self.economics = readEconomics(arrayEconomics: arrayInvestment[5].components(separatedBy: ","))
        self.fee = readFee(arrayFee: arrayInvestment[6].components(separatedBy: ","))
        self.earlyBuyout = readEarlyBuyout(arrayEBO: arrayInvestment[7].components(separatedBy: ","))
    }
    
    func resetToFileData(strFile: String) {
        let arrayInvestment: [String] = strFile.components(separatedBy: "*")
        
        let myAsset: Asset = readAsset(arrayAsset:  arrayInvestment[0].components(separatedBy: ","))
        let myLeaseTerm: LeaseTerm = readLeaseTerm(arrayLeaseTerm: arrayInvestment[1].components(separatedBy: ","))
        let myRent: Rent = readRent(arrayGroups: arrayInvestment[2].components(separatedBy: "|"))
        let myDepreciation: Depreciation = readDepreciation(arrayDepreciation: arrayInvestment[3].components(separatedBy: ","))
        let myTaxAssumptions: TaxAssumptions = readTaxAssumptions(arrayTaxAssumptions: arrayInvestment[4].components(separatedBy: ","))
        let myEconomics: Economics = readEconomics(arrayEconomics: arrayInvestment[5].components(separatedBy: ","))
        let myFee: Fee = readFee(arrayFee: arrayInvestment[6].components(separatedBy: ","))
        let myEBO: EarlyBuyout = readEarlyBuyout(arrayEBO: arrayInvestment[7].components(separatedBy: ","))
        
        
        
        self.asset = myAsset
        self.leaseTerm = myLeaseTerm
        self.rent = myRent
        self.depreciation = myDepreciation
        self.taxAssumptions = myTaxAssumptions
        self.economics = myEconomics
        self.fee = myFee
        self.earlyBuyout = myEBO
        
    }
    
}
