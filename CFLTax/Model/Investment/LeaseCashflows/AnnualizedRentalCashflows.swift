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
    public var maxAnnualizedRent: Decimal = 0.0
    public var minAnnualizedRent: Decimal = 0.0
    
    fileprivate func getLastAnnualizedRent(_ myBaseRentalCashflows: Cashflows, _ counter: Int, _ currentYear: Date, _ runTotal: inout Decimal) {
        //This section extrapolates the annualized rent based upon the final rental payment
        
        var monthsToEndOfYear: Int = monthsDifference(start: myBaseRentalCashflows.items[counter].dueDate, end: currentYear , inclusive: false)
        runTotal = runTotal + myBaseRentalCashflows.items[counter].amount.toDecimal()
        if myBaseRentalCashflows.items[counter].amount.toDecimal() == 0.0 {
            monthsToEndOfYear += 1
        }
        if monthsToEndOfYear > 0 {
            let monthlyRent = runTotal / (12 - Decimal(monthsToEndOfYear))
            runTotal = monthlyRent * 12
        }
    }
    
    public func createTable(aInvestment: Investment) {
        //Test to compare the average annual rent to each annualized rent
        //If the an annualized rent for any year is < 90% of the average rent or greater than 110% of the average annual rent then the test fails
        //Otherwise it passes
        let referDate: Date = aInvestment.leaseTerm.baseCommenceDate
        let eomRule: Bool = aInvestment.leaseTerm.endOfMonthRule
        let myBaseRentalCashflows: Cashflows = baseRentals(aInvestment: aInvestment)
        let totalRent: Decimal = myBaseRentalCashflows.getTotal()
        //If arrears
        var startDate: Date = myBaseRentalCashflows.items[0].dueDate
        if myBaseRentalCashflows.items[0].amount.toDecimal() > 0.0 {
            startDate = subtractOnePeriodFromDate(dateStart: startDate, payperYear: .monthly, dateRefer: referDate, bolEOMRule: eomRule)
        }
        
        var currentYear: Date = startDate
        let monthsInLease: Int = aInvestment.getBaseTermInMonths()
        averageMonthlyRent = totalRent / Decimal(monthsInLease)
        setMaxMinRents()
        var finalYearAdded: Bool = false
        var runTotal: Decimal = 0.0
        var counter: Int = 0
        
        while counter < myBaseRentalCashflows.count() {
            while myBaseRentalCashflows.items[counter].dueDate.isLessThanOrEqualTo(date: currentYear) {
                if counter >= myBaseRentalCashflows.count() - 1 {
                    getLastAnnualizedRent(myBaseRentalCashflows, counter, currentYear, &runTotal)
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
    
    public func runUnevenRentTest() -> Bool {
        var testResult: Bool = true
        
        for x in 0..<items.count {
            if items[x].amount.toDecimal() > 0 {
                if items[x].amount.toDecimal() > maxAnnualizedRent || items[x].amount.toDecimal() < minAnnualizedRent {
                    testResult = false
                    break
                }
            }
        }
        
        return testResult
    }
    
    private func setMaxMinRents () {
        averageAnnualizedRent = averageMonthlyRent * Decimal(12)
        maxAnnualizedRent = averageAnnualizedRent * Decimal(1.1)
        minAnnualizedRent = averageAnnualizedRent * Decimal(0.9)
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
            while y < aRent.groups[x].noOfPayments {
                if aRent.groups[x].timing == .advance {
                    //base rent in advance
                    let myStartCF = Cashflow(dueDate: dateStart, amount: aRent.groups[x].amount)
                    myBaseRents.add(item: myStartCF)
                    dateStart = addOnePeriodToDate(dateStart: dateStart, payPerYear: aLeaseTerm.paymentFrequency, dateRefer: aLeaseTerm.baseCommenceDate, bolEOMRule: eomRule)
                    let myEndCF = Cashflow(dueDate: dateStart, amount: "0.00")
                    myBaseRents.add(item: myEndCF)
                } else {
                    //base rent in arrears
                    let myStartCF = Cashflow(dueDate: dateStart, amount: "0.00")
                    myBaseRents.add(item: myStartCF)
                    dateStart = addOnePeriodToDate(dateStart: dateStart, payPerYear: aLeaseTerm.paymentFrequency, dateRefer: aLeaseTerm.baseCommenceDate, bolEOMRule: eomRule)
                    let myEndCF = Cashflow(dueDate: dateStart, amount: aRent.groups[x].amount)
                    myBaseRents.add(item: myEndCF)
                }
                y += 1
            }
        }
        myBaseRents.consolidateCashflows()
        
        return myBaseRents
    }
    
    
   
    
    
    
}
