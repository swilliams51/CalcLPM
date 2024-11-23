//
//  BaseRentalIncomes.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation

public class BaseRentalIncomes: Cashflows {
    //This is for Base Rentals only, Interim Rentals handled separately
    
    
    public func createTable(aInvestment: Investment) {
        
        let eomRule: Bool = aInvestment.leaseTerm.endOfMonthRule
        let dayCountMethod: DayCountMethod = aInvestment.economics.dayCountMethod
        let fiscalMonEnd: Int = aInvestment.taxAssumptions.fiscalMonthEnd.rawValue
        let frequency: Frequency = aInvestment.leaseTerm.paymentFrequency
        let baseCommence: Date = aInvestment.leaseTerm.baseCommenceDate
        let leaseExpiry: Date = aInvestment.getLeaseMaturityDate()
        let myGroups: [Group] = aInvestment.rent.groups
        var nextFiscalYearEnd: Date = getFiscalYearEnd(askDate: aInvestment.asset.fundingDate, fiscalMonthEnd: fiscalMonEnd)
        let finalFiscalYearEnd: Date = getFiscalYearEnd(askDate: leaseExpiry, fiscalMonthEnd: fiscalMonEnd)
        var dateFrom: Date = aInvestment.rent.groups[0].startDate
        var fiscalIncome: Decimal = 0.0
        var counter: Int = 0
        
        //if base commencement date starts after the First FYE then add 0.00 to Base Rental Incomes
        if aInvestment.rent.groups[0].isInterim == true {
            if aInvestment.rent.groups[0].endDate > nextFiscalYearEnd {
                addToRentalIncomes(aFiscalDate: nextFiscalYearEnd, aFiscalAmount: "0.00")
                counter += 1
                nextFiscalYearEnd = addNextFiscalYearEnd(aDateIn: nextFiscalYearEnd)
                dateFrom = aInvestment.rent.groups[1].startDate
            }
        }
        
        for x in counter..<aInvestment.rent.groups.count {
            if myGroups[x].isInterim == true {
                dateFrom = myGroups[x].endDate
            } else {
                var y: Int = 0
                while y < myGroups[x].noOfPayments {
                    if myGroups[x].timing == .advance { //rents are in advance
                        let dateFromPlusOne: Date = addOnePeriodToDate(dateStart: dateFrom, payPerYear: frequency, dateRefer: dateFrom, bolEOMRule: eomRule)
                        if dateFromPlusOne.isLessThanOrEqualTo(date: nextFiscalYearEnd) {
                            fiscalIncome = fiscalIncome + myGroups[x].amount.toDecimal()
                        } else {
                            fiscalIncome = fiscalIncome + myGroups[x].amount.toDecimal()
                            addToRentalIncomes(aFiscalDate: nextFiscalYearEnd, aFiscalAmount: fiscalIncome.toString(decPlaces: 10))
                            nextFiscalYearEnd = addNextFiscalYearEnd(aDateIn: nextFiscalYearEnd)
                            fiscalIncome = 0
                        }
                    } else {
                        let dateFromPlusOne: Date = addOnePeriodToDate(dateStart: dateFrom, payPerYear: frequency, dateRefer: dateFrom, bolEOMRule: eomRule)
                        if dateFromPlusOne.isLessThanOrEqualTo(date: nextFiscalYearEnd) {
                            fiscalIncome = fiscalIncome + myGroups[x].amount.toDecimal()
                        } else if dateFrom.isLessThanOrEqualTo(date: nextFiscalYearEnd) {
                            let proRataRent:Decimal = getProRataRent(dateStart: dateFrom, dateEnd: nextFiscalYearEnd, rentAmount: myGroups[x].amount.toDecimal(), aFrequency: frequency, baseCommence: baseCommence, aEOMRule: eomRule, aDayCountMethod: dayCountMethod)
                            
                            fiscalIncome = fiscalIncome + proRataRent
                            addToRentalIncomes(aFiscalDate: nextFiscalYearEnd, aFiscalAmount: fiscalIncome.toString(decPlaces: 10) )
                            let proRataStart: Decimal = abs(myGroups[x].amount.toDecimal() - proRataRent)
                            nextFiscalYearEnd = addNextFiscalYearEnd(aDateIn: nextFiscalYearEnd)
                            fiscalIncome = proRataStart
                        }
                    }
                    dateFrom = addOnePeriodToDate(dateStart: dateFrom, payPerYear: frequency, dateRefer: dateFrom, bolEOMRule: eomRule)
                    y += 1
                }
            }
        }
        
        addToRentalIncomes(aFiscalDate: finalFiscalYearEnd, aFiscalAmount: fiscalIncome.toString(decPlaces: 4))
    }
    
    private func addToRentalIncomes(aFiscalDate: Date, aFiscalAmount: String) {
        let rentIncome = Cashflow(dueDate: aFiscalDate, amount: aFiscalAmount)
        items.append(rentIncome)
    }
    
    private func getProRataRent(dateStart: Date, dateEnd: Date, rentAmount: Decimal, aFrequency: Frequency, baseCommence: Date, aEOMRule: Bool, aDayCountMethod: DayCountMethod) -> Decimal {
        
        let dateEndFullPeriod: Date = addOnePeriodToDate(dateStart: dateStart, payPerYear: aFrequency, dateRefer: baseCommence, bolEOMRule: aEOMRule)
        let daysInFullPeriod = dayCount(aDate1: dateStart, aDate2: dateEndFullPeriod, aDayCount: aDayCountMethod)
        let daysInPartialPeriod = dayCount(aDate1: dateStart, aDate2: dateEnd, aDayCount: .actualActual)
        let ratio: Decimal = Decimal(daysInPartialPeriod) / Decimal(daysInFullPeriod)
        let proRataRent: Decimal = rentAmount * ratio
        
        
        return proRataRent
    }
}
