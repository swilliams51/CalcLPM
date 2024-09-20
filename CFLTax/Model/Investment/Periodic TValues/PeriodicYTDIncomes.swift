//
//  PeriodicYTDIncomes.swift
//  CFLTax
//
//  Created by Steven Williams on 9/14/24.
//

import Foundation


@Observable
public class PeriodicYTDIncomes: Cashflows {
    
    var myPeriodicRentals: RentalCashflows = RentalCashflows()
    var myDayCountMethod: DayCountMethod =  .actualThreeSixtyFive
    var myFreq: Frequency = .monthly
    var myFundingDate: Date = Date()
    var myBaseCommencementDate: Date = Date()
    var myFiscalYearEnd: Date = Date()
    var myEOMRule: Bool = false
    
    public func createTable(aInvestment: Investment) {
        myDayCountMethod = aInvestment.economics.dayCountMethod
        myFreq = aInvestment.leaseTerm.paymentFrequency
        myFundingDate = aInvestment.asset.fundingDate
        myBaseCommencementDate = aInvestment.leaseTerm.baseCommenceDate
        myFiscalYearEnd = getFiscalYearEnd(askDate: myFundingDate, fiscalMonthEnd: aInvestment.taxAssumptions.fiscalMonthEnd.rawValue)
        myEOMRule =  aInvestment.leaseTerm.endOfMonthRule
        var start = 0
        
        if aInvestment.rent.groups[0].isInterim {
            createYTDInterimRents(aInterimRent: aInvestment.rent.groups[0])
            start = 1
        }
        createYTDBaseRents(aRent: aInvestment.rent, baseStart: start)
    }
    
    private func createYTDInterimRents(aInterimRent: Group) {
        var cfAmount: Decimal = 0.0
        var cfDueDate: Date = aInterimRent.endDate
        
        if myBaseCommencementDate > myFiscalYearEnd {
            if aInterimRent.timing == .advance {
                cfAmount = aInterimRent.amount.toDecimal()
                cfDueDate = myFundingDate
            } else {
                let daysInInterim: Int = dayCount(aDate1: myFundingDate, aDate2: aInterimRent.endDate, aDayCount: myDayCountMethod)
                cfAmount = proRatedInterimRent(dateFiscal: myFundingDate, dateEnd: aInterimRent.endDate, interim: aInterimRent.amount.toDecimal(), daysInInterim: daysInInterim)
                cfDueDate = myBaseCommencementDate
            }
        } else {
            cfAmount = aInterimRent.amount.toDecimal()
            if aInterimRent.timing == .advance {
                cfDueDate = myFundingDate
            } else {
                cfDueDate = myBaseCommencementDate
            }
        }
        self.items.append(Cashflow(dueDate: cfDueDate, amount: cfAmount.toString(decPlaces: 4)))
    }
    
    private func proRatedInterimRent(dateFiscal: Date, dateEnd: Date, interim: Decimal, daysInInterim: Int) -> Decimal {
        let dailyRent: Decimal = interim / Decimal(daysInInterim)
        let dateStart: Date = Calendar.current.date(byAdding: .day, value: 1, to: dateFiscal)!
        let dayCount:Int = dayCount(aDate1: dateStart, aDate2: dateEnd, aDayCount: myDayCountMethod)
        
        let proRatedRent: Decimal = dailyRent * Decimal(dayCount)
       
        return proRatedRent
    }
    
    private func createYTDBaseRents(aRent: Rent, baseStart: Int = 0) {
        let dateRef: Date = myBaseCommencementDate
        var dateFrom: Date = myBaseCommencementDate
        var dateTo: Date = addOnePeriodToDate(dateStart: dateFrom, payPerYear: myFreq, dateRefer: dateRef, bolEOMRule: myEOMRule)
        var dateFiscal: Date = myFiscalYearEnd
        var decYTDIncome: Decimal = 0
        var myCfDueDate: Date = dateFrom
        var myCFAmount: String = "0.0"
        
        if myBaseCommencementDate > myFiscalYearEnd {
            dateFiscal = addNextFiscalYearEnd(aDateIn: myFiscalYearEnd)
        }
        
        for x in baseStart..<aRent.groups.count {
            var y = 0
            while y < aRent.groups[x].noOfPayments {
                if aRent.groups[x].timing == .advance {  //Rents are in advance
                    if dateFrom <= dateFiscal {
                        decYTDIncome = decYTDIncome + aRent.groups[x].amount.toDecimal()
                    } else {
                        dateFiscal = addNextFiscalYearEnd(aDateIn: dateFiscal)
                        decYTDIncome = aRent.groups[x].amount.toDecimal()
                    }
                    myCfDueDate = dateFrom
                    myCFAmount = decYTDIncome.toString()
                } else {  //Rents are in arrears
                    if y == 0 {
                        self.items.append(Cashflow(dueDate: dateFrom, amount: "0.00"))
                    }
                    if dateTo <= dateFiscal {
                        decYTDIncome = decYTDIncome + aRent.groups[x].amount.toDecimal()
                    } else if dateFrom < dateFiscal {
                        let proRatedRent: Decimal = proRatedBaseRent(dateFiscal: dateFiscal, dateEnd: dateTo, base: aRent.groups[x].amount.toDecimal())
                        decYTDIncome = proRatedRent
                        dateFiscal = addNextFiscalYearEnd(aDateIn: dateFiscal)
                    }
                    myCfDueDate = dateTo
                    myCFAmount = decYTDIncome.toString()
                }
                self.items.append(Cashflow(dueDate: myCfDueDate, amount: myCFAmount))
                dateFrom = addOnePeriodToDate(dateStart: dateFrom, payPerYear: myFreq, dateRefer: dateRef, bolEOMRule: myEOMRule)
                dateTo = addOnePeriodToDate(dateStart: dateTo, payPerYear: myFreq, dateRefer: dateRef, bolEOMRule: myEOMRule)
                y += 1
            }
        }
        
    }
    
    private func proRatedBaseRent(dateFiscal: Date, dateEnd: Date, base: Decimal) -> Decimal {
        let dateStart = Calendar.current.date(byAdding: .day, value: 1, to: dateFiscal)!
        let dayCount:Int = dayCount(aDate1: dateStart, aDate2: dateEnd, aDayCount: myDayCountMethod)
        let dailyRent: Decimal = base * Decimal(myFreq.rawValue) / 360
        let proRatedRent: Decimal = dailyRent * Decimal(dayCount)
        
        return proRatedRent
    }
        
}

