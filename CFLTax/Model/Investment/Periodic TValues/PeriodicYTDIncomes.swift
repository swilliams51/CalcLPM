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
    
    var ytdIncome: Decimal = 0.0
    var interimRentCF: Cashflows = Cashflows()
    var baseRentCF: Cashflows = Cashflows()
    
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
        
        if interimRentCF.items.count > 0 {
            let myCombinedRents: CollCashflows = CollCashflows()
            myCombinedRents.addCashflows(interimRentCF)
            myCombinedRents.addCashflows(baseRentCF)
            myCombinedRents.netCashflows()
            
            for x in 0..<myCombinedRents.items[0].items.count {
                let myDate: Date = myCombinedRents.items[0].items[x].dueDate
                let myAmount: String = myCombinedRents.items[0].items[x].amount
                let myCashflow: Cashflow = Cashflow(dueDate: myDate, amount: myAmount)
                self.items.append(myCashflow)
            }
        } else {
            for x in 0..<baseRentCF.items.count {
                let myDate: Date = baseRentCF.items[x].dueDate
                let myAmount: String = baseRentCF.items[x].amount
                let myCashflow: Cashflow = Cashflow(dueDate: myDate, amount: myAmount)
                self.items.append(myCashflow)
            }
        }
       
    }
    
    private func createYTDInterimRents(aInterimRent: Group) {
        var cfAmount: Decimal = 0.0
        
        if myBaseCommencementDate > myFiscalYearEnd {
            if aInterimRent.timing == .advance {
                cfAmount = aInterimRent.amount.toDecimal()
                interimRentCF.items.append(Cashflow(dueDate: aInterimRent.startDate, amount: cfAmount.toString(decPlaces: 4)))
                interimRentCF.items.append(Cashflow(dueDate: aInterimRent.endDate, amount: "0.00"))
            } else {
                self.items.append(Cashflow(dueDate: aInterimRent.startDate, amount: "0.00"))
                let daysInInterim: Int = dayCount(aDate1: aInterimRent.startDate, aDate2: aInterimRent.endDate, aDayCount: myDayCountMethod)
                let dateStart: Date = Calendar.current.date(byAdding: .day, value: 1, to: myFiscalYearEnd)!
                cfAmount = proRatedInterimRent(dateFiscal: dateStart, dateEnd: aInterimRent.endDate, interim: aInterimRent.amount.toDecimal(), daysInInterim: daysInInterim)
                interimRentCF.items.append(Cashflow(dueDate: aInterimRent.endDate, amount: cfAmount.toString(decPlaces: 4)))
                ytdIncome = cfAmount
            }
        } else {
            ytdIncome = aInterimRent.amount.toDecimal()
            if aInterimRent.timing == .advance {
                interimRentCF.items.append(Cashflow(dueDate: aInterimRent.startDate, amount: ytdIncome.toString(decPlaces: 4)))
                interimRentCF.items.append(Cashflow(dueDate: aInterimRent.endDate, amount: "0.00"))
            } else {
                interimRentCF.items.append(Cashflow(dueDate: aInterimRent.startDate, amount: "0.00"))
                interimRentCF.items.append(Cashflow(dueDate: aInterimRent.endDate, amount: ytdIncome.toString(decPlaces: 4)))
            }
        }
       
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
        var myCfDueDate: Date = dateFrom
        
        if myBaseCommencementDate > myFiscalYearEnd {
            dateFiscal = addNextFiscalYearEnd(aDateIn: myFiscalYearEnd)
        }
        
        for x in baseStart..<aRent.groups.count {
            var y = 0
            while y <= aRent.groups[x].noOfPayments {
                if aRent.groups[x].timing == .advance {  //Rents are in advance
                    if dateFrom <= dateFiscal {
                        ytdIncome = ytdIncome + aRent.groups[x].amount.toDecimal()
                    } else {
                        dateFiscal = addNextFiscalYearEnd(aDateIn: dateFiscal)
                        ytdIncome = aRent.groups[x].amount.toDecimal()
                    }
                    myCfDueDate = dateFrom
                } else {  //Rents are in arrears
                    if y == 0 {
                        baseRentCF.items.append(Cashflow(dueDate: dateFrom, amount: "0.00"))
                    }
                    if dateTo <= dateFiscal {
                        ytdIncome = ytdIncome + aRent.groups[x].amount.toDecimal()
                    } else if dateFrom < dateFiscal {
                        let proRatedRent: Decimal = proRatedBaseRent(dateFiscal: dateFiscal, dateEnd: dateTo, base: aRent.groups[x].amount.toDecimal())
                        ytdIncome = proRatedRent
                        dateFiscal = addNextFiscalYearEnd(aDateIn: dateFiscal)
                    }
                    myCfDueDate = dateTo
                }
                baseRentCF.items.append(Cashflow(dueDate: myCfDueDate, amount: ytdIncome.toString()))
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

