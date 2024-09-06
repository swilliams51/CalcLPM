//
//  Investment.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


@Observable
public class Investment {
    var asset: Asset = simple2Asset
    var leaseTerm: LeaseTerm = simple2LeaseTerm
    var rent: Rent = simple2Rent
    var depreciation: Depreciation = simple2Depreciation
    var taxAssumptions: TaxAssumptions = simple2TaxAssumptions
    var economics: Economics = simple2Economics
    var fee: Fee = simple2Fee
    var earlyBuyout: EarlyBuyout = simple2EBO
    var afterTaxCashflows: Cashflows = Cashflows()
    var beforeTaxCashflows: Cashflows = Cashflows()
    var earlyBuyoutExists: Bool = false
    var feeExists: Bool = false
    
   public init() {
        self.asset = asset
        self.leaseTerm = leaseTerm
        self.rent = rent
        self.depreciation = depreciation
        self.taxAssumptions = taxAssumptions
        self.economics = economics
        self.fee = fee
        self.earlyBuyout = earlyBuyout
        self.setEBO()
        self.setFee()
    }
    
    public init(aAsset: Asset, aLeaseTerm: LeaseTerm, aRent: Rent, aDepreciation: Depreciation, aTaxAssumptions: TaxAssumptions, aEconomics: Economics, aFee: Fee, aEarlyBuyout: EarlyBuyout) {
        self.asset = aAsset
        self.leaseTerm = aLeaseTerm
        self.rent = aRent
        self.depreciation = aDepreciation
        self.taxAssumptions = aTaxAssumptions
        self.economics = aEconomics
        self.fee = aFee
        self.earlyBuyout = aEarlyBuyout
        self.setEBO()
        self.setFee()
    }
    
    public init(aFile: String) {
        let arrayInvestment: [String] = aFile.components(separatedBy: "*")
        self.asset = readAsset(arrayAsset: arrayInvestment[0].components(separatedBy: ","))
        self.leaseTerm = readLeaseTerm(arrayLeaseTerm: arrayInvestment[1].components(separatedBy: ","))
        self.rent = readRent(arrayGroups: arrayInvestment[2].components(separatedBy: "|"))
        self.depreciation = readDepreciation(arrayDepreciation: arrayInvestment[3].components(separatedBy: ","))
        self.taxAssumptions = readTaxAssumptions(arrayTaxAssumptions: arrayInvestment[4].components(separatedBy: ","))
        self.economics = readEconomics(arrayEconomics: arrayInvestment[5].components(separatedBy: ","))
        self.fee = readFee(arrayFee: arrayInvestment[6].components(separatedBy: ","))
        self.earlyBuyout = readEarlyBuyout(arrayEBO: arrayInvestment[7].components(separatedBy: ","))
        self.setEBO()
        self.setFee()
    }
    
    public func setEBO() {
        if earlyBuyout.amount.toDecimal() != 0.0 {
            earlyBuyoutExists = true
        } else {
            earlyBuyoutExists = false
        }
    }
    
    public func setFee() {
        if self.getFeeAmount() != 0.0 {
            self.feeExists = true
        } else {
            self.feeExists = false
        }
    }
    
    public func getBaseTermInMonths() -> Int {
        var runTotalPeriods: Int = 0
        
        for x in 0..<rent.groups.count {
            if rent.groups[x].isInterim == false {
                let numberOfPeriods = rent.groups[x].noOfPayments
                runTotalPeriods = runTotalPeriods + numberOfPeriods
            }
        }
        
        return runTotalPeriods * 12 / leaseTerm.paymentFrequency.rawValue
    }
    
    public func getLeaseMaturityDate() -> Date {
         return addPeriodsToDate(dateStart: leaseTerm.baseCommenceDate, payPerYear: .monthly, noOfPeriods: getBaseTermInMonths(), referDate: leaseTerm.baseCommenceDate, bolEOMRule: false)
    }
    
    public func clone() -> Investment {
        let strInvestment = self.writeInvestment()
        let investmentClone: Investment = readInvestment(file: strInvestment)
        
        return investmentClone
    }
    
    public func yieldCalculationIsValid() -> Bool {
        var isValid: Bool = true
        let tempInvestment: Investment = self.clone()
        
        tempInvestment.setAfterTaxCashflows()
        if tempInvestment.afterTaxCashflows.getTotal() < 0 {
            isValid = false
        }
        tempInvestment.afterTaxCashflows.removeAll()
        
        tempInvestment.setBeforeTaxCashflows()
        if tempInvestment.beforeTaxCashflows.getTotal() < 0 {
            isValid = false
        }
        tempInvestment.beforeTaxCashflows.removeAll()
        
        return isValid
    }
    
    public func calculate() {
        let aYieldType: YieldMethod = self.economics.yieldMethod
        let aTargetYield: Decimal = self.economics.yieldTarget.toDecimal()
        
        switch self.economics.solveFor {
        case .fee:
            solveForFee(aYieldMethod: aYieldType, aTargetYield: aTargetYield)
        case .lessorCost:
            solveForLessorCost(aYieldMethod: aYieldType, aTargetYield: aTargetYield)
        case .residualValue:
            solveForResidual(aYieldMethod: aYieldType, aTargetYield: aTargetYield)
        case .unLockedRentals:
            solveForPaymentsV2(aYieldMethod: aYieldType, aTargetYield: aTargetYield)
        default:
            break
        }
        
        setAfterTaxCashflows()
        setBeforeTaxCashflows()
    }
    
    public func setAfterTaxCashflows() {
        //if setAfterTaxCashflows is not called to the calculate function then items in afterTaxCashflows must e removed
        let myATCollCashflows: NetAfterTaxCashflows = NetAfterTaxCashflows()
        
        let myTempCashflows = myATCollCashflows.createNetAfterTaxCashflows(aInvestment: self)
        if afterTaxCashflows.count() > 0 {
            afterTaxCashflows.removeAll()
        }
        for x in 0..<myTempCashflows.count() {
            afterTaxCashflows.add(item: myTempCashflows.items[x])
        }
    }
    
    public func setBeforeTaxCashflows() {
        //if setBeforeTaxCashflows is not called to the calculate function then items in beforeTaxCashflows must e removed
        let myBTCollCashflows: PeriodicLeaseCashflows = PeriodicLeaseCashflows()
        let myTempCashflows: Cashflows = myBTCollCashflows.createPeriodicLeaseCashflows(aInvestment: self, lesseePerspective: false)
        if beforeTaxCashflows.count() > 0 {
            beforeTaxCashflows.removeAll()
        }
        for x in 0..<myTempCashflows.count() {
            beforeTaxCashflows.add(item: myTempCashflows.items[x])
        }
    }
    
    
    public func getMISF_AT_Yield () -> Decimal{
        var atYield: Decimal = 0.0
        if afterTaxCashflows.count() > 0 {
            atYield = afterTaxCashflows.XIRR2(guessRate: 0.1, _DayCountMethod: self.economics.dayCountMethod)
        }
        
        return atYield
    }
        
    public func getMISF_BT_Yield () -> Decimal{
        return getMISF_AT_Yield() / (1.0 - self.taxAssumptions.federalTaxRate.toDecimal())
        }
    
    public func getIRR_PTCF() -> Decimal{
        var pretaxIRR: Decimal = 0.0
        if beforeTaxCashflows.count() > 0 {
            pretaxIRR = beforeTaxCashflows.XIRR2(guessRate: 0.1, _DayCountMethod: self.economics.dayCountMethod)
        }
        
        return pretaxIRR
    }
    
    public func getAssetCost(asCashflow: Bool) -> Decimal {
        var factor: Decimal = 1.0
        if asCashflow {
            factor = -1.0
        }
        return self.asset.lessorCost.toDecimal() * factor
    }
    
    public func getFeeAmount() -> Decimal {
        if self.fee.amount.isEmpty {
            return 0.0
        }
        var factor: Decimal = 1.0
        if self.fee.feeType == .expense {
            factor = -1.0
        }
        
        return fee.amount.toDecimal() * factor
    }
    
    public func getTotalRent() -> String {
        let tempCashflow = RentalCashflows()
        tempCashflow.createTable(aRent: self.rent, aLeaseTerm: self.leaseTerm, aAsset: self.asset, eomRule: self.leaseTerm.endOfMonthRule)
        
        return tempCashflow.getTotal().toString(decPlaces: 10)
    }
    
     public func getAssetResidualValue() -> Decimal {
         return self.asset.residualValue.toDecimal()
    }
    
    public func getAfterTaxCash() -> String {
        return afterTaxCashflows.getTotal().toString(decPlaces: 10)
    }
    
    public func getBeforeTaxCash() -> String {
        return beforeTaxCashflows.getTotal().toString(decPlaces: 10)
    }
    
    public func getTaxesPaid() -> String {
        let tempCashflow = AnnualTaxableIncomes()
        let taxesPaid = tempCashflow.createPeriodicTaxesPaid_STD(aInvestment: self)
        
        return taxesPaid.getTotal().toString(decPlaces: 10)
    }
    
    public func getImplicitRate() -> Decimal {
        let tempLeaseCashflow = PeriodicLeaseCashflows()
        let myCashflows: Cashflows = tempLeaseCashflow.createPeriodicLeaseCashflows(aInvestment: self, lesseePerspective: true)
        
        return myCashflows.XIRR2(guessRate: 0.10, _DayCountMethod: self.economics.dayCountMethod)
    }
    
    public func getPVOfRents() -> Decimal{
        let tempCashflow = RentalCashflows()
        tempCashflow.createTable(aRent: self.rent, aLeaseTerm: self.leaseTerm, aAsset: self.asset, eomRule: self.leaseTerm.endOfMonthRule)
        
        let pvOfRents: Decimal = tempCashflow.XNPV(aDiscountRate: self.economics.discountRateForRent.toDecimal(), aDayCountMethod: self.economics.dayCountMethod)
        
        return pvOfRents
    }
    
    public func getPVOfObligations() -> Decimal{
        let tempCashflow = RentalCashflows()
        tempCashflow.createTable(aRent: self.rent, aLeaseTerm: self.leaseTerm, aAsset: self.asset, eomRule: self.leaseTerm.endOfMonthRule)
        let leaseEndDate: Date = self.getLeaseMaturityDate()
        let residualGuaranty: Decimal = self.asset.lesseeGuarantyAmount.toDecimal()
        let additionalCF: Cashflow = Cashflow(dueDate: leaseEndDate, amount: residualGuaranty.toString(decPlaces: 4))
        tempCashflow.add(item: additionalCF)
        tempCashflow.consolidateCashflows()
        
        let pvOfObligations: Decimal = tempCashflow.XNPV(aDiscountRate: self.economics.discountRateForRent.toDecimal(), aDayCountMethod: self.economics.dayCountMethod)
        
        return pvOfObligations
    }
    
}

    
   

