//
//  Examples.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


//Simple - 5 year monthly pay,  no interim, 20% residual, 5 yr MACRs
public let baseCommencementDate: Date = Date()
public let leaseFundingDate: Date = Date()
public let simpleLeaseTerm: LeaseTerm = LeaseTerm(baseCommenceDate: Date(), paymentFrequency: .monthly)
public let simpleAsset: Asset = Asset(name: "Freightliner Tractor", fundingDate: Date(), lessorCost: "100000.00", residualValue: "20000.00")
public let simpleRent: Rent = Rent(groups: [simpleGroup])
public let simpleGroup: Group =  Group(amount: "8500.75", endDate: addPeriodsToDate(dateStart: baseCommencementDate, payPerYear: .monthly, noOfPeriods: 60, referDate: baseCommencementDate, bolEOMRule: false), locked: false, noOfPayments: 60, startDate: baseCommencementDate, timing: .arrears, paymentType: .baseRental, isInterim: false, unDeletable: true)
public let simpleDepreciation: Depreciation = Depreciation(basisReduction: 0.0, bonusDeprecPercent: 0.00, convention: .halfYear, life: 5, method: .MACRS, investmentTaxCredit: 0.0, salvageValue: "0.00", vestingPeriod: 5)
public let simpleTaxAssumptions: TaxAssumptions = TaxAssumptions(federalTaxRate: "0.21", fiscalMonthEnd: .December, dayOfMonPaid: 15)
public let simpleEconomics: Economics = Economics(yieldMethod: .MISF_BT, yieldTarget: "0.05", solveFor: .unLockedRentals, dayCountMethod: .actualThreeSixty, discountRateForRent: "0.065")
public let simpleFee: Fee = Fee(amount: "2000.00", datePaid: "08/12/24".toDate())



public let simple2LeaseTerm: LeaseTerm = LeaseTerm(baseCommenceDate: "01/15/25".toDate(), paymentFrequency: .semiannual)
public let simple2Asset: Asset = Asset(name: "Freightliner Tractor", fundingDate: "12/15/24".toDate(), lessorCost: "100000.00", residualValue: "20000.00")
public let simple2Rent: Rent = Rent(groups: [simple2Group1, simple2Group2])
public let simple2Group1: Group = Group(amount: "7600.00", endDate: "01/15/25".toDate(), locked: false, noOfPayments: 1, startDate: "12/15/24".toDate(), timing: .arrears, paymentType: .specified, isInterim: true, unDeletable: true)
public let simple2Group2: Group =  Group(amount: "10135.00", endDate: addPeriodsToDate(dateStart: "01/15/25".toDate(), payPerYear: .semiannual, noOfPeriods: 10, referDate: "01/15/25".toDate(), bolEOMRule: false), locked: false, noOfPayments: 10, startDate: "01/15/25".toDate(), timing: .arrears, paymentType: .baseRental, isInterim: false, unDeletable: true)




public let leaseTermEx1: LeaseTerm = LeaseTerm(baseCommenceDate: baseCommencementDate, paymentFrequency: .monthly)
//Asset
public let assetEx1: Asset = Asset(name: "Freightliner Tractor", fundingDate: Date(), lessorCost: "100000.00", residualValue: "20000.00")

//Depreciation
public let taxAssumptionsEx1: TaxAssumptions = TaxAssumptions(federalTaxRate: "21.00", fiscalMonthEnd: .December, dayOfMonPaid: 15)

//Rent
public let rentEx1: Rent = Rent(groups: [interimEx1, baseRentEx1])

//Group
public let interimEx1: Group = Group(amount: "CALCULATED", endDate: baseCommencementDate, locked: false, noOfPayments: 1, startDate: leaseFundingDate, timing: .arrears, paymentType: .dailyEquivAll, isInterim: true, unDeletable: true)
public let baseRentEx1: Group = Group(amount: "1850.75", endDate: addPeriodsToDate(dateStart: baseCommencementDate, payPerYear: .monthly, noOfPeriods: 60, referDate: baseCommencementDate, bolEOMRule: false), locked: false, noOfPayments: 60, startDate: baseCommencementDate, timing: .arrears, paymentType: .baseRental, isInterim: false, unDeletable: true)

//Depreciation
public let depreciationEx1: Depreciation = Depreciation(basisReduction: 0.00, bonusDeprecPercent: 0.00, convention: .halfYear, life: 3, method: .MACRS, investmentTaxCredit: 0.00, salvageValue: "0.00", vestingPeriod: 3)
public let depreciationEx2: Depreciation = Depreciation(basisReduction: 0.0, bonusDeprecPercent: 0.00, convention: .halfYear, life: 5, method: .MACRS, investmentTaxCredit: 0.0, salvageValue: "0.00", vestingPeriod: 5)
public let depreciationEx3: Depreciation = Depreciation(basisReduction: 0.0, bonusDeprecPercent: 0.5, convention: .halfYear, life: 5, method: .MACRS, investmentTaxCredit: 0.0, salvageValue: "0.00", vestingPeriod: 5)

public let economicsEx1: Economics = Economics(yieldMethod: .MISF_BT, yieldTarget: "0.05", solveFor: .unLockedRentals, dayCountMethod: .actualThreeSixty, discountRateForRent: "0.065")

public let fee1: Fee = Fee(amount: "20000.00", datePaid: leaseFundingDate)

public let eboEx1: EarlyBuyout = EarlyBuyout(amount: "42000.00", exerciseDate: addPeriodsToDate(dateStart: baseCommencementDate, payPerYear: .monthly, noOfPeriods: 48, referDate: baseCommencementDate, bolEOMRule: true), rentDueIsPaid: true)
