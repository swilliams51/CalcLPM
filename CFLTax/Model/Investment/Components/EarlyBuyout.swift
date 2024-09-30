//
//  EarlyBuyout.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


public struct EarlyBuyout {
    public var amount: String
    public var exerciseDate: Date
    public var advRentDueIsPaid: Bool = false
    
    init(amount: String, exerciseDate: Date, rentDueIsPaid: Bool) {
        self.amount = amount
        self.exerciseDate = exerciseDate
    }
    
    init() {
        self.amount = "0.00"
        self.exerciseDate = Date()
        self.advRentDueIsPaid = false
    }
    
    public func getEBOTermInMonths(aInvestment: Investment) -> Int {
        let noOfPaymentPeriods: Int = aInvestment.payPeriodsToChopDate(aInvestment: aInvestment, dateAsk: self.exerciseDate)
        
        return noOfPaymentPeriods * 12 / aInvestment.leaseTerm.paymentFrequency.rawValue
    }
    
}

extension Investment {
    
    
    
    public func resetEBOToDefault() {
        let leaseExpiry: Date = self.getLeaseMaturityDate()
        let frequency: Frequency = self.leaseTerm.paymentFrequency
        let noOfPeriods: Int = self.leaseTerm.paymentFrequency.rawValue
        let endDate: Date = subtractPeriodsFromDate(dateStart: leaseExpiry, payPerYear: frequency, noOfPeriods: noOfPeriods, referDate: self.leaseTerm.baseCommenceDate, bolEOMRule: self.leaseTerm.endOfMonthRule)
        self.earlyBuyout.exerciseDate = endDate
        
        let myTerminationValues: TerminationValues = TerminationValues()
        myTerminationValues.createTerminationValues(aInvestment: self)
        self.earlyBuyout.amount = myTerminationValues.vLookup(dateAsk: endDate).toString(decPlaces: 2)
    }
    
    public func getParValue(askDate: Date) -> Decimal {
        let myTVs: TerminationValues = TerminationValues()
        myTVs.createTerminationValues(aInvestment: self)
        let tvOnChopDate: Decimal = myTVs.vLookup(dateAsk: askDate)
        
        return tvOnChopDate
    }
    
    public func getExerciseDate(eboTermInMonths: Int) -> Date {
        let noOfPaymentPeriods: Int = eboTermInMonths * self.leaseTerm.paymentFrequency.rawValue / 12
        let myLeaseTemplate: LeaseTemplateCashflows = LeaseTemplateCashflows()
        myLeaseTemplate.createTemplate(aInvestment: self)
        
        let exerciseDate: Date = myLeaseTemplate.items[noOfPaymentPeriods - 1].dueDate
        
        return exerciseDate
    }
    
    
    public func getEBOPremium(aEBO: EarlyBuyout) -> Decimal {
        
        return 0.00
    }
    
    
   //public func getEBOAmount
    
    public func solveForEBOAmount(aTargetYield: Decimal) -> Decimal {
        let myEBOInvestment: Investment = self.clone()
        let dateOfUnplanned: Date = myEBOInvestment.earlyBuyout.exerciseDate
        let myPlannedIncome: Decimal = plannedIncome(aInvestment: myEBOInvestment, dateAsk: dateOfUnplanned)
        myEBOInvestment.rent = eboRent(aInvestment: myEBOInvestment, chopDate: dateOfUnplanned)
        myEBOInvestment.economics.yieldTarget = aTargetYield.toString(decPlaces: 6)
        myEBOInvestment.economics.solveFor = .residualValue
        myEBOInvestment.calculate(plannedIncome: myPlannedIncome.toString(decPlaces: 5), unplannedDate: dateOfUnplanned)
    
        return myEBOInvestment.asset.residualValue.toDecimal()
    }
    
    public func solveForEBOYield(aEBO: EarlyBuyout) -> Decimal {
        let myEBOInvestment: Investment = self.clone()
        let dateOfUnplanned: Date = myEBOInvestment.earlyBuyout.exerciseDate
        let myPlannedIncome: Decimal = plannedIncome(aInvestment: myEBOInvestment, dateAsk: dateOfUnplanned)
        myEBOInvestment.rent = eboRent(aInvestment: myEBOInvestment, chopDate: dateOfUnplanned)
        myEBOInvestment.asset.residualValue = aEBO.amount
        myEBOInvestment.economics.solveFor = .yield
        myEBOInvestment.calculate(plannedIncome: myPlannedIncome.toString(decPlaces: 5), unplannedDate: dateOfUnplanned)
        
        return myEBOInvestment.getMISF_AT_Yield()
    }
    
    public func eboResidual(aInvestment: Investment) -> Decimal {
        let myTVs: TerminationValues = TerminationValues()
        myTVs.createTerminationValues(aInvestment: aInvestment)
        let tvOnChopDate: Decimal = myTVs.vLookup(dateAsk: aInvestment.earlyBuyout.exerciseDate)
        return tvOnChopDate
    }
    
    public func eboRent(aInvestment: Investment, chopDate: Date) -> Rent {
        var noOfPeriodsInBaseTerm: Int = payPeriodsToChopDate(aInvestment: aInvestment, dateAsk: chopDate)
        var myRent: Rent = Rent()
        var start: Int = 0
        if aInvestment.rent.groups[0].isInterim {
            myRent.groups.append(aInvestment.rent.groups[0])
            start = 1
        }
    
        for x in start..<aInvestment.rent.groups.count {
            var group: Group = aInvestment.rent.groups[x] //
            let x = group.noOfPayments //24
            if x >= noOfPeriodsInBaseTerm { //24>12
                group.noOfPayments = noOfPeriodsInBaseTerm
                myRent.groups.append(group)
            } else {
                myRent.groups.append(group)
                noOfPeriodsInBaseTerm = noOfPeriodsInBaseTerm - group.noOfPayments //60-24=36, 36-24=12
            }
        }
        
        return myRent
    }
    
    public func payPeriodsToChopDate(aInvestment: Investment, dateAsk: Date) -> Int {
        var dateStart = aInvestment.rent.groups[0].startDate
        if aInvestment.rent.groups[0].isInterim {
            dateStart = aInvestment.rent.groups[0].endDate
        }
        
        var counter = 0
        while dateStart < dateAsk {
            dateStart = addOnePeriodToDate(dateStart: dateStart, payPerYear: aInvestment.leaseTerm.paymentFrequency, dateRefer: dateStart, bolEOMRule: aInvestment.leaseTerm.endOfMonthRule)
            counter += 1
        }
        
        return counter
    }
    
   public func plannedIncome(aInvestment: Investment, dateAsk: Date) -> Decimal {
       let fiscalYearEnd: Date = getFiscalYearEnd(askDate: dateAsk, fiscalMonthEnd: aInvestment.taxAssumptions.fiscalMonthEnd.rawValue)
       let myAnnualTaxableIncomes: AnnualTaxableIncomes = AnnualTaxableIncomes()
       let myNetTaxableIncomes: Cashflows = myAnnualTaxableIncomes.createNetTaxableIncomes(aInvestment: aInvestment)
       let decPlannedIncome: Decimal = myNetTaxableIncomes.vLookup(dateAsk: fiscalYearEnd)
       
       return decPlannedIncome
    }
    
}
