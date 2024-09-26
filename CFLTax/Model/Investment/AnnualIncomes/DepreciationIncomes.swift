//
//  DepreciationIncomes.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


@Observable
public class DepreciationIncomes: Cashflows {
    
    var aDepreciation: Depreciation = Depreciation()
    var aFiscalMonthEnd: Int = 12
    var bonusDepreciation: Decimal = 0.0
    var bonusDepreciationAsPercent: Decimal = 0.0
    var currentDeprecBalance: Decimal = 0.0
    var currentDeprecExpense: Decimal = 0.0
    var decBasis: Decimal = 0.0
    var decConvention: Decimal = 0.5
    var decMACRSFactor: Decimal = 2.0
    var firstFiscalYearEnd: Date = Date()
    var fundingDate: Date = Date()
    var intLife: Int = 5 //Depreciable Life in years
    var intYears: Int = 5 //Number of fiscal years in Lease
    var leaseExpiry = Date ()
    var lessorCost: String = "0.0"
    var myConventionType: ConventionType = .halfYear
    var runTotalDepreciation: Decimal = 0.0
    
    public func createTable(aInvestment: Investment) {
        aDepreciation = aInvestment.depreciation
        lessorCost = aInvestment.asset.lessorCost
        fundingDate = aInvestment.asset.fundingDate
        aFiscalMonthEnd = aInvestment.taxAssumptions.fiscalMonthEnd.rawValue
        leaseExpiry = aInvestment.getLeaseMaturityDate()
        myConventionType = aInvestment.depreciation.convention
        runTotalDepreciation = 0.0
        intLife = aDepreciation.life
        decBasis = getAdjustedBasis(aUnadjustedBasis: lessorCost.toDecimal(), basisReductionFactor: aDepreciation.basisReduction, percentITC: aDepreciation.investmentTaxCredit)
        firstFiscalYearEnd = getFiscalYearEnd(askDate: fundingDate, fiscalMonthEnd: aFiscalMonthEnd)
        intYears = getFiscalYearsOfLease(leaseExpiry: leaseExpiry)
        decMACRSFactor = getMethodFactor(aDepreciationType: aDepreciation.method)
        setConventionFactor(aFiscalYearEnd: firstFiscalYearEnd, dateInService: aInvestment.asset.fundingDate)
        
        if aDepreciation.method != .StraightLine {
            createTable_MACRS()
        } else {
            createTable_SL()
        }
    }
    
    func createTable_MACRS () {
        bonusDepreciationAsPercent = aDepreciation.bonusDeprecPercent
        bonusDepreciation = decBasis * bonusDepreciationAsPercent
        currentDeprecExpense = getCurrentYearDepreciation(aBasis: decBasis, year: 0)
        currentDeprecExpense = currentDeprecExpense * -1.0
        
        let myAnnualExpense = Cashflow(dueDate: firstFiscalYearEnd, amount: currentDeprecExpense.toString(decPlaces: 10))
        items.append(myAnnualExpense)
        
        runTotalDepreciation = runTotalDepreciation + currentDeprecExpense
        currentDeprecBalance = decBasis + runTotalDepreciation
        
        var nextFiscalYearEnd: Date  = firstFiscalYearEnd
        for x in 1...intYears {
            nextFiscalYearEnd = addNextFiscalYearEnd(aDateIn: nextFiscalYearEnd)
            if x == intYears {
                currentDeprecExpense = currentDeprecBalance * -1.0
                let annualExpense = Cashflow(dueDate: nextFiscalYearEnd, amount: currentDeprecExpense.toString(decPlaces: 10))
                items.append(annualExpense)
                break
            } else {
                if x == intLife {
                    currentDeprecExpense = currentDeprecBalance
                } else {
                    currentDeprecExpense = getCurrentYearDepreciation(aBasis: currentDeprecBalance, year: x)
                }
            }
            currentDeprecExpense = currentDeprecExpense * -1.0
            let annualExpense = Cashflow(dueDate: nextFiscalYearEnd, amount: currentDeprecExpense.toString(decPlaces: 10))
            items.append(annualExpense)
            runTotalDepreciation = runTotalDepreciation + currentDeprecExpense
            currentDeprecBalance = decBasis + runTotalDepreciation
        }
    }
    
    func createTable_SL () {
        let decSalvageValue: Decimal = aDepreciation.salvageValue.toDecimal()
        let depreciationSL: Decimal = (decBasis - decSalvageValue) / Decimal(intLife - 1)
        decBasis = decBasis - decSalvageValue
        currentDeprecExpense = depreciationSL * decConvention
        currentDeprecExpense = currentDeprecExpense * -1.0
        
        let annualExpense = Cashflow(dueDate: firstFiscalYearEnd, amount: currentDeprecExpense.toString(decPlaces: 10))
        items.append(annualExpense)
        runTotalDepreciation = runTotalDepreciation + currentDeprecExpense
        currentDeprecBalance = decBasis + runTotalDepreciation
        
        var nextFiscalYearEnd: Date = firstFiscalYearEnd
        for x in 2...intYears {
            nextFiscalYearEnd = addNextFiscalYearEnd(aDateIn: nextFiscalYearEnd)
            if x == intYears {
                currentDeprecExpense =  decSalvageValue * -1.0
                let annualExpense: Cashflow = Cashflow(dueDate: nextFiscalYearEnd, amount: currentDeprecExpense.toString(decPlaces: 10))
                items.append(annualExpense)
                break
            }
            if x == intLife {
                currentDeprecExpense = currentDeprecBalance * -1.0
                let annualExpense: Cashflow = Cashflow(dueDate: nextFiscalYearEnd, amount: currentDeprecExpense.toString(decPlaces: 10))
                items.append(annualExpense)
            } else if x > intLife {
                currentDeprecExpense = 0.00
                let annualExpense: Cashflow = Cashflow(dueDate: nextFiscalYearEnd, amount: currentDeprecExpense.toString(decPlaces: 10))
                items.append(annualExpense)
            } else {
                currentDeprecExpense = depreciationSL * -1.0
                let annualExpense = Cashflow(dueDate: nextFiscalYearEnd, amount: currentDeprecExpense.toString(decPlaces: 10))
                items.append(annualExpense)
                runTotalDepreciation = runTotalDepreciation + currentDeprecExpense
                currentDeprecBalance = decBasis + runTotalDepreciation
            }
            
        }
    }
    
    func getMethodFactor(aDepreciationType: DepreciationType) -> Decimal {
        switch aDepreciationType {
        case .MACRS:
            return 2.0
        case .One_Fifty_DB:
            return 1.5
        case .One_Seventy_Five_DB:
            return 1.75
        default:
            return 1.0
        }
    }
    
    func getAdjustedBasis(aUnadjustedBasis: Decimal, basisReductionFactor: Decimal, percentITC: Decimal) -> Decimal {
        let decBasisReduction: Decimal = basisReductionFactor * percentITC * aUnadjustedBasis
        
        return aUnadjustedBasis - decBasisReduction
    }
    
    func getCurrentYearDepreciation(aBasis: Decimal, year: Int) -> Decimal {
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
    
    func getFirstYearDeprecExpense (aBasis: Decimal, decFactor: Decimal) -> Decimal {
        let myBasis: Decimal = aBasis - bonusDepreciation
        //print("\(bonusDepreciation.toString(decPlaces: 5))")
        let firstYearDeprec: Decimal = bonusDepreciation + (myBasis * decFactor * decMACRSFactor * decConvention)
        
        return firstYearDeprec
    }
    
    func getCurrentDeprec_DB (aBasis: Decimal, deprecFactor: Decimal) -> Decimal {
        let myCurrentDeprec_DB = aBasis * deprecFactor * decMACRSFactor
        
        return myCurrentDeprec_DB
    }
    
    func getCurrentDeprec_SL (aBasis: Decimal, year: Int) -> Decimal {
        let denominator: Decimal = Decimal(intLife) - Decimal(year) + (1 - decConvention)
        
        return aBasis / denominator
    }
    
    func getFiscalYearsOfLease(leaseExpiry: Date) -> Int {
        var x: Int = 1
        var currFiscalYearEnd: Date = firstFiscalYearEnd
        
        while leaseExpiry > currFiscalYearEnd {
            currFiscalYearEnd = addNextFiscalYearEnd(aDateIn: currFiscalYearEnd)
            x += 1
        }
        //x += 1 // for the fiscal year in which the lease matures
        
        return x
    }
    
    func setConventionFactor(aFiscalYearEnd: Date, dateInService: Date) {
        var conventionFactor: Decimal = 1.0
        
        switch myConventionType {
        case .halfYear:
            conventionFactor = 0.5
        case .midMonth:
            conventionFactor = getMidMonthFactor(dateFiscal: aFiscalYearEnd, inService: dateInService)
        case .midQuarter:
            conventionFactor = getMidQuarterFactor(dateFiscal: aFiscalYearEnd, inService: dateInService)
        }
        
        decConvention = conventionFactor
    }
    
    func getMidQuarterFactor(dateFiscal: Date, inService: Date) -> Decimal {
        let intFiscalQuarter: Int = getQuarterInService(dateFiscal: dateFiscal, inService: inService)
        
        return Decimal(4 - intFiscalQuarter) * 0.25 + 0.125
    }
    
    func getQuarterInService(dateFiscal: Date, inService: Date) -> Int {
        var intDiff = 0
        var decDiff: Decimal = 0.0
        let monthFiscal: Int = getMonthComponent(dateIn: dateFiscal)
        let monthInService: Int = getMonthComponent(dateIn: inService)
        
        if monthInService > monthFiscal {
            intDiff = monthInService - monthFiscal
        } else {
            intDiff = monthFiscal - monthInService + 12
        }
        decDiff = Decimal(intDiff) / 3.0 + 0.375
        
        return decDiff.toInteger()
    }
    
    func getMidMonthFactor (dateFiscal: Date, inService: Date) -> Decimal {
        let intMonthInService: Int = getMonthInService(dateFiscal: dateFiscal, inService: inService)
        let dayOfMonthInService: Int = getDayComponent(dateIn: inService)
        var halfMonthAdder: Int = 0
        
        if intMonthInService > 6 {
            if dayOfMonthInService > 15 {
                halfMonthAdder = 1
            } else {
                halfMonthAdder = 2
            }
        } else {
            if dayOfMonthInService <= 15 {
                halfMonthAdder = 1
            }
        }
        let factor = intMonthInService * 2 - halfMonthAdder  // 23
        let factor2 = Decimal(factor) * 100.0 / 24.0  // 23 x 4.1667
        let factor3 = 100.0 - factor2
        
        return factor3 / 100.0
    }
        
    func getMonthInService(dateFiscal: Date, inService: Date) -> Int {
        var intDiff = 0
        let monthFiscal: Int = getMonthComponent(dateIn: dateFiscal)
        let monthInService: Int = getMonthComponent(dateIn: inService)
        
        if monthInService > monthFiscal {
            intDiff = monthInService - monthFiscal
        } else {
            intDiff = monthFiscal - monthInService + 12
        }
        
        return intDiff
    }
    
}
       
    

