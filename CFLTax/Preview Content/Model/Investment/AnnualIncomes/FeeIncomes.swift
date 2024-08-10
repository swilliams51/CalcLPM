//
//  FeeIncomes.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation

@Observable
public class FeeIncomes: Cashflows {
    
    public func createTable (aFee: Fee, aAssetCost: String, aMaturityDate: Date, aFiscalMonth:Int) {
        var currentFiscalDate = getFiscalYearEnd(askDate: aFee.datePaid, fiscalMonthEnd: aFiscalMonth)
        let daysInLease: Int = daysDiff(start: aFee.datePaid, end: aMaturityDate)
        let perDiemFee: Decimal = aFee.amount.toDecimal() / Decimal(daysInLease)
        var dateStart = aFee.datePaid
        if aFee.feeType == .expense {
            while currentFiscalDate <= aMaturityDate {
                let daysInFiscal = daysDiff(start: dateStart, end: currentFiscalDate)
                let amount = perDiemFee * Decimal(daysInFiscal) * -1.0
                let currentFiscalIncome: Cashflow = Cashflow(dueDate: currentFiscalDate, amount: amount.toString(decPlaces: 4))
                items.append(currentFiscalIncome)
                dateStart = currentFiscalDate
                currentFiscalDate = addNextFiscalYearEnd(aDateIn: currentFiscalDate)
            }
            
            let daysInLastFiscal = daysDiff(start: dateStart, end: aMaturityDate)
            let amount = perDiemFee * Decimal(daysInLastFiscal) * -1.0
            let lastFiscalIncome: Cashflow = Cashflow(dueDate: currentFiscalDate, amount: amount.toString(decPlaces: 4))
            items.append(lastFiscalIncome)
        } else {
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
    
}
