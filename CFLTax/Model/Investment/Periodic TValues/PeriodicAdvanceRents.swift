//
//  PeriodicAdvanceRents.swift
//  CFLTax
//
//  Created by Steven Williams on 9/14/24.
//

import Foundation

@Observable
public class PeriodicAdvanceRents: Cashflows {
    
    public func createTable(aInvestment: Investment) {
        
        let aRent: Rent = aInvestment.rent
        let aLeaseTerm: LeaseTerm = aInvestment.leaseTerm
        let aAsset: Asset = aInvestment.asset
        let eomRule: Bool = aInvestment.leaseTerm.endOfMonthRule
        var dateStart: Date = aLeaseTerm.baseCommenceDate
        var counter: Int = 0
        var rentAmount: String = "0.00"
        
        //Interim Rent
        if aAsset.fundingDate != aLeaseTerm.baseCommenceDate {
            dateStart = aAsset.fundingDate
            switch aRent.groups[0].paymentType {
                case .dailyEquivAll:
                    rentAmount = getDailyRentForAll(aRent: aRent, aFreq: aLeaseTerm.paymentFrequency).toString(decPlaces: 4)
                case .dailyEquivNext:
                    rentAmount = getDailyRentForNext(aRent: aRent, aFreq: aLeaseTerm.paymentFrequency).toString(decPlaces: 4)
                default :
                    rentAmount = aRent.groups[0].amount
            }
            // Interim in arrears
            if aRent.groups[0].timing == .advance {
                // interim in advance
                let myStartCF = Cashflow(dueDate: dateStart, amount: rentAmount)
                items.append(myStartCF)
                dateStart = aLeaseTerm.baseCommenceDate
                let myEndCF = Cashflow(dueDate: dateStart, amount: "0.00")
                items.append(myEndCF)
            } else {
                let myStartCF = Cashflow(dueDate: dateStart, amount: "0.00")
                items.append(myStartCF)
                dateStart = aLeaseTerm.baseCommenceDate
                let myEndCF = Cashflow(dueDate: dateStart, amount: "0.00")
                items.append(myEndCF)
            }
            counter += 1
        }
        
       //Base Rent
        for x in counter..<aRent.groups.count {
            var y = 0
            while y < aRent.groups[x].noOfPayments {
                if aRent.groups[x].timing == .advance {
                    //base rent in advance
                    let myStartCF = Cashflow(dueDate: dateStart, amount: aRent.groups[x].amount)
                    self.items.append(myStartCF)
                    dateStart = addOnePeriodToDate(dateStart: dateStart, payPerYear: aLeaseTerm.paymentFrequency, dateRefer: aLeaseTerm.baseCommenceDate, bolEOMRule: eomRule)
                    let myEndCF = Cashflow(dueDate: dateStart, amount: "0.00")
                    self.items.append(myEndCF)
                } else {
                    //base rent in arrears
                    let myStartCF = Cashflow(dueDate: dateStart, amount: "0.00")
                    self.items.append(myStartCF)
                    dateStart = addOnePeriodToDate(dateStart: dateStart, payPerYear: aLeaseTerm.paymentFrequency, dateRefer: aLeaseTerm.baseCommenceDate, bolEOMRule: eomRule)
                    let myEndCf = Cashflow(dueDate: dateStart, amount: "0.00")
                    items.append(myEndCf)
                }
                y += 1
            }
        }
        
        self.consolidateCashflows()
        
    }
    
    
}
