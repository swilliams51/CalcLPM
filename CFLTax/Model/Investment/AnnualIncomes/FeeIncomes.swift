//
//  FeeIncomes.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation

@Observable
public class FeeIncomes: Cashflows {
    public var currentFiscalDate: Date = Date()
    public var daysInLease: Int = 0
    public var perDiemFee: Decimal = 0.0
    public var dateStart: Date = Date()
    
    public var monthsInLease: Int = 0
    public var perMonthlyFee: Decimal = 0.0
    private var places: Int = 6

    public func createTable (aInvestment: Investment) {
        let aFee: Fee = aInvestment.fee
        let aMaturityDate: Date = aInvestment.getLeaseMaturityDate()
        let aFiscalMonth: Int = aInvestment.taxAssumptions.fiscalMonthEnd.rawValue
        
        if feeAmortizationMethod == .daily {
            createTable_Daily(aFee: aFee, aMaturityDate: aMaturityDate, aFiscalMonth: aFiscalMonth)
        } else {
            createTable_Monthly(aFee: aFee, aMaturityDate: aMaturityDate, aFiscalMonth: aFiscalMonth)
        }
    }
    
    private func createTable_Daily (aFee: Fee, aMaturityDate: Date, aFiscalMonth: Int) {
        currentFiscalDate = getFiscalYearEnd(askDate: aFee.datePaid, fiscalMonthEnd: aFiscalMonth)
        daysInLease = daysDiff(start: aFee.datePaid, end: aMaturityDate)
        perDiemFee = aFee.amount.toDecimal() / Decimal(daysInLease)
        dateStart = aFee.datePaid
        
        if aFee.feeType == .expense {
            while currentFiscalDate <= aMaturityDate {
                let daysInFiscal = daysDiff(start: dateStart, end: currentFiscalDate)
                let expAmount = perDiemFee * Decimal(daysInFiscal) * -1.0
                let currentFiscalFeeExpense: Cashflow = Cashflow(dueDate: currentFiscalDate, amount: expAmount.toString(decPlaces: places))
                items.append(currentFiscalFeeExpense)
                dateStart = currentFiscalDate
                currentFiscalDate = addNextFiscalYearEnd(aDateIn: currentFiscalDate)
            }
            
            let daysInLastFiscal = daysDiff(start: dateStart, end: aMaturityDate)
            let amount = perDiemFee * Decimal(daysInLastFiscal) * -1.0
            let lastFiscalIncome: Cashflow = Cashflow(dueDate: currentFiscalDate, amount: amount.toString(decPlaces: places))
            items.append(lastFiscalIncome)
        } else {
            createTable_FeeIncome(aFee: aFee, aMaturityDate: aMaturityDate, aFiscalMonth: aFiscalMonth)
        }
    }
    
    private func createTable_Monthly(aFee: Fee, aMaturityDate: Date, aFiscalMonth: Int) {
        currentFiscalDate = getFiscalYearEnd(askDate: aFee.datePaid,fiscalMonthEnd: aFiscalMonth)
        monthsInLease = monthsDifference(start: aFee.datePaid, end: aMaturityDate, inclusive: true)
        perMonthlyFee = aFee.amount.toDecimal() / Decimal(monthsInLease)
        dateStart = aFee.datePaid
        
        if aFee.feeType == .expense {
            while currentFiscalDate <= aMaturityDate {
                let monthsInFiscalYear = monthsDifference(start: dateStart, end: currentFiscalDate, inclusive: true)
                let expAmount = perMonthlyFee * Decimal(monthsInFiscalYear) * -1.0
                let currentFiscalFeeExpense = Cashflow(dueDate: currentFiscalDate, amount: expAmount.toString(decPlaces: places))
                items.append(currentFiscalFeeExpense)
                //dateStart = addNextFiscalYearEnd(aDateIn: currentFiscalDate)
                dateStart = Calendar.current.date(byAdding: .day, value: 1, to: currentFiscalDate)!
                currentFiscalDate = addNextFiscalYearEnd(aDateIn: currentFiscalDate)
            }
            
            let monthsInLastFiscal = monthsDifference(start: dateStart, end: aMaturityDate, inclusive: true)
            let expenseAmount = perMonthlyFee * Decimal(monthsInLastFiscal) * -1.0
            let lastFiscalFeeExpense = Cashflow(dueDate: aMaturityDate, amount: expenseAmount.toString(decPlaces: places))
            items.append(lastFiscalFeeExpense)
        } else {
            createTable_FeeIncome(aFee: aFee, aMaturityDate: aMaturityDate, aFiscalMonth: aFiscalMonth)
        }
    }
    
    private func createTable_FeeIncome(aFee: Fee, aMaturityDate: Date, aFiscalMonth: Int){
        let currentFiscalIncome = Cashflow(dueDate: currentFiscalDate, amount: aFee.amount)
        items.append(currentFiscalIncome)
        currentFiscalDate = addNextFiscalYearEnd(aDateIn: currentFiscalDate)
        while currentFiscalDate <= aMaturityDate {
            items.append(Cashflow(dueDate: currentFiscalDate, amount: "0.00"))
            currentFiscalDate = addNextFiscalYearEnd(aDateIn: currentFiscalDate)
        }
        let lastFiscalIncome: Cashflow = Cashflow(dueDate: currentFiscalDate, amount: "0.00")
        items.append(lastFiscalIncome)
    }
    
    
}
