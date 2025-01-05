//
//  AnnualizedRentalCashflows.swift
//  CFLTax
//
//  Created by Steven Williams on 1/3/25.
//

import Foundation


@Observable
public class AnnualizedRentalCashflows: Cashflows {
    public var averageMonthlyRent: Decimal = 0.0
    public var averageAnnualizedRent: Decimal = 0.0
    
    public func createTable(aInvestment: Investment) {
        //Test to compare the average annual rent to each annualized rent
        //If the an annualized rent for any year is < 90% of the average rent or greater than 110% of the average annual rent then the test fails
        //Otherwise it passes
        let referDate: Date = aInvestment.leaseTerm.baseCommenceDate
        let eomRule: Bool = aInvestment.leaseTerm.endOfMonthRule
        let myBaseRentalCashflows: Cashflows = baseRentals(aInvestment: aInvestment)
        let totalRent: Decimal = myBaseRentalCashflows.getTotal()
        let startDate: Date = myBaseRentalCashflows.items[0].dueDate
        var currentYear: Date = addOnePeriodToDate(dateStart: startDate, payPerYear: .annual, dateRefer: referDate, bolEOMRule: eomRule)
        let monthsInLease: Int = monthsDifference(start: startDate, end: aInvestment.getLeaseMaturityDate(), inclusive: true)
        averageMonthlyRent = totalRent / Decimal(monthsInLease)
        averageAnnualizedRent = averageMonthlyRent * Decimal(12)
        var finalYearAdded: Bool = false
        var runTotal: Decimal = 0.0
        var counter: Int = 0
        
        while counter < myBaseRentalCashflows.count() {
            while myBaseRentalCashflows.items[counter].dueDate.isLessThan(date: currentYear) {
                if counter >= myBaseRentalCashflows.count() - 1 {
                   //get Annualized
                    if myBaseRentalCashflows.items[counter].amount.toDecimal() > 0.0 {
                        runTotal = runTotal + myBaseRentalCashflows.items[counter].amount.toDecimal()
                        let monthsToEndOfYear: Int = monthsDifference(start: myBaseRentalCashflows.items[counter].dueDate, end: currentYear , inclusive: false) - 1
                        if monthsToEndOfYear > 0 {
                            let monthlyRental: Decimal = runTotal / (12.0 - Decimal(monthsToEndOfYear))
                            runTotal = monthlyRental * Decimal(12)
                        }
                    }
                    items.append(Cashflow(dueDate: currentYear, amount: runTotal.toString(decPlaces: 3)))
                    counter += 1
                    finalYearAdded = true
                    break
                }
                runTotal = runTotal + myBaseRentalCashflows.items[counter].amount.toDecimal()
                counter += 1
            }
            if finalYearAdded ==  false {
                items.append(Cashflow(dueDate: currentYear, amount: runTotal.toString(decPlaces: 3)))
                currentYear = addOnePeriodToDate(dateStart: currentYear, payPerYear: .annual, dateRefer: referDate, bolEOMRule: eomRule)
                runTotal = 0.0
            }
        }
        
    }
    
    private func baseRentals(aInvestment: Investment) -> Cashflows {
        let aRent: Rent = aInvestment.rent
        let aLeaseTerm: LeaseTerm = aInvestment.leaseTerm
        let eomRule: Bool = aInvestment.leaseTerm.endOfMonthRule
        var dateStart: Date = aLeaseTerm.baseCommenceDate
        var counter: Int = 0
        let myBaseRents: Cashflows = Cashflows()

        if aRent.groups[0].isInterim {
            counter = 1
        }
        
        for x in counter..<aRent.groups.count {
            var y = 0
            if aRent.groups[x].timing == .advance {
                while y < aRent.groups[x].noOfPayments {
                    let myStartCF = Cashflow(dueDate: dateStart, amount: aRent.groups[x].amount)
                    myBaseRents.add(item: myStartCF)
                    dateStart = addOnePeriodToDate(dateStart: dateStart, payPerYear: aLeaseTerm.paymentFrequency, dateRefer: aLeaseTerm.baseCommenceDate, bolEOMRule: eomRule)
                    let myEndCF = Cashflow(dueDate: dateStart, amount: "0.00")
                    myBaseRents.add(item: myEndCF)
                    y += 1
                }
                
            } else {
                while y <= aRent.groups[x].noOfPayments {
                    let myStartCF = Cashflow(dueDate: dateStart, amount: "0.00")
                    myBaseRents.add(item: myStartCF)
                    dateStart = addOnePeriodToDate(dateStart: dateStart, payPerYear: aLeaseTerm.paymentFrequency, dateRefer: aLeaseTerm.baseCommenceDate, bolEOMRule: eomRule)
                    let myEndCf = Cashflow(dueDate: dateStart, amount: aRent.groups[x].amount)
                    myBaseRents.add(item: myEndCf)
                    y += 1
                }
            }
        }
        myBaseRents.consolidateCashflows()
        
        if myBaseRents.items[myBaseRents.count() - 1].amount.toDecimal() == 0 {
            myBaseRents.items.remove(at: myBaseRents.count() - 1)
        }
        
        if myBaseRents.items[0].amount.toDecimal() == 0 {
            myBaseRents.items.remove(at: 0)
        }
        
        return myBaseRents
    }
    
    
    
    
}
