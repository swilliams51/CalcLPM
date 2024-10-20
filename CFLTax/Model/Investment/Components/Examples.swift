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
public let simpleEconomics: Economics = Economics(yieldMethod: .MISF_BT, yieldTarget: "0.05", solveFor: .yield, dayCountMethod: .actualThreeSixty, discountRateForRent: "0.065")
public let simpleFee: Fee = Fee(amount: "2000.00", feeType: .expense, datePaid: "08/12/24".toDate())
public let simpleEBO: EarlyBuyout = EarlyBuyout(amount: "0.00", exerciseDate: leaseFundingDate, rentDueIsPaid: true)


//Simple2 - use this one
public let simple2Asset: Asset = Asset(name: "Freightliner Tractor", fundingDate: "12/15/2024".toDate(), lessorCost: "100000.00", residualValue: "20000.00", lesseeGuarantyAmount: "0.00", thirdPartyGuarantyAmount: "0.00")
public let simple2LeaseTerm: LeaseTerm = LeaseTerm(baseCommenceDate: "01/15/2025".toDate(), paymentFrequency: .semiannual, eomRule: false)
public let simple2Rent: Rent = Rent(groups: [simple2Group1, simple2Group2])
public let simple2Group1: Group = Group(amount: "7600.00", endDate: "01/15/2025".toDate(), locked: false, noOfPayments: 1, startDate: "12/15/2024".toDate(), timing: .arrears, paymentType: .specified, isInterim: true, unDeletable: true)
public let simple2Group2: Group =  Group(amount: "10135.00", endDate: "01/15/2030".toDate(), locked: false, noOfPayments: 10, startDate: "01/15/2025".toDate(), timing: .arrears, paymentType: .baseRental, isInterim: false, unDeletable: true)
public let simple2Depreciation: Depreciation = Depreciation(basisReduction: 0.00, bonusDeprecPercent: 0.00, convention: .halfYear, life: 3, method: .MACRS, investmentTaxCredit: 0.00, salvageValue: "0.00", vestingPeriod: 5)
public let simple2TaxAssumptions: TaxAssumptions = TaxAssumptions(federalTaxRate: "0.21", fiscalMonthEnd: .December, dayOfMonPaid: 15)
public let simple2Economics: Economics = Economics(yieldMethod: .MISF_BT, yieldTarget: "0.05", solveFor: .yield, dayCountMethod: .thirtyThreeSixty, discountRateForRent: "0.065", sinkingFundRate: "0.00")
public let simple2Fee: Fee = Fee(amount: "2000.00", feeType: .expense, datePaid: "12/15/2024".toDate())
public let simple2EBO: EarlyBuyout = EarlyBuyout(amount: "0.00", exerciseDate: "01/15/2030".toDate(),rentDueIsPaid: false)


