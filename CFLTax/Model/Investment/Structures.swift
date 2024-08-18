//
//  Structures.swift
//  CFLTax
//
//  Created by Steven Williams on 8/14/24.
//

import Foundation


extension Rent {
    mutating func firstAndLast(freq: Frequency, baseCommence: Date, EOMRule: Bool) {
      
        
        //Insert Two Duplicate Groups
        let newGroup: Group = self.groups[0].clone()
        self.groups.insert(newGroup, at: 0)
        let newGroup2: Group = groups[1].clone()
        groups.insert(newGroup2, at: 1)
        
        //Get Properties of Group to Change
        let currAmount:Decimal = groups[0].amount.toDecimal()
        let currNoOfPayments: Int = groups[0].noOfPayments
        var currStartDate: Date = groups[0].startDate
        var currEndDate: Date = addOnePeriodToDate(dateStart: currStartDate, payPerYear: freq, dateRefer: baseCommence, bolEOMRule: EOMRule)
       
        //Modify 1st Group
        self.groups[0].amount = (currAmount * 2).toString(decPlaces: 6)
        groups[0].endDate = currEndDate
        groups[0].locked = false
        groups[0].noOfPayments = 1
        groups[0].unDeletable = false
        
        //Modify 2nd Group
        currStartDate = currEndDate
        currEndDate = addPeriodsToDate(dateStart: currStartDate, payPerYear: freq, noOfPeriods: currNoOfPayments - 2, referDate: baseCommence, bolEOMRule: EOMRule)
        groups[1].amount = currAmount.toString(decPlaces: 6)
        groups[1].endDate = currEndDate
        groups[1].locked = false
        groups[1].noOfPayments = currNoOfPayments - 2
        groups[1].startDate = currStartDate
        groups[1].unDeletable = true
        
        //Modify 3rd Group
        currStartDate = currEndDate
        currEndDate = addOnePeriodToDate(dateStart: currStartDate, payPerYear: freq, dateRefer: baseCommence, bolEOMRule: EOMRule)
        groups[2].amount = "0.0"
        groups[2].endDate = currEndDate
        groups[2].locked = false
        groups[2].noOfPayments = 1
        groups[2].startDate = currStartDate
        groups[2].unDeletable = false
        
    }
    
    mutating  func firstAndLastTwo(freq: Frequency, baseCommence: Date, EOMRule: Bool) {
        //Insert Two Duplicate Groups
        let newGroup: Group = groups[0].clone()
        groups.insert(newGroup, at: 0)
        let newGroup2: Group = groups[1].clone()
        groups.insert(newGroup2, at: 1)
        
        //Get Properties of Group to Change
        let currAmount:Decimal = groups[0].amount.toDecimal()
        let currNoOfPayments: Int = groups[0].noOfPayments
        var currStartDate: Date = groups[0].startDate
        var currEndDate: Date = addOnePeriodToDate(dateStart: currStartDate, payPerYear: freq, dateRefer: baseCommence, bolEOMRule: EOMRule)
       
        //Modify 1st Group
        groups[0].amount = (currAmount * 3).toString(decPlaces: 6)
        groups[0].endDate = currEndDate
        groups[0].locked = false
        groups[0].noOfPayments = 1
        groups[0].unDeletable = false
        
        //Modify 2nd Group
        currStartDate = currEndDate
        currEndDate = addPeriodsToDate(dateStart: currStartDate, payPerYear: freq, noOfPeriods: currNoOfPayments - 3, referDate: baseCommence, bolEOMRule: EOMRule)
        groups[1].amount = currAmount.toString(decPlaces: 6)
        groups[1].endDate = currEndDate
        groups[1].locked = false
        groups[1].noOfPayments = currNoOfPayments - 3
        groups[1].startDate = currStartDate
        groups[1].unDeletable = true
        
        //Modify 3rd Group
        currStartDate = currEndDate
        currEndDate = addPeriodsToDate(dateStart: currStartDate, payPerYear: freq, noOfPeriods: 2, referDate: baseCommence, bolEOMRule: EOMRule)
        groups[2].amount = "0.0"
        groups[2].endDate = currEndDate
        groups[2].locked = false
        groups[2].noOfPayments = 2
        groups[2].startDate = currStartDate
        groups[2].unDeletable = false
        
    }
    
    mutating  func unevenPayments(lowHigh: Bool, freq: Frequency, baseCommence: Date, EOMRule: Bool) {
        //Set Payment Adjustment Factors
        var decFactor1: Decimal = 0.9
        var decFactor2: Decimal = 1.1
        if lowHigh == false {
            decFactor1 = 1.1
            decFactor2 = 0.9
        }
        
        //Get Properties of Current Group
        let currNoOfPayments:Int = groups[0].noOfPayments
        var oddNoOfPayments: Bool = false
        let intRemainder: Int = currNoOfPayments % 2
        if intRemainder > 0 {
            oddNoOfPayments = true
        }
        let noOfLevelOne: Int = (currNoOfPayments - intRemainder) / 2
        
        //Insert One Duplicate Group if even Two if Odd
        let newGroup: Group = groups[0].clone()
        groups.insert(newGroup, at: 0)
        if oddNoOfPayments == true {
            let newGroup2 = groups[1].clone()
            groups.insert(newGroup2, at: 1)
        }
        
        //Get Starting Properties and Edit First Group
        let currAmount:Decimal = groups[0].amount.toDecimal()
        var currStartDate: Date = groups[0].startDate
        var currEndDate: Date = addPeriodsToDate(dateStart: currStartDate, payPerYear: freq, noOfPeriods: noOfLevelOne, referDate: baseCommence, bolEOMRule: EOMRule)
        groups[0].amount = (currAmount * decFactor1).toString(decPlaces: 6)
        groups[0].endDate = currEndDate
        groups[0].locked = false
        groups[0].noOfPayments = noOfLevelOne
        groups[0].startDate = currStartDate
        groups[0].unDeletable = true
        
        if oddNoOfPayments == true {
            currStartDate = groups[0].endDate
            currEndDate = addOnePeriodToDate(dateStart: currStartDate, payPerYear: freq, dateRefer: baseCommence, bolEOMRule: EOMRule)
            groups[1].amount = currAmount.toString(decPlaces: 6)
            groups[1].endDate = currEndDate
            groups[1].locked = false
            groups[1].noOfPayments = 1
            groups[1].startDate = currStartDate
            groups[1].unDeletable = false
            
            currStartDate = groups[0].endDate
            currEndDate = addPeriodsToDate(dateStart: currStartDate, payPerYear: freq, noOfPeriods: noOfLevelOne, referDate: baseCommence, bolEOMRule: EOMRule)
            groups[2].amount = (currAmount * decFactor2).toString(decPlaces: 6)
            groups[2].endDate = currEndDate
            groups[2].locked = false
            groups[2].noOfPayments = noOfLevelOne
            groups[2].startDate = currStartDate
            groups[2].unDeletable = false
        } else {
            currStartDate = groups[0].endDate
            currEndDate = addPeriodsToDate(dateStart: currStartDate, payPerYear: freq, noOfPeriods: noOfLevelOne, referDate: baseCommence, bolEOMRule: EOMRule)
            groups[1].amount = (currAmount * decFactor2).toString(decPlaces: 6)
            groups[1].endDate = currEndDate
            groups[1].locked = false
            groups[1].noOfPayments = noOfLevelOne
            groups[1].startDate = currStartDate
            groups[1].unDeletable = false
        }
    }
    
    mutating func escalate(aInvestment: Investment, inflationRate: Decimal, steps: Int) {
        let myInvestment = aInvestment.clone()
        let outerLoops: Int = (myInvestment.getBaseTermInMonths() / steps) / 12
        let innerLoops: Int = myInvestment.leaseTerm.paymentFrequency.rawValue * steps
        
        let decAmount: Decimal = myInvestment.rent.groups[0].amount.toDecimal()
        
        var dateStart: Date = myInvestment.rent.groups[0].startDate
        let aTiming: TimingType = myInvestment.rent.groups[0].timing
        myInvestment.rent.groups.removeAll()
        
        var prevAmount = decAmount
        var undeletable: Bool = false
        for x in 0..<outerLoops{
            var escalator2: Decimal = 1.0 + inflationRate
            if x == 0 {
                escalator2 = 1.0
                undeletable = true
            } else {
                undeletable = false
            }
            let currAmount = prevAmount * escalator2
            let dateEnd = addPeriodsToDate(dateStart: dateStart, payPerYear: myInvestment.leaseTerm.paymentFrequency, noOfPeriods: innerLoops, referDate: myInvestment.leaseTerm.baseCommenceDate, bolEOMRule: myInvestment.leaseTerm.endOfMonthRule)
            let myGroup:Group = Group(
                amount: currAmount.toString(decPlaces: 6),
                endDate: dateEnd,
                locked: false,
                noOfPayments: innerLoops,
                startDate: dateStart,
                timing: aTiming,
                paymentType: .baseRental,
                isInterim: false,
                unDeletable: undeletable)
            myInvestment.rent.groups.append(myGroup)
            dateStart = dateEnd
            prevAmount = currAmount
        }
        groups.removeAll()
        for x in 0..<groups.count {
            groups.append(myInvestment.rent.groups[x])
        }
    }
    
    
    public func structureCanBeApplied(freq: Frequency) -> Bool {
        //must be only one group
        guard groups.count == 1 else {
            return false
        }
        
        //Check Term is equal to or greater than 2 years
        let divisor = Double(freq.rawValue)
        let numerator = Double(groups[0].noOfPayments)
        let term: Double = numerator / divisor
        guard term >= 2.0 else {
            return false
        }
        
        //Check Payment Type of Group is Payments
        guard groups[0].paymentType == .baseRental else {
            return false
        }
        
        return true
    }
    
    
}


