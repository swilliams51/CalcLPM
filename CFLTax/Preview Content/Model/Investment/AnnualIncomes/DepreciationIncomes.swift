//
//  DepreciationIncomes.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


@Observable
public class DepreciationIncomes: Cashflows {
    private var currentDeprecBalance: Decimal = 0.0
    private var currentDepreciation: Decimal = 0.0
    private var currentDepreciationApplied: Decimal = 0.0
    private var runTotalDepreciation: Decimal = 0.0
    private var firstFiscalYearEnd: Date = Date()
    private var intLife: Int = 5 //Depreciable Life
    private var intYears: Int = 5 //Number of years of Annual Interest Expense
    private var decBasis: Decimal = 0.0
    private var decMethod: Decimal = 2.0
    private var bonusPercent: Decimal = 0.0
    private var bonusDepreciation: Decimal = 0.0
    private var decConvention: Decimal = 0.5
    
    public func createTable(aDepreciation: Depreciation, lessorCost: String, fundingDate: Date, fiscalMonthEnd: Int, leaseExpiry: Date) {
        runTotalDepreciation = 0.0
        intLife = aDepreciation.life
        decBasis = getAdjustedBasis(aUnadjustedBasis: lessorCost.toDecimal(), basisReductionFactor: aDepreciation.basisReduction, percentITC: aDepreciation.investmentTaxCredit)
        firstFiscalYearEnd = getFiscalYearEnd(askDate: fundingDate, fiscalMonthEnd: fiscalMonthEnd)
        intYears = getDepreciationYears(leaseExpiry: leaseExpiry)
        decMethod = getMethodFactor(aDepreciationType: aDepreciation.method)
        
        if aDepreciation.method != .StraightLine {
            bonusPercent = aDepreciation.bonusDeprecPercent
            bonusDepreciation = decBasis * bonusPercent
        
            currentDepreciation = getCurrentYearDepreciation(aBasis: decBasis, year: 0)
            currentDepreciation = currentDepreciation * -1.0
            
            let myAnnualExpense = Cashflow(dueDate: firstFiscalYearEnd, amount: currentDepreciation.toString(decPlaces: 4))
            items.append(myAnnualExpense)
            
            runTotalDepreciation = runTotalDepreciation + currentDepreciation
            currentDeprecBalance = decBasis + runTotalDepreciation
            
            var nextFiscalYearEnd: Date  = firstFiscalYearEnd
            for x in 1..<intYears {
                nextFiscalYearEnd = addNextFiscalYearEnd(aDateIn: nextFiscalYearEnd)
                if x == intYears {
                    currentDepreciation = currentDeprecBalance * -1.0
                    let annualExpense = Cashflow(dueDate: nextFiscalYearEnd, amount: currentDepreciation.toString(decPlaces: 4))
                    items.append(annualExpense)
                    break
                } else {
                    if x >= intLife {
                        currentDepreciation = currentDeprecBalance
                    } else {
                        currentDepreciation = getCurrentYearDepreciation(aBasis: currentDeprecBalance, year: x)
                    }
                }
                currentDepreciation = currentDepreciation * -1.0
                let annualExpense = Cashflow(dueDate: nextFiscalYearEnd, amount: currentDepreciation.toString(decPlaces: 4))
                items.append(annualExpense)
                runTotalDepreciation = runTotalDepreciation + currentDepreciation
                currentDeprecBalance = decBasis + runTotalDepreciation
            }
        } else {
            let decSalvageValue: Decimal = aDepreciation.salvageValue.toDecimal()
            let depreciationSL: Decimal = (decBasis - decSalvageValue) / Decimal(intLife)
            currentDepreciation = depreciationSL * decConvention
            currentDepreciation = currentDepreciation * -1.0
            
            let annualExpense = Cashflow(dueDate: firstFiscalYearEnd, amount: currentDepreciation.toString(decPlaces: 4))
            items.append(annualExpense)
            runTotalDepreciation = runTotalDepreciation + currentDepreciation
            currentDeprecBalance = decBasis + runTotalDepreciation
            
            var nextFiscalYearEnd: Date = firstFiscalYearEnd
            for x in 1..<intYears {
                nextFiscalYearEnd = addNextFiscalYearEnd(aDateIn: nextFiscalYearEnd)
                if x == intYears {
                    currentDepreciation = currentDeprecBalance * -1.0 - decSalvageValue
                    let annualExpense: Cashflow = Cashflow(dueDate: nextFiscalYearEnd, amount: currentDepreciation.toString(decPlaces: 4))
                    items.append(annualExpense)
                    break
                } else {
                    if x >= intLife {
                        currentDepreciation = currentDeprecBalance - decSalvageValue
                    } else {
                        currentDepreciation = depreciationSL
                    }
                }
                currentDepreciation = currentDepreciation * -1.0
                let annualExpense = Cashflow(dueDate: nextFiscalYearEnd, amount: currentDepreciation.toString(decPlaces: 4))
                items.append(annualExpense)
                runTotalDepreciation = runTotalDepreciation + currentDepreciation
                currentDeprecBalance = decBasis + runTotalDepreciation
            }
        }
        
    }
    
    public func getAdjustedBasis(aUnadjustedBasis: Decimal, basisReductionFactor: Decimal, percentITC: Decimal) -> Decimal {
        let decBasisReduction: Decimal = basisReductionFactor * percentITC * aUnadjustedBasis
        
        return aUnadjustedBasis - decBasisReduction
    }
    
    public func getCurrentYearDepreciation(aBasis: Decimal, year: Int) -> Decimal {
        let deprecFactor: Decimal = 1.0 / Decimal(intLife)
        let curDeprec_DB: Decimal = getCurrentDeprec_DB(aBasis: aBasis, deprecFactor: deprecFactor)
        let curDeprec_SL: Decimal = getCurrentDeprec_SL(aBasis: aBasis, year: year)
        var curDeprec_Applied: Decimal = 0.0
        
        if year == 0 {
           curDeprec_Applied = getFirstYearDeprecExpense(aBasis: aBasis, decFactor: deprecFactor)
        } else {
            curDeprec_Applied = max(curDeprec_DB, curDeprec_SL)
        }
        
        return curDeprec_Applied
    }
    
    public func getFirstYearDeprecExpense (aBasis: Decimal, decFactor: Decimal) -> Decimal {
        let myBasis: Decimal = aBasis - bonusDepreciation
        //print("\(bonusDepreciation.toString(decPlaces: 5))")
        let firstYearDeprec: Decimal = bonusDepreciation + (myBasis * decFactor * decMethod * decConvention)
        
        return firstYearDeprec
    }
    
    public func getCurrentDeprec_DB (aBasis: Decimal, deprecFactor: Decimal) -> Decimal {
        let myCurrentDeprec_DB = aBasis * deprecFactor * decMethod
        
        return myCurrentDeprec_DB
    }
    
    public func getCurrentDeprec_SL (aBasis: Decimal, year: Int) -> Decimal {
        let denominator: Decimal = Decimal(intLife) - Decimal(year) + (1 - decConvention)
        
        return aBasis / denominator
    }
    
    private func getDepreciationYears(leaseExpiry: Date) -> Int {
        var x: Int = 0
        var currFiscalYearEnd = firstFiscalYearEnd
        
        while leaseExpiry > currFiscalYearEnd {
            x += 1
            currFiscalYearEnd = addNextFiscalYearEnd(aDateIn: currFiscalYearEnd)
        }
        
        return x + 1
    }
    
}
