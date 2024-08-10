//
//  RentalCashflows.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


@Observable
public class RentalCashflows: Cashflows {
    
    public func createTable(aRent: Rent, aLeaseTerm: LeaseTerm, aAsset: Asset, eomRule: Bool) {
        var dateStart: Date = aLeaseTerm.baseCommenceDate
        var counter: Int = 0
        
        if aAsset.fundingDate != aLeaseTerm.baseCommenceDate {
            dateStart = aAsset.fundingDate
            if aRent.groups[0].timing == .arrears {
                let myStartCF = Cashflow(dueDate: dateStart, amount: "0.00")
                items.append(myStartCF)
                dateStart = aLeaseTerm.baseCommenceDate
                let myEndCF = Cashflow(dueDate: dateStart, amount: aRent.groups[0].amount)
                items.append(myEndCF)
            } else {
                let myStartCF = Cashflow(dueDate: dateStart, amount: aRent.groups[0].amount)
                items.append(myStartCF)
                dateStart = aLeaseTerm.baseCommenceDate
                let myEndCF = Cashflow(dueDate: dateStart, amount: "0.00")
                items.append(myEndCF)
            }
            counter += 1
        }
       
        for x in counter..<aRent.groups.count {
            var y = 0
            while y < aRent.groups[x].noOfPayments {
                if aRent.groups[x].timing == .advance {
                    let myCF = Cashflow(dueDate: dateStart, amount: aRent.groups[x].amount)
                    items.append(myCF)
                    dateStart = addOnePeriodToDate(dateStart: dateStart, payPerYear: aLeaseTerm.paymentFrequency, dateRefer: aLeaseTerm.baseCommenceDate, bolEOMRule: eomRule)
                } else {
                    dateStart = addOnePeriodToDate(dateStart: dateStart, payPerYear: aLeaseTerm.paymentFrequency, dateRefer: aLeaseTerm.baseCommenceDate, bolEOMRule: eomRule)
                    let myCf = Cashflow(dueDate: dateStart, amount: aRent.groups[x].amount)
                    items.append(myCf)
                }
                y += 1
            }
        }
        
      
    }
}
