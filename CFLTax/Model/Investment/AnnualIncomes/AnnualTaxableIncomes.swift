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
        var dateTaxPayment = getFirstTaxPaymentDate_Month(aFundingDate: dateStart, aFiscalYearEnd: nextFiscalYearEnd, aDayOfMonth: aInvestment.taxAssumptions.dayOfMonPaid)
        let taxPaymentMonths: [Int] = getTaxPaymentMonths(aFiscalMonthEnd: aInvestment.taxAssumptions.fiscalMonthEnd.rawValue)
    
        let periodicTaxPayments: Cashflows = Cashflows()
        for x in 0..<items[0].count() {
            var numberOfPayments: Int = 4
            var totalTaxPayable: Decimal = items[0].items[x].amount.toDecimal() * aInvestment.taxAssumptions.federalTaxRate.toDecimal() * -1.0
            if x == 0 { //if First Tax Year
                totalTaxPayable = totalTaxPayable + ITC
                numberOfPayments = getRemainNoOfTaxPmtsInYear_Month(aFirstTaxPaymentDate: dateTaxPayment, aFiscalYearEnd: nextFiscalYearEnd)
            }
            let periodicTaxPayment = totalTaxPayable / Decimal(numberOfPayments)
            while dateTaxPayment.isLessThan(date: nextFiscalYearEnd) {
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
        var dateTaxPayment = getFirstTaxPaymentDate_Month(aFundingDate: dateStart, aFiscalYearEnd: nextFiscalYearEnd, aDayOfMonth: aInvestment.taxAssumptions.dayOfMonPaid)
        let taxPaymentMonths: [Int] = getTaxPaymentMonths(aFiscalMonthEnd: aInvestment.taxAssumptions.fiscalMonthEnd.rawValue)
    
        let periodicTaxPayments: Cashflows = Cashflows()
        for x in 0..<items[0].count() {
            var numberOfPayments: Int = 4
            var totalTaxPayable: Decimal = items[0].items[x].amount.toDecimal() * aInvestment.taxAssumptions.federalTaxRate.toDecimal() * -1.0
            if x == 0 { //if First Tax Year
                totalTaxPayable = totalTaxPayable + ITC
                numberOfPayments = getRemainNoOfTaxPmtsInYear_Month(aFirstTaxPaymentDate: dateTaxPayment, aFiscalYearEnd: nextFiscalYearEnd)
            }
            if x == items[0].count() - 1 { // if Last Tax Year
                let annualTaxPaymentUnplanned: Decimal = items[0].items[x].amount.toDecimal() * aInvestment.taxAssumptions.federalTaxRate.toDecimal() * -1.0
                let annualTaxPaymentPlanned: Decimal = plannedIncome.toDecimal() * aInvestment.taxAssumptions.federalTaxRate.toDecimal() * -1.0
                
                let myTerminationTaxPayments: Cashflows = periodicTaxPaymentsForTermination(totalTaxPaymentUnplanned: annualTaxPaymentUnplanned, totalTaxPaymentPlanned: annualTaxPaymentPlanned, unPlannedDate: unplannedDate, firstDateInFiscalYear: dateTaxPayment, nextFiscalDate: nextFiscalYearEnd, taxPayMonths: taxPaymentMonths, referDate: referDate, aEOMRule: eomRule)
                for x in 0..<myTerminationTaxPayments.items.count {
                    let myCashflow = Cashflow(dueDate: myTerminationTaxPayments.items[x].dueDate, amount: myTerminationTaxPayments.items[x].amount)
                    periodicTaxPayments.add(item: myCashflow)
                }
            }
            if x < items[0].count() - 1 {
                let periodicTaxPayment = totalTaxPayable / Decimal(numberOfPayments)
                while dateTaxPayment.isLessThan(date: nextFiscalYearEnd) {
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
    
    private func periodicTaxPaymentsForTermination(totalTaxPaymentUnplanned: Decimal, totalTaxPaymentPlanned: Decimal, unPlannedDate: Date, firstDateInFiscalYear: Date, nextFiscalDate: Date, taxPayMonths: [Int], referDate: Date, aEOMRule: Bool) -> Cashflows {
        let taxPaymentMonths: [Int] = taxPayMonths //[4,6,9,12]
       //197463.22 / 4 = 41467.26
        let remainingNoOfTaxPaymentsAfterTermination: Int = getRemainNoOfTaxPmtsAfterDate(askDate: unPlannedDate, aFiscalYearEnd: nextFiscalDate)
        let totalAnnualTaxPayment: Decimal = totalTaxPaymentUnplanned
        let periodicTaxPaymentPlanned: Decimal = totalTaxPaymentPlanned / 4.0
        var periodicTaxPaymentUnplanned: Decimal = totalTaxPaymentUnplanned
        var periodicTaxPayment: Decimal = 0.0
        var dateStart: Date = firstDateInFiscalYear
        
        let taxPaymentsForTermination: Cashflows = Cashflows()
        var taxPaymentNumber: Int = 1
        
        switch remainingNoOfTaxPaymentsAfterTermination {
        case 4 :
            periodicTaxPaymentUnplanned = periodicTaxPaymentUnplanned / 4.0
        case 3:
            periodicTaxPaymentUnplanned = (totalAnnualTaxPayment  - periodicTaxPaymentPlanned) / 3.0
        case 2:
            periodicTaxPaymentUnplanned = (totalAnnualTaxPayment - (2.0 * periodicTaxPaymentPlanned)) / 2.0
        default:
            periodicTaxPaymentUnplanned = (totalAnnualTaxPayment  - ( 3.0 * periodicTaxPaymentPlanned))
        }
        
        while dateStart.isLessThanOrEqualTo(date: nextFiscalDate) {
            if isAskMonthATaxPaymentMonth(aAskDate: dateStart, aTaxPaymentMonths: taxPaymentMonths) {
                switch remainingNoOfTaxPaymentsAfterTermination {
                case 4:
                    periodicTaxPayment = periodicTaxPaymentUnplanned
                case 3:
                    if taxPaymentNumber == 1 {
                        periodicTaxPayment = periodicTaxPaymentPlanned
                    } else {
                        periodicTaxPayment = periodicTaxPaymentUnplanned
                    }
                case 2:
                    if taxPaymentNumber <= 2 {
                        periodicTaxPayment = periodicTaxPaymentPlanned
                    } else {
                        periodicTaxPayment = periodicTaxPaymentUnplanned
                    }
                default:
                    if taxPaymentNumber <= 3 {
                        periodicTaxPayment = periodicTaxPaymentPlanned
                    } else {
                        periodicTaxPayment = periodicTaxPaymentUnplanned
                    }
                }
                let myCashflow = Cashflow(dueDate: dateStart, amount: periodicTaxPayment.toString(decPlaces: 4))
                taxPaymentsForTermination.items.append(myCashflow)
                taxPaymentNumber += 1
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
            if aAskDate.isEqualTo(date: aTaxPaymentDates[x]) {
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
            taxPaymentMonths = [4, 6, 9, 12] //December
        case 11:
            taxPaymentMonths = [3, 5, 8, 11] //November
        case 10:
            taxPaymentMonths = [2, 4, 7, 10] //October
        case 9:
            taxPaymentMonths = [1, 3, 6, 9] //September
        case 8:
            taxPaymentMonths = [12, 2, 5, 8] //August
        case 7:
            taxPaymentMonths = [11, 1, 4, 7] //July
        case 6:
            taxPaymentMonths = [10, 12, 3, 6] //June
        case 5:
            taxPaymentMonths = [9, 11, 2, 5] //May
        case 4:
            taxPaymentMonths = [8, 10, 1, 4] //April
        case 3:
            taxPaymentMonths = [7, 9, 12, 3] //March
        case 2:
            taxPaymentMonths = [6, 8, 11, 2] //February
        default:
            taxPaymentMonths = [5, 7, 10, 1] //January
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
    
    func getRemainNoOfTaxPmtsInYear_Month(aFirstTaxPaymentDate: Date, aFiscalYearEnd: Date) -> Int {
        let myFiscalMonthEnd: Int = getMonthComponent(dateIn: aFiscalYearEnd)
        let myTaxMonths: [Int] = getTaxPaymentMonths(aFiscalMonthEnd: myFiscalMonthEnd)
        let startMonth: Int = getMonthComponent(dateIn: aFirstTaxPaymentDate)
        var counter: Int = 0
        
        for x in 0..<myTaxMonths.count {
            if startMonth == myTaxMonths[x] {
                counter = x
                break
            }
        }
            
        return 4 - counter
    }
    
    func getRemainNoOfTaxPmtsAfterDate(askDate: Date, aFiscalYearEnd: Date) -> Int {
        let myTaxPaymentMonths: [Int] = getTaxPaymentMonths(aFiscalMonthEnd: getMonthComponent(dateIn: aFiscalYearEnd))
        //[4,6,9,12]; [10,12,3,6], [8,10,1,4], [5,7,10,1], [11,1,4,7]
        var askMonth: Int = getMonthComponent(dateIn: askDate) // 11
        var monthFound: Bool = false
        var counter: Int = 0
        
        while monthFound == false {
            for x in 0..<myTaxPaymentMonths.count {
                if myTaxPaymentMonths[x] == askMonth {
                    counter = x
                    monthFound = true
                    break
                }
            }
            if monthFound == false {
                askMonth = getNewAskMonth(monthIn: askMonth)
            }
        }
        
        return 4 - counter
    }
    
    func getNewAskMonth(monthIn: Int) -> Int {
        if monthIn == 12 {
            return 1
        } else {
            return monthIn + 1
        }
    }
    
    func getFirstTaxPaymentDate_Month(aFundingDate: Date, aFiscalYearEnd: Date, aDayOfMonth: Int) -> Date {
        //given funding date return the Lessor's first tax payment date
        let taxPaymentMonths: [Int] = getTaxPaymentMonths(aFiscalMonthEnd: getMonthComponent(dateIn: aFiscalYearEnd))
        let fundingMonth: Int = getMonthComponent(dateIn: aFundingDate)
        var firstPaymentMonth: Int = 0
        var monthToTest: Int = fundingMonth
        var monthFound: Bool = false
        let firstYear: Int = getYearComponent(dateIn: aFundingDate)
        var yearAdder: Int = 0
        var x = 0
        
        while firstPaymentMonth == 0 {
            while x < taxPaymentMonths.count {
                if monthToTest == taxPaymentMonths[x] {
                    firstPaymentMonth = taxPaymentMonths[x]
                    monthFound = true
                    break
                }
                x += 1
            }
            if monthFound == false {
                let nextMonth = getNextMonth(monthIn: monthToTest, yrAdder: yearAdder)
                monthToTest = nextMonth.0
                yearAdder = nextMonth.1
                x = 0
            }
        }
       
        var comps = DateComponents()
        comps.day = aDayOfMonth
        comps.month = firstPaymentMonth
        comps.year = firstYear + yearAdder
        
        let dateNew = Calendar.current.date(from: comps)!
        
        return dateNew
    }
    
    private func getNextMonth(monthIn: Int, yrAdder: Int) -> (Int, Int) {
        var monthOut: Int = monthIn
        var yearAdder: Int = yrAdder
        
        if monthIn < 12 {
            monthOut += 1
        } else {
            monthOut = 1
            yearAdder += 1
        }
        
        return (monthOut, yearAdder)
    }
    
    func getFirstTaxPaymentDate(aStartDate: Date, aFiscalYearEnd: Date, aDayOfMonth: Int) -> Date {
        //at a minimum will return the last tax payment date in first fiscal year
        let myTaxPaymentDates: [Date] = getTaxPaymentDates(aFiscalYearEnd: aFiscalYearEnd, aDayOfMonth: aDayOfMonth)
        var firstDate: Date = myTaxPaymentDates[3]
        
        for x in 0..<myTaxPaymentDates.count {
            if aStartDate.isLessThanOrEqualTo(date: myTaxPaymentDates[x]) {
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
