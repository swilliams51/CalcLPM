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
    public var advRentDueIsPaid: Bool
    
    
    init(amount: String, exerciseDate: Date, rentDueIsPaid: Bool) {
        self.amount = amount
        self.exerciseDate = exerciseDate
        self.advRentDueIsPaid = rentDueIsPaid
    }
    
    init() {
        self.amount = "0.00"
        self.exerciseDate = Date()
        self.advRentDueIsPaid = false
    }
    
}

extension Investment {
    
    public func getParValue(askDate: Date, rentToBePaid: Bool = false) -> Decimal {
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
    
    public func modifyInvestmentToEBO(aEBO: EarlyBuyout) -> Investment {
        let myEBOInvestment = self.clone()
        let myTVs: TerminationValues = TerminationValues()
        myTVs.createTerminationValues(aInvestment: myEBOInvestment)
        let tvOnChopDate: Decimal = myTVs.vLookup(dateAsk: aEBO.exerciseDate)
        
        // modify the rents
        myEBOInvestment.rent = self.choppedRents(aInvestment: self, chopDate: aEBO.exerciseDate)
        // modify the residual
        myEBOInvestment.asset.residualValue = tvOnChopDate.toString(decPlaces: 5)
        
        return myEBOInvestment
    }
    
    public func choppedRents(aInvestment: Investment, chopDate: Date) -> Rent {
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
        while dateStart <= dateAsk {
            dateStart = addOnePeriodToDate(dateStart: dateStart, payPerYear: aInvestment.leaseTerm.paymentFrequency, dateRefer: aInvestment.leaseTerm.baseCommenceDate, bolEOMRule: aInvestment.leaseTerm.endOfMonthRule)
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
