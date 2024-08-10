//
//  Enums.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


public enum SolveForOption {
    case afterTaxMISF
    case beforeTaxMISF
    case fee
    case implicitRate
    case irrPTCF
    case presentValueOfRents
    case residualValue
    case unLockedRentals
    
   
    static let yields: [SolveForOption]  = [.afterTaxMISF, .beforeTaxMISF, .irrPTCF]
    static let amounts: [SolveForOption] = [.fee, .implicitRate, .presentValueOfRents, .residualValue, .unLockedRentals]
    
}


public enum YieldType {
    case MISF_AT
    case MISF_BT
    case IRR_PTCF
    case implicitRate
    
    public func toString() -> String {
        switch self {
        case .IRR_PTCF:
            return "Pre-tax IRR"
        case .MISF_AT:
            return "MISF A/T"
        case .MISF_BT:
            return "MISF B/T"
        default:
            return "Implicit Rate"
        }
    }
    
    
    static let allTypes: [YieldType] = [.IRR_PTCF,.MISF_AT,.MISF_BT,.implicitRate]
}

public enum TaxYearEnd: Int {
    case January = 1
    case February = 2
    case March = 3
    case April = 4
    case May = 5
    case June = 6
    case July = 7
    case August = 8
    case September = 9
    case October = 10
    case November = 11
    case December = 12

    
    static let allCases: [TaxYearEnd] = [.January, .February, .March, .April, .May, .June, .July, .August, .September, .October, .November, .December]
}

public enum ConventionType {
    case halfYear
    case midMonth
    case midQuarter
    
    public func toString() -> String {
        switch self {
        case .halfYear:
            return " Half Year"
        case .midMonth:
            return "Mid-Month"
        default:
            return "Mid-Quarter"
        }
    }
    
    static let allCases: [ConventionType] = [.halfYear, .midMonth, .midQuarter]
}

public enum DayCountMethod: Int {
    case thirtyThreeSixty
    case actualThreeSixtyFive
    case actualActual
    case actualThreeSixty
    
    func toString() -> String {
        switch self {
        case .thirtyThreeSixty:
            return "30/360"
        case .actualThreeSixtyFive:
            return "Actual/365"
        case .actualActual:
            return "Actual/Actual"
        case .actualThreeSixty:
            return "Actual/360"
        }
    }
    
    func toInt() -> Int {
        return self.rawValue
    }
    
    static let allTypes: [DayCountMethod] = [.thirtyThreeSixty, .actualThreeSixty, .actualActual, .actualThreeSixty]
}


public enum DepreciationType {
    case MACRS
    case One_Fifty_DB
    case One_Seventy_Five_DB
    case StraightLine
    
    public func toString() -> String {
        switch self{
        case .MACRS:
            return "MACRS"
        case .One_Fifty_DB:
            return "One Fifty DB"
        case .One_Seventy_Five_DB:
            return "One SeventyFive DB"
        case .StraightLine:
            return "Straightline"
        }
    }
    
    static let allTypes: [DepreciationType] = [.MACRS, .One_Fifty_DB, .One_Seventy_Five_DB, .StraightLine]
}

public enum FeeType{
    case expense
    case income
    
    public func toString() -> String {
        switch self{
        case .expense:
            return "Expense"
        case .income:
            return "Income"
        }
    }
    
    static let allTypes: [FeeType] = [.expense, .income]
}

public enum Frequency: Int, CaseIterable {
    case monthly = 12
    case quarterly = 4
    case semiannual = 2
    case annual = 1
    
    func toString () -> String {
        switch self {
        case .monthly:
            return "Monthly"
        case .quarterly:
            return "Quarterly"
        case .semiannual:
            return "Semiannual"
        case .annual:
            return "Annual"
        }
        
    }
    
    static let three: [Frequency] = [.monthly, .quarterly, .semiannual]
    static let two: [Frequency] = [.monthly, .quarterly]
    static let one: [Frequency] = [.monthly]
}

public enum InterimRentType {
    case dailyEquivAll
    case dailyEquivNext
    case interestOnly
    case specified
    
    func toString() -> String {
        switch self {
        case .dailyEquivAll:
            return "DeAll"
        case .dailyEquivNext:
            return "DeNext"
        case .interestOnly:
            return " Interest Only"
        default:
            return "Specified"
        }
    }
    
    static let allTypes: [InterimRentType] = [.dailyEquivAll, .dailyEquivNext, .interestOnly, .specified]
}

public enum PaymentType {
    case dailyEquivAll
    case dailyEquivNext
    case baseRental
    case specified
    
    func toString() -> String {
        switch self {
        case .dailyEquivAll:
            return "DeAll"
        case .dailyEquivNext:
            return "DeNext"
        case .baseRental:
            return "Basic Rent"
        default:
            return "Specified"
        }
    }
    
    static let allTypes: [PaymentType] = [.dailyEquivAll, .dailyEquivNext, .baseRental, .specified]
    static let interimTypes: [PaymentType] = [.dailyEquivAll, .dailyEquivNext, .specified]
    static let baseTermTypes: [PaymentType] = [.baseRental]
    
}

public enum TimingType {
    case advance
    case arrears
    case equals
    
    func toString () -> String {
        switch self {
        case .advance:
            return "Advance"
        case .arrears:
            return "Arrears"
        default:
            return "Equals"
        }
    }
    
    static let nonResidualPayments: [TimingType] = [.advance, .arrears]
}



public func getMethodFactor(aDepreciationType: DepreciationType) -> Decimal {
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

public func getConventionFactor(aConvention: ConventionType, dateFiscalYearEnd: Date, inServiceDate: Date) -> Decimal{
    var returnFactor: Decimal = 1.0
    
    switch aConvention {
    case .halfYear:
        returnFactor = 0.5
    case .midMonth:
        returnFactor = getMidMonthFactor(dateFiscalYearEnd: dateFiscalYearEnd, inServiceDate: inServiceDate)
    case .midQuarter:
        returnFactor = getMidQuarterFactor(dateFiscalYearEnd: dateFiscalYearEnd, inServiceDate: inServiceDate)
    }
    
    return returnFactor
}


public func getMidMonthFactor(dateFiscalYearEnd: Date, inServiceDate: Date) -> Decimal {
    let monthInService: Int = getMonthInService(dateFiscalYearEnd: dateFiscalYearEnd, inServiceDate: inServiceDate)
    let myFactor: Decimal = 1.0 - (Decimal(monthInService) / 12.0)
    
    return myFactor
}

private func getMonthInService(dateFiscalYearEnd: Date, inServiceDate: Date) -> Int {
    var diffA: Int = 0
    let fiscalMonth: Int = getMonthComponent(dateIn: dateFiscalYearEnd)
    let inServiceMonth: Int = getMonthComponent(dateIn: inServiceDate)
    
    if inServiceMonth > fiscalMonth{
        diffA = inServiceMonth - fiscalMonth
    } else {
        diffA = inServiceMonth - fiscalMonth + 12
    }
    
    return diffA
}

private func getMidQuarterFactor(dateFiscalYearEnd: Date, inServiceDate: Date) -> Decimal {
    let fiscalQuarter: Int = getQuarterInService(dateFiscalYearEnd: dateFiscalYearEnd, inServeDate: inServiceDate)
    
    return Decimal(4 - fiscalQuarter) * 0.25 + 0.125
}

private func getQuarterInService(dateFiscalYearEnd: Date, inServeDate: Date) -> Int {
    var diffA: Int = 0
    let fiscalMonth: Int = getMonthComponent(dateIn: dateFiscalYearEnd)
    let inServiceMonth: Int = getMonthComponent(dateIn: inServeDate)
    
    if inServiceMonth > fiscalMonth{
        diffA = inServiceMonth - fiscalMonth
    } else {
        diffA = inServiceMonth - fiscalMonth + 12
    }
    let diffB: Decimal = Decimal(diffA) / 3 + 0.375
    
    return diffB.toInteger()
    
}
