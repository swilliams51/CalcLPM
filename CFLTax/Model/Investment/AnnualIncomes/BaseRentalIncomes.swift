//
//  BaseRentalIncomes.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation

public class BaseRentalIncomes: Cashflows {
    //This is for Base Rentals only, Interim Rentals handled separately
    public func createTable(aRent: Rent, aFundingDate: Date,aBaseCommence: Date, aFrequency: Frequency, aFiscalMonthEnd: TaxYearEnd, aLeaseExpiry: Date, aEOMRule: Bool, aDayCountMethod: DayCountMethod) {
        
        let eomRule: Bool = aEOMRule
        let dayCountMethod: DayCountMethod = aDayCountMethod
        var nextFiscalYearEnd: Date = getFiscalYearEnd(askDate: aFundingDate, fiscalMonthEnd: aFiscalMonthEnd.rawValue)
        let finalFiscalYearEnd: Date = getFiscalYearEnd(askDate: aLeaseExpiry, fiscalMonthEnd: aFiscalMonthEnd.rawValue)
        var dateFrom: Date = aRent.groups[0].startDate
        var fiscalIncome: Decimal = 0.0
        var counter: Int = 0
        
        //if base commencement date starts after the First FYE then add 0.00 to Base Rental Incomes
        if aRent.groups[0].isInterim == true {
            if aRent.groups[0].endDate > nextFiscalYearEnd {
                addToRentalIncomes(aFiscalDate: nextFiscalYearEnd, aFiscalAmount: "0.00")
                counter += 1
                nextFiscalYearEnd = addNextFiscalYearEnd(aDateIn: nextFiscalYearEnd)
                dateFrom = aRent.groups[1].startDate
            }
        }
        
        for x in counter..<aRent.groups.count {
            if aRent.groups[x].isInterim == true {
                dateFrom = aRent.groups[x].endDate
            } else {
                var y: Int = 0
                while y < aRent.groups[x].noOfPayments {
                    if aRent.groups[x].timing == .advance { //rents are in advance
                        let dateFromPlusOne: Date = addOnePeriodToDate(dateStart: dateFrom, payPerYear: aFrequency, dateRefer: dateFrom, bolEOMRule: eomRule)
                        if dateFromPlusOne <= nextFiscalYearEnd {
                            fiscalIncome = fiscalIncome + aRent.groups[x].amount.toDecimal()
                        } else {
                            fiscalIncome = fiscalIncome + aRent.groups[x].amount.toDecimal()
                            addToRentalIncomes(aFiscalDate: nextFiscalYearEnd, aFiscalAmount: fiscalIncome.toString(decPlaces: 10))
                            nextFiscalYearEnd = addNextFiscalYearEnd(aDateIn: nextFiscalYearEnd)
                            fiscalIncome = 0
                        }
                    } else {
                        let dateFromPlusOne: Date = addOnePeriodToDate(dateStart: dateFrom, payPerYear: aFrequency, dateRefer: dateFrom, bolEOMRule: eomRule)
                        if dateFromPlusOne <= nextFiscalYearEnd {
                            fiscalIncome = fiscalIncome + aRent.groups[x].amount.toDecimal()
                        } else if dateFrom <= nextFiscalYearEnd {
                            let proRataRent:Decimal = getProRataRent(dateStart: dateFrom, dateEnd: nextFiscalYearEnd, rentAmount: aRent.groups[x].amount.toDecimal(), aFrequency: aFrequency, baseCommence: aBaseCommence, aEOMRule: eomRule, aDayCountMethod: dayCountMethod)
                            
                            fiscalIncome = fiscalIncome + proRataRent
                            addToRentalIncomes(aFiscalDate: nextFiscalYearEnd, aFiscalAmount: fiscalIncome.toString(decPlaces: 10) )
                            let proRataStart: Decimal = abs(aRent.groups[x].amount.toDecimal() - proRataRent)
                            nextFiscalYearEnd = addNextFiscalYearEnd(aDateIn: nextFiscalYearEnd)
                            fiscalIncome = proRataStart
                        }
                    }
                    dateFrom = addOnePeriodToDate(dateStart: dateFrom, payPerYear: aFrequency, dateRefer: dateFrom, bolEOMRule: eomRule)
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
