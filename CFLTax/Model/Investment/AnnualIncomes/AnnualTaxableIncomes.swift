//
//  AnnualTaxableIncomes.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


@Observable
public class AnnualTaxableIncomes: CollCashflows {
    public var myInterimRentalIncomes: InterimRentalIncomes = InterimRentalIncomes()
    public var myBaseRentalIncomes: BaseRentalIncomes = BaseRentalIncomes()
    public var myResidualIncomes: ResidualIncomes = ResidualIncomes()
    public var myDepreciationIncomes: DepreciationIncomes = DepreciationIncomes()
    public var myFeeIncomes: FeeIncomes = FeeIncomes()
    
    public func createTable(aInvestment: Investment) {
        self.myInterimRentalIncomes.removeAll()
        self.myBaseRentalIncomes.removeAll()
        self.myResidualIncomes.removeAll()
        self.myDepreciationIncomes.removeAll()
        self.myFeeIncomes.removeAll()
        
        
        myInterimRentalIncomes.createTable(aRent: aInvestment.rent, aFundingDate: aInvestment.asset.fundingDate, aFrequency: aInvestment.leaseTerm.paymentFrequency, aFiscalMonthEnd: aInvestment.taxAssumptions.fiscalMonthEnd, aLeaseExpiry: aInvestment.getLeaseMaturityDate())
        self.addCashflows(myInterimRentalIncomes)
        
        myBaseRentalIncomes.createTable(aRent: aInvestment.rent, aFundingDate: aInvestment.asset.fundingDate, aBaseCommence: aInvestment.leaseTerm.baseCommenceDate, aFrequency: aInvestment.leaseTerm.paymentFrequency, aFiscalMonthEnd: aInvestment.taxAssumptions.fiscalMonthEnd, aLeaseExpiry: aInvestment.getLeaseMaturityDate())
        self.addCashflows(myBaseRentalIncomes)
        
        myResidualIncomes.createTable(myAsset: aInvestment.asset, aMaturityDate: aInvestment.getLeaseMaturityDate(), aFiscalMonth: aInvestment.taxAssumptions.fiscalMonthEnd.rawValue)
        self.addCashflows(myResidualIncomes)
        
        myDepreciationIncomes.createTable(aDepreciation: aInvestment.depreciation, lessorCost: aInvestment.asset.lessorCost, fundingDate: aInvestment.asset.fundingDate, fiscalMonthEnd: aInvestment.taxAssumptions.fiscalMonthEnd.rawValue, leaseExpiry: aInvestment.getLeaseMaturityDate())
        self.addCashflows(myDepreciationIncomes)
        
        myFeeIncomes.createTable(aFee: aInvestment.fee, aAssetCost: aInvestment.asset.lessorCost, aMaturityDate: aInvestment.getLeaseMaturityDate(), aFiscalMonth: aInvestment.taxAssumptions.fiscalMonthEnd.rawValue)
        self.addCashflows(myFeeIncomes)
    }
    
    public func createNetTaxableIncomes(aInvestment: Investment) -> Cashflows {
        self.createTable(aInvestment: aInvestment)
        self.netCashflows()
        
        let annualTaxableIncome: Cashflows = Cashflows()
        for x in 0..<items[0].count() {
            let item: Cashflow = items[0].items[x]
            annualTaxableIncome.add(item: item)
        }
        
        self.items.removeAll()
        return annualTaxableIncome
    }
    
    public func createPeriodicTaxesPaid_STD(aInvestment: Investment) -> Cashflows {
        self.createTable(aInvestment: aInvestment)
        self.netCashflows()
        
        let ITC: Decimal = aInvestment.depreciation.investmentTaxCredit * aInvestment.asset.lessorCost.toDecimal()
        let dateStart = aInvestment.asset.fundingDate
        var nextFiscalYearEnd = getFiscalYearEnd(askDate: dateStart, fiscalMonthEnd: aInvestment.taxAssumptions.fiscalMonthEnd.rawValue)
        var dateTaxPayment = getFirstTaxPaymentDate(aStartDate: dateStart, aFiscalYearEnd: nextFiscalYearEnd, aDayOfMonth: aInvestment.taxAssumptions.dayOfMonPaid)
        let taxPaymentMonths: [Int] = getTaxPaymentMonths(aFiscalMonthEnd: aInvestment.taxAssumptions.fiscalMonthEnd.rawValue)
        var carryForward: Decimal = 0.0

        let periodicTaxPayments: Cashflows = Cashflows()
        for x in 0..<items[0].count() {
            var totalTaxPayable: Decimal = items[0].items[x].amount.toDecimal() * aInvestment.taxAssumptions.federalTaxRate.toDecimal() * -1.0
            if x == 0 {
                totalTaxPayable = totalTaxPayable + ITC
            }
            let numberOfPayments = getRemainingNoOfTaxPmtsInCurrYear_Monthly(aStartDate: dateStart, aFiscalYearEnd: nextFiscalYearEnd)
            let periodicTaxPayment = totalTaxPayable / Decimal(numberOfPayments)
        
            if dateStart > dateTaxPayment {
                let myCashflow = Cashflow(dueDate: dateTaxPayment, amount: "0.00")
                periodicTaxPayments.add(item: myCashflow)
                carryForward = totalTaxPayable
                dateTaxPayment = addOnePeriodToDate(dateStart: dateTaxPayment, payPerYear: .monthly, dateRefer: aInvestment.leaseTerm.baseCommenceDate, bolEOMRule: true)
            } else {
                while dateTaxPayment < nextFiscalYearEnd {
                    let myAmount = periodicTaxPayment + carryForward
                    if isAskMonthATaxPaymentMonth(aAskDate: dateTaxPayment, aTaxPaymentMonths: taxPaymentMonths) {
                        let myCashflow = Cashflow(dueDate: dateTaxPayment, amount: myAmount.toString(decPlaces: 4))
                        periodicTaxPayments.add(item: myCashflow)
                        if carryForward != 0.0 {
                            carryForward = 0.0
                        }
                    }
                    dateTaxPayment = addOnePeriodToDate(dateStart: dateTaxPayment, payPerYear: .monthly, dateRefer: aInvestment.leaseTerm.baseCommenceDate, bolEOMRule: true)
                }
            }
            nextFiscalYearEnd = addNextFiscalYearEnd(aDateIn: nextFiscalYearEnd)
        }
       self.removeAll()
        
        return periodicTaxPayments
    }
    
    func getTaxPaymentDate(aDateAsk: Date, aDayOfMonth: Int) -> Date {
        let year:Int = getYearComponent(dateIn: aDateAsk)
        let month: Int = getMonthComponent(dateIn: aDateAsk)
        let day: Int = aDayOfMonth
        
        
        var comps = DateComponents()
        comps.day = day
        comps.month = month
        comps.year = year
        
        let taxPaymentDate: Date = Calendar.current.date(from: comps)!
        
        return taxPaymentDate
    }
    
    func isAskMonthATaxPaymentMonth(aAskDate: Date, aTaxPaymentMonths: [Int]) -> Bool {
        var askMonthIsTaxPaymentMonth: Bool = false
        let askMonth = getMonthComponent(dateIn: aAskDate)
        
        for x in 0..<aTaxPaymentMonths.count {
            if askMonth == aTaxPaymentMonths[x] {
                askMonthIsTaxPaymentMonth = true
                break
            }
        }
        
        return askMonthIsTaxPaymentMonth
    }
    
    func getRemainingNoOfTaxPmtsInCurrYear_Monthly(aStartDate: Date, aFiscalYearEnd: Date) -> Int {
        //the minimum value to return is 1
        let monthsDifference: Int = monthsDiff(start: aStartDate, end: aFiscalYearEnd)
        var noOfTaxPmts: Int = 1
        
        switch monthsDifference {
        case _ where monthsDifference > 7:
            noOfTaxPmts = 4
        case _ where monthsDifference > 5:
            noOfTaxPmts = 3
        case _ where monthsDifference > 2:
            noOfTaxPmts = 2
        default:
            noOfTaxPmts = 1
        }
        
        return noOfTaxPmts
    }
    
    func getTaxPaymentMonths(aFiscalMonthEnd: Int) -> [Int] {
        let monthOfYearEnd: Int = aFiscalMonthEnd
        var taxPaymentMonths: [Int] = []
        
        switch monthOfYearEnd {
        case 12:
            taxPaymentMonths = [4, 6, 9, 12]
        case 11:
            taxPaymentMonths = [3, 5, 8, 11]
        case 10:
            taxPaymentMonths = [2, 4, 7, 10]
        case 9:
            taxPaymentMonths = [1, 3, 6, 9]
        case 8:
            taxPaymentMonths = [12, 2, 5, 8]
        case 7:
            taxPaymentMonths = [11, 1, 4, 7]
        case 6:
            taxPaymentMonths = [10, 12, 3, 6]
        case 5:
            taxPaymentMonths = [9, 11, 2, 5]
        case 4:
            taxPaymentMonths = [8, 10, 1, 4]
        case 3:
            taxPaymentMonths = [7, 9, 12, 3]
        case 2:
            taxPaymentMonths = [6, 8, 1, 2]
        default:
            taxPaymentMonths = [5, 7, 10, 1]
        }
        
        return taxPaymentMonths
    }
    
    func getRemainingNoOfTaxPmtsInCurrYear_Date(aStartDate:Date, aFiscalYearEnd: Date, aDayOfMonth: Int) -> Int {
        let myTaxPaymentDates: [Date] = getTaxPaymentDates(aFiscalYearEnd: aFiscalYearEnd, aDayOfMonth: aDayOfMonth)
        var counter: Int = 0

        for x in 0..<myTaxPaymentDates.count {
            if myTaxPaymentDates[x] > aStartDate {
                counter += 1
            }
        }
        return counter
    }
    
    func getFirstTaxPaymentDate(aStartDate:Date, aFiscalYearEnd: Date, aDayOfMonth: Int) -> Date {
        //at a minimum will return the last tax payment date in first fiscal year
        let myTaxPaymentDates: [Date] = getTaxPaymentDates(aFiscalYearEnd: aFiscalYearEnd, aDayOfMonth: aDayOfMonth)
        var firstDate: Date = myTaxPaymentDates[3]
        
        for x in 0..<myTaxPaymentDates.count {
            if aStartDate < myTaxPaymentDates[x] {
               firstDate = myTaxPaymentDates[x]
            }
        }
            
        return firstDate
    }
    
    func getTaxPaymentDates(aFiscalYearEnd: Date, aDayOfMonth: Int) -> [Date] {
        let monthOfYearEnd: Int = getMonthComponent(dateIn: aFiscalYearEnd)
        var paymentDates: [Date] = []
        let year = getYearComponent(dateIn: aFiscalYearEnd)
        var date1 = Date()
        var date2 = Date()
        var date3 = Date()
        var date4 = Date()
        
        switch monthOfYearEnd {
        case 12:
            date1 = dateValue(day: aDayOfMonth, month: 4, year: year)
            date2 = dateValue(day: aDayOfMonth, month: 6, year: year)
            date3 = dateValue(day: aDayOfMonth, month: 9, year: year)
            date4 = dateValue(day: aDayOfMonth, month: 12, year: year)
        case 11:
            date1 = dateValue(day: aDayOfMonth, month: 3, year: year)
            date2 = dateValue(day: aDayOfMonth, month: 5, year: year)
            date3 = dateValue(day: aDayOfMonth, month: 8, year: year)
            date4 = dateValue(day: aDayOfMonth, month: 11, year: year)
        case 10:
            date1 = dateValue(day: aDayOfMonth, month: 2, year: year)
            date2 = dateValue(day: aDayOfMonth, month: 4, year: year)
            date3 = dateValue(day: aDayOfMonth, month: 7, year: year)
            date4 = dateValue(day: aDayOfMonth, month: 10, year: year)
        case 9:
            date1 = dateValue(day: aDayOfMonth, month: 1, year: year)
            date2 = dateValue(day: aDayOfMonth, month: 3, year: year)
            date3 = dateValue(day: aDayOfMonth, month: 6, year: year)
            date4 = dateValue(day: aDayOfMonth, month: 9, year: year)
        case 8:
            date1 = dateValue(day: aDayOfMonth, month: 12, year: year - 1)
            date2 = dateValue(day: aDayOfMonth, month: 2, year: year)
            date3 = dateValue(day: aDayOfMonth, month: 5, year: year)
            date4 = dateValue(day: aDayOfMonth, month: 8, year: year)
        case 7:
            date1 = dateValue(day: aDayOfMonth, month: 11, year: year - 1)
            date2 = dateValue(day: aDayOfMonth, month: 1, year: year)
            date3 = dateValue(day: aDayOfMonth, month: 4, year: year)
            date4 = dateValue(day: aDayOfMonth, month: 7, year: year)
        case 6:
            date1 = dateValue(day: aDayOfMonth, month: 10, year: year - 1)
            date2 = dateValue(day: aDayOfMonth, month: 12, year: year - 1)
            date3 = dateValue(day: aDayOfMonth, month: 3, year: year)
            date4 = dateValue(day: aDayOfMonth, month: 6, year: year)
        case 5:
            date1 = dateValue(day: aDayOfMonth, month: 9, year: year - 1)
            date2 = dateValue(day: aDayOfMonth, month: 11, year: year - 1)
            date3 = dateValue(day: aDayOfMonth, month: 2, year: year)
            date4 = dateValue(day: aDayOfMonth, month: 5, year: year)
        case 4:
            date1 = dateValue(day: aDayOfMonth, month: 8, year: year - 1)
            date2 = dateValue(day: aDayOfMonth, month: 10, year: year - 1)
            date3 = dateValue(day: aDayOfMonth, month: 1, year: year)
            date4 = dateValue(day: aDayOfMonth, month: 4, year: year)
        case 3:
            date1 = dateValue(day: aDayOfMonth, month: 7, year: year - 1)
            date2 = dateValue(day: aDayOfMonth, month: 9, year: year - 1)
            date3 = dateValue(day: aDayOfMonth, month: 12, year: year - 1)
            date4 = dateValue(day: aDayOfMonth, month: 3, year: year)
        case 2:
            date1 = dateValue(day: aDayOfMonth, month: 6, year: year - 1)
            date2 = dateValue(day: aDayOfMonth, month: 8, year: year - 1)
            date3 = dateValue(day: aDayOfMonth, month: 11, year: year - 1)
            date4 = dateValue(day: aDayOfMonth, month: 2, year: year)
        default:
            date1 = dateValue(day: aDayOfMonth, month: 5, year: year - 1)
            date2 = dateValue(day: aDayOfMonth, month: 7, year: year - 1)
            date3 = dateValue(day: aDayOfMonth, month: 10, year: year - 1)
            date4 = dateValue(day: aDayOfMonth, month: 1, year: year)
        }
        paymentDates = [date1, date2, date3, date4]
        
        return paymentDates
    }
        
    func isAskDateATaxPmtDate(aAskDate: Date, aTaxPaymentDates: [Date]) -> Bool {
        var askDateIsTaxPmtDate: Bool = false

        for x in 0..<aTaxPaymentDates.count {
            if aAskDate == aTaxPaymentDates[x] {
                askDateIsTaxPmtDate = true
                break
            }
        }

        return askDateIsTaxPmtDate
    }
    
    
    
    

}
