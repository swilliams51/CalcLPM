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
    public var arrearsRentDueIsPaid: Bool = false
    
    // advance rents are never due but are incorporated into termination values so they must be backed out
    // arrears rents can be paid or not paid.  If paid the TV must be reduced by the amount of the arrears rent
    // the sum of the arrears rent and TV paid by the lessee must equal the calculated TV
    // arrears rent + (TV - arrears rent) = calculated TV
    
    init(amount: String, exerciseDate: Date, rentDueIsPaid: Bool) {
        self.amount = amount
        self.exerciseDate = exerciseDate
    }
    
    init() {
        self.amount = "0.00"
        self.exerciseDate = Date()
        self.arrearsRentDueIsPaid = false
    }
    
    public func getEBOTermInMonths(aInvestment: Investment) -> Int {
        let noOfPaymentPeriods: Int = aInvestment.payPeriodsToChopDate(aInvestment: aInvestment, dateAsk: self.exerciseDate)
        
        return noOfPaymentPeriods * 12 / aInvestment.leaseTerm.paymentFrequency.rawValue
    }
    
    func isEqual(to other: EarlyBuyout) -> Bool {
        var isEqual: Bool = false
        if self.amount == other.amount &&
            self.exerciseDate == other.exerciseDate &&
            self.arrearsRentDueIsPaid == other.arrearsRentDueIsPaid {
            isEqual = true
        }
        
        return isEqual
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
        myTerminationValues.createTable(aInvestment: self)
        let myCFTValues: Cashflows = myTerminationValues.createTerminationValues(arrearsRentDueIsPaid: true)
        self.earlyBuyout.amount = myCFTValues.vLookup(dateAsk: endDate).toString(decPlaces: 2)
    }
    
    public func getParValue(askDate: Date) -> Decimal {
        let myTVs: TerminationValues = TerminationValues()
        myTVs.createTable(aInvestment: self)
        let myCFTValues: Cashflows = myTVs.createTerminationValues(arrearsRentDueIsPaid: true)
        let tvOnChopDate: Decimal = myCFTValues.vLookup(dateAsk: askDate)
        
        return tvOnChopDate
    }
    
    public func getExerciseDate(eboTermInMonths: Int) -> Date {
        let noOfPaymentPeriods: Int = eboTermInMonths * self.leaseTerm.paymentFrequency.rawValue / 12
        let myLeaseTemplate: LeaseTemplateCashflows = LeaseTemplateCashflows()
        myLeaseTemplate.createTemplate(aInvestment: self)
        
        let exerciseDate: Date = myLeaseTemplate.items[noOfPaymentPeriods - 1].dueDate
        
        return exerciseDate
    }
    
    
    public func getEBOPremium_bps(aEBO: EarlyBuyout, aBaseYield: Decimal) -> Double {
        let eboYield: Decimal = solveForEBOYield(aEBO: aEBO)
        let eboPremium: Decimal = eboYield - aBaseYield
        let eboPremiumBps: Double = (eboPremium * 10000.00).toDouble()
        
        return eboPremiumBps
    }
    
    
   //public func getEBOAmount
    
    public func solveForEBOAmount(aEBO: EarlyBuyout, aBaseYield: Decimal, bpsSpread: Double) -> Decimal {
        let adder: Decimal = Decimal(bpsSpread) / 10000.00
        let targetYield: Decimal = aBaseYield + adder
        
        return solveForEBOAmount(aEBO: aEBO, aTargetYield: targetYield)
    }
    
    public func solveForEBOAmount(aEBO: EarlyBuyout, aTargetYield: Decimal) -> Decimal {
        let myEBOInvestment: Investment = self.clone()
        let dateOfUnplanned: Date = myEBOInvestment.earlyBuyout.exerciseDate
        let myPlannedIncome: Decimal = plannedIncome(aInvestment: myEBOInvestment, dateAsk: dateOfUnplanned)
        myEBOInvestment.rent = eboRent(aInvestment: myEBOInvestment, chopDate: dateOfUnplanned)
        myEBOInvestment.economics.yieldMethod = .MISF_BT
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
        myEBOInvestment.economics.yieldMethod = .MISF_BT
        myEBOInvestment.asset.residualValue = aEBO.amount
        myEBOInvestment.economics.solveFor = .yield
        myEBOInvestment.calculate(plannedIncome: myPlannedIncome.toString(decPlaces: 5), unplannedDate: dateOfUnplanned)
        
        return myEBOInvestment.getMISF_BT_Yield()
    }
    
    public func eboResidual(aInvestment: Investment) -> Decimal {
        let myTVs: TerminationValues = TerminationValues()
        myTVs.createTable(aInvestment: aInvestment)
        let myTValues: Cashflows = myTVs.createTerminationValues()
        let tvOnChopDate: Decimal = myTValues.vLookup(dateAsk: aInvestment.earlyBuyout.exerciseDate)
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
