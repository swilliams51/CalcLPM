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
        
        myInterimRentalIncomes.createTable(aInvestment: aInvestment)
        self.addCashflows(myInterimRentalIncomes)
        
        myBaseRentalIncomes.createTable(aInvestment: aInvestment)
        self.addCashflows(myBaseRentalIncomes)
        
        myResidualIncomes.createTable(aInvestment: aInvestment)
        self.addCashflows(myResidualIncomes)
        
        myDepreciationIncomes.createTable(aInvestment: aInvestment)
        self.addCashflows(myDepreciationIncomes)
        
        myFeeIncomes.createTable(aInvestment: aInvestment)
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
        
        self.removeAll()
        
        return annualTaxableIncome
    }
    
    public func createPeriodicTaxesPaid_STD(aInvestment: Investment) -> Cashflows {
        self.createTable(aInvestment: aInvestment)
        self.netCashflows()
        
        let ITC: Decimal = aInvestment.depreciation.investmentTaxCredit * aInvestment.asset.lessorCost.toDecimal()
        let dateStart = aInvestment.asset.fundingDate
        var nextFiscalYearEnd = getFiscalYearEnd(askDate: dateStart, fiscalMonthEnd: aInvestment.taxAssumptions.fiscalMonthEnd.rawValue)
        var dateTaxPayment = getFirstTaxPaymentDate_Month(aStartDate: dateStart, aFiscalYearEnd: nextFiscalYearEnd, aDayOfMonth: aInvestment.taxAssumptions.dayOfMonPaid)
        let taxPaymentMonths: [Int] = getTaxPaymentMonths(aFiscalMonthEnd: aInvestment.taxAssumptions.fiscalMonthEnd.rawValue)
    
        let periodicTaxPayments: Cashflows = Cashflows()
        for x in 0..<items[0].count() {
            var numberOfPayments: Int = 4
            var totalTaxPayable: Decimal = items[0].items[x].amount.toDecimal() * aInvestment.taxAssumptions.federalTaxRate.toDecimal() * -1.0
            if x == 0 { //if First Tax Year
                totalTaxPayable = totalTaxPayable + ITC
                numberOfPayments = getRemainNoOfTaxPmtsInYear_Month(aStartDate: dateStart, aFiscalYearEnd: nextFiscalYearEnd)
            }
            let periodicTaxPayment = totalTaxPayable / Decimal(numberOfPayments)
            while dateTaxPayment < nextFiscalYearEnd {
                if isAskMonthATaxPaymentMonth(aAskDate: dateTaxPayment, aTaxPaymentMonths: taxPaymentMonths) {
                    let myCashflow = Cashflow(dueDate: dateTaxPayment, amount: periodicTaxPayment.toString(decPlaces: 4))
                    periodicTaxPayments.add(item: myCashflow)
                }
                dateTaxPayment = addOnePeriodToDate(dateStart: dateTaxPayment, payPerYear: .monthly, dateRefer: aInvestment.leaseTerm.baseCommenceDate, bolEOMRule: aInvestment.leaseTerm.endOfMonthRule)
            }
            nextFiscalYearEnd = addNextFiscalYearEnd(aDateIn: nextFiscalYearEnd)
        }
        self.removeAll()
         
        return periodicTaxPayments
    }
    
    
    public func createPeriodicTaxesPaid_EBO(aInvestment: Investment, plannedIncome: String, unplannedDate: Date) -> Cashflows {
        self.createTable(aInvestment: aInvestment)
        self.netCashflows()  //Taxable income by fiscal year
        
        let eomRule: Bool = aInvestment.leaseTerm.endOfMonthRule
        let ITC: Decimal = aInvestment.depreciation.investmentTaxCredit * aInvestment.asset.lessorCost.toDecimal()
        let dateStart = aInvestment.asset.fundingDate
        let referDate: Date = aInvestment.leaseTerm.baseCommenceDate
        var nextFiscalYearEnd = getFiscalYearEnd(askDate: dateStart, fiscalMonthEnd: aInvestment.taxAssumptions.fiscalMonthEnd.rawValue)
        var dateTaxPayment = getFirstTaxPaymentDate_Month(aStartDate: dateStart, aFiscalYearEnd: nextFiscalYearEnd, aDayOfMonth: aInvestment.taxAssumptions.dayOfMonPaid)
        let taxPaymentMonths: [Int] = getTaxPaymentMonths(aFiscalMonthEnd: aInvestment.taxAssumptions.fiscalMonthEnd.rawValue)
    
        let periodicTaxPayments: Cashflows = Cashflows()
        for x in 0..<items[0].count() {
            var numberOfPayments: Int = 4
            var totalTaxPayable: Decimal = items[0].items[x].amount.toDecimal() * aInvestment.taxAssumptions.federalTaxRate.toDecimal() * -1.0
            if x == 0 { //if First Tax Year
                totalTaxPayable = totalTaxPayable + ITC
                numberOfPayments = getRemainNoOfTaxPmtsInYear_Month(aStartDate: dateStart, aFiscalYearEnd: nextFiscalYearEnd)
            }
            if x == items[0].count() - 1 { // if Last Tax Year
                let annualTaxPaymentUnplanned: Decimal = items[0].items[x].amount.toDecimal() * aInvestment.taxAssumptions.federalTaxRate.toDecimal() * -1.0
                let annualTaxPaymentPlanned: Decimal = plannedIncome.toDecimal() * aInvestment.taxAssumptions.federalTaxRate.toDecimal() * -1.0
                let myTerminationTaxPayments: Cashflows = periodicTaxPaymentsForTermination(totalTaxPaymentUnplanned: annualTaxPaymentUnplanned, totalTaxPaymentPlanned: annualTaxPaymentPlanned, unPlannedDate: unplannedDate, dateTaxPayment: dateTaxPayment, nextFiscalDate: nextFiscalYearEnd, taxPayMonths: taxPaymentMonths, referDate: referDate, aEOMRule: eomRule)
                for x in 0..<myTerminationTaxPayments.items.count {
                    let myCashflow = Cashflow(dueDate: myTerminationTaxPayments.items[x].dueDate, amount: myTerminationTaxPayments.items[x].amount)
                    periodicTaxPayments.add(item: myCashflow)
                }
                
            }
            if x < items[0].count() - 1 {
                let periodicTaxPayment = totalTaxPayable / Decimal(numberOfPayments)
                while dateTaxPayment < nextFiscalYearEnd {
                    if isAskMonthATaxPaymentMonth(aAskDate: dateTaxPayment, aTaxPaymentMonths: taxPaymentMonths) {
                        let myCashflow = Cashflow(dueDate: dateTaxPayment, amount: periodicTaxPayment.toString(decPlaces: 4))
                        periodicTaxPayments.add(item: myCashflow)
                    }
                    dateTaxPayment = addOnePeriodToDate(dateStart: dateTaxPayment, payPerYear: .monthly, dateRefer: referDate, bolEOMRule: eomRule)
                }
                nextFiscalYearEnd = addNextFiscalYearEnd(aDateIn: nextFiscalYearEnd)
            }
        }
        self.removeAll()
         
        return periodicTaxPayments
    }
    
    
    private func periodicTaxPaymentsForTermination(totalTaxPaymentUnplanned: Decimal, totalTaxPaymentPlanned: Decimal, unPlannedDate: Date, dateTaxPayment: Date, nextFiscalDate: Date, taxPayMonths: [Int], referDate: Date, aEOMRule: Bool) -> Cashflows {
        let taxPaymentMonths: [Int] = taxPayMonths
        let periodicTaxPaymentPlanned: Decimal = totalTaxPaymentPlanned / 4.0 //197463.22 / 4 = 41467.26
        let remainingNoOfTaxPaymentsAfterTermination: Int = getRemainNoOfTaxPmtsInYear_Month(aStartDate: unPlannedDate, aFiscalYearEnd: nextFiscalDate)
        var periodicTaxPaymentUnplanned: Decimal = 0.0
        if remainingNoOfTaxPaymentsAfterTermination == 0 {
            periodicTaxPaymentUnplanned = totalTaxPaymentUnplanned - totalTaxPaymentPlanned
        } else {
            periodicTaxPaymentUnplanned = (totalTaxPaymentUnplanned - totalTaxPaymentPlanned) / Decimal(remainingNoOfTaxPaymentsAfterTermination)
        }
        
        var totalPeriodicTaxPayment: Decimal = 0.0
        var dateStart: Date = dateTaxPayment
        var x: Int = 1
        
        let taxPaymentsForTermination: Cashflows = Cashflows()
        while dateStart < nextFiscalDate {
            if isAskMonthATaxPaymentMonth(aAskDate: dateStart, aTaxPaymentMonths: taxPaymentMonths) {
                if x > (4 - remainingNoOfTaxPaymentsAfterTermination) {
                    totalPeriodicTaxPayment = periodicTaxPaymentPlanned + periodicTaxPaymentUnplanned
                } else {
                    totalPeriodicTaxPayment = periodicTaxPaymentPlanned
                }
                let myCashflow = Cashflow(dueDate: dateStart, amount: totalPeriodicTaxPayment.toString(decPlaces: 4))
                taxPaymentsForTermination.items.append(myCashflow)
                x += 1
            }
            dateStart = addOnePeriodToDate(dateStart: dateStart, payPerYear: .monthly, dateRefer: referDate, bolEOMRule: aEOMRule)
        }
        
        return taxPaymentsForTermination
    }
       
    
    func isAskDateLater(aDateAsk: Date, compareDate: Date, byMonth: Bool) -> Bool {
        var isLater: Bool = false
        if byMonth {
            let askMonth: Int = getMonthComponent(dateIn: aDateAsk)
            let compareMonth: Int = getMonthComponent(dateIn: compareDate)
            if askMonth > compareMonth {
                isLater = true
            }
        } else {
            if aDateAsk > compareDate {
                isLater = true
            }
        }
        
        return isLater
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
    
    func getRemainNoOfTaxPmtsInYear_Date(aStartDate:Date, aFiscalYearEnd: Date, aDayOfMonth: Int) -> Int {
        let myTaxPaymentDates: [Date] = getTaxPaymentDates(aFiscalYearEnd: aFiscalYearEnd, aDayOfMonth: aDayOfMonth)
        var counter: Int = 0

        for x in 0..<myTaxPaymentDates.count {
            if myTaxPaymentDates[x] >= aStartDate {
                break
            }
            counter += 1
        }
        
        return 4 - counter
    }
    
    func getRemainNoOfTaxPmtsInYear_Month(aStartDate: Date, aFiscalYearEnd: Date) -> Int {
        let myFiscalMonthEnd: Int = getMonthComponent(dateIn: aFiscalYearEnd)
        let myTaxMonths: [Int] = getTaxPaymentMonths(aFiscalMonthEnd: myFiscalMonthEnd)
        let startMonth: Int = getMonthComponent(dateIn: aStartDate)
        var counter: Int = 0
        
        for x in 0..<myTaxMonths.count {
            if myTaxMonths[x] >= startMonth {
                break
            }
            counter += 1
        }
        
        return 4 - counter
    }
    
    func getFirstTaxPaymentDate_Month(aStartDate: Date, aFiscalYearEnd: Date, aDayOfMonth: Int) -> Date {
        let myTaxMonths: [Int] = getTaxPaymentMonths(aFiscalMonthEnd: getMonthComponent(dateIn: aFiscalYearEnd))
        let myStartMonth: Int = getMonthComponent(dateIn: aStartDate)
        var firstMonth: Int = myTaxMonths[0]
        let firstYear: Int = getYearComponent(dateIn: aStartDate)
        
        for x in 0..<myTaxMonths.count {
            if myTaxMonths[x] >= myStartMonth {
                firstMonth = myTaxMonths[x]
                break
            }
        }
        
        var comps = DateComponents()
        comps.day = aDayOfMonth
        comps.month = firstMonth
        comps.year = firstYear
        
        let dateNew = Calendar.current.date(from: comps)!
        
        
        return dateNew
    }
    
    func getFirstTaxPaymentDate(aStartDate: Date, aFiscalYearEnd: Date, aDayOfMonth: Int) -> Date {
        //at a minimum will return the last tax payment date in first fiscal year
        let myTaxPaymentDates: [Date] = getTaxPaymentDates(aFiscalYearEnd: aFiscalYearEnd, aDayOfMonth: aDayOfMonth)
        var firstDate: Date = myTaxPaymentDates[3]
        
        for x in 0..<myTaxPaymentDates.count {
            if aStartDate <= myTaxPaymentDates[x] {
               firstDate = myTaxPaymentDates[x]
                break
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
        
    
    
    
    

}
