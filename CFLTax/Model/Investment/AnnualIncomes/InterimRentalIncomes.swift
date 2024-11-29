//
//  InterimRentalIncomes.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


@Observable
public class InterimRentalIncomes: Cashflows {
    
    public func createTable(aInvestment: Investment) {
        
        let aRent: Rent = aInvestment.rent
        let aFundingDate: Date = aInvestment.asset.fundingDate
        let aFrequency: Frequency = aInvestment.leaseTerm.paymentFrequency
        let aFiscalMonthEnd: TaxYearEnd = aInvestment.taxAssumptions.fiscalMonthEnd
        let aLeaseExpiry: Date = aInvestment.getLeaseMaturityDate()
        var nextFiscalYearEnd: Date = getFiscalYearEnd(askDate: aFundingDate, fiscalMonthEnd: aFiscalMonthEnd.rawValue)
        let finalFiscalYearEnd: Date = getFiscalYearEnd(askDate: aLeaseExpiry, fiscalMonthEnd: aFiscalMonthEnd.rawValue)
        let dateStart: Date = aRent.groups[0].startDate
        let dateEnd: Date = aRent.groups[0].endDate
        
        if aRent.groups[0].isInterim == true {
            let strAmount: String = getInterimAmount(aInvestment: aInvestment, aRent: aRent, interimAmount: aRent.groups[0].amount, aFreq: aFrequency)
            
            if aRent.groups[0].timing == .advance {
                let interimRentExpense = Cashflow(dueDate: nextFiscalYearEnd, amount: strAmount)
                items.append(interimRentExpense)
            } else {
                if dateEnd.isLessThanOrEqualTo(date: nextFiscalYearEnd) {
                    let interimRentExpense = Cashflow(dueDate: nextFiscalYearEnd, amount: strAmount)
                    items.append(interimRentExpense)
                } else {
                    if dateEnd.isGreaterThan(date: nextFiscalYearEnd) {
                        let intDaysInPeriod = dayCount(aDate1: dateStart, aDate2: dateEnd, aDayCount: aInvestment.economics.dayCountMethod)
                        let intDaysInFiscal = dayCount(aDate1: dateStart, aDate2: nextFiscalYearEnd, aDayCount: aInvestment.economics.dayCountMethod)
                        let allocatedRent: Decimal = aRent.groups[0].amount.toDecimal() / Decimal(intDaysInPeriod) * Decimal(intDaysInFiscal)
                        var interimRentExpense = Cashflow(dueDate: nextFiscalYearEnd, amount: allocatedRent.toString(decPlaces: 10))
                        items.append(interimRentExpense)
                        let remainRent: Decimal = aRent.groups[0].amount.toDecimal() - allocatedRent
                        nextFiscalYearEnd = addNextFiscalYearEnd(aDateIn: nextFiscalYearEnd)
                        interimRentExpense = Cashflow(dueDate: nextFiscalYearEnd, amount: remainRent.toString(decPlaces: 10))
                        items.append(interimRentExpense)
                    }
                }
            }
        } else {
            let interimRentExpense = Cashflow(dueDate: nextFiscalYearEnd, amount: "0.00")
            items.append(interimRentExpense)
        }
        
        nextFiscalYearEnd = addNextFiscalYearEnd(aDateIn: nextFiscalYearEnd)
        while nextFiscalYearEnd.isLessThanOrEqualTo(date: finalFiscalYearEnd) {
            let interimRentExpense = Cashflow(dueDate: nextFiscalYearEnd, amount: "0.00")
            items.append(interimRentExpense)
            nextFiscalYearEnd = addNextFiscalYearEnd(aDateIn: nextFiscalYearEnd)
        }
    }
    
    private func getInterimAmount(aInvestment: Investment, aRent: Rent, interimAmount: String, aFreq: Frequency) -> String {
        if interimAmount == "CALCULATED" {
            if aRent.groups[0].paymentType == .dailyEquivNext {
                return getDailyRentForNext(aRent: aRent, aFreq: aFreq, aDayCountMethod: aInvestment.economics.dayCountMethod).toString(decPlaces: 4)
            } else {
                return getDailyRentForAll(aRent: aRent, aFreq: aFreq, aDayCountMethod: aInvestment.economics.dayCountMethod).toString(decPlaces: 4)
            }
        } else {
            return interimAmount
        }
        
    }
    
}
