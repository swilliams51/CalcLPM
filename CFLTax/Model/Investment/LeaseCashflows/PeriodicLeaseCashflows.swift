//
//  PeriodicLeaseCashflows.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation

@Observable
public class PeriodicLeaseCashflows: CollCashflows {
    public var myLeaseTemplate: Cashflows = Cashflows()
    var myAssetCashflows: AssetCashflows = AssetCashflows()
    var myRentalCashflows: RentalCashflows = RentalCashflows()
    var myResidualCashflows: ResidualCashflows = ResidualCashflows()
    
    public func createTable(aInvestment: Investment, lesseePerspective: Bool) {
        self.myAssetCashflows.removeAll()
        self.myRentalCashflows.removeAll()
        self.myResidualCashflows.removeAll()
        self.myLeaseTemplate.removeAll()
        
        createLeaseTemplate(aInvestment: aInvestment)
        if lesseePerspective {
            myAssetCashflows.createTable_Lessee(aInvestment: aInvestment, aLeaseTemplate: myLeaseTemplate)
        } else {
            myAssetCashflows.createTable_Lessor(aInvestment: aInvestment,aLeaseTemplate: myLeaseTemplate)
        }
        self.addCashflows(myAssetCashflows)
        myRentalCashflows.createTable(aRent: aInvestment.rent, aLeaseTerm: aInvestment.leaseTerm, aAsset: aInvestment.asset, eomRule: aInvestment.leaseTerm.endOfMonthRule)
        self.addCashflows(myRentalCashflows)
        myResidualCashflows.createTable(aInvestment: aInvestment, aLeaseTemplate: myLeaseTemplate)
        self.addCashflows(myResidualCashflows)
    }
    
    public func createPeriodicLeaseCashflows(aInvestment: Investment, lesseePerspective: Bool) -> Cashflows {
        self.createTable(aInvestment: aInvestment, lesseePerspective: lesseePerspective)
        self.netCashflows()
        
        let myLeaseCashflows: Cashflows = Cashflows()
        for x in 0..<self.items[0].count() {
            let myCashflow: Cashflow = self.items[0].items[x]
            myLeaseCashflows.add(item: myCashflow)
        }
        self.removeAll()
        
        return myLeaseCashflows
    }
    
    public func createLeaseTemplate(aInvestment: Investment) {
        let myCashflow: Cashflow = Cashflow(dueDate: aInvestment.asset.fundingDate, amount: "0.0")
        myLeaseTemplate.add(item: myCashflow)
        
        if aInvestment.leaseTerm.baseCommenceDate !=  aInvestment.asset.fundingDate {
            let myCashflow: Cashflow = Cashflow(dueDate: aInvestment.leaseTerm.baseCommenceDate, amount: "0.0")
            myLeaseTemplate.add(item: myCashflow)
        }
        
        var nextLeaseDate: Date = addOnePeriodToDate(dateStart: aInvestment.leaseTerm.baseCommenceDate, payPerYear: aInvestment.leaseTerm.paymentFrequency, dateRefer: aInvestment.leaseTerm.baseCommenceDate, bolEOMRule: aInvestment.leaseTerm.endOfMonthRule)
        while nextLeaseDate <= aInvestment.getLeaseMaturityDate() {
            let myCashflow: Cashflow = Cashflow(dueDate: nextLeaseDate, amount: "0.0")
            myLeaseTemplate.add(item: myCashflow)
            nextLeaseDate = addOnePeriodToDate(dateStart: nextLeaseDate, payPerYear: aInvestment.leaseTerm.paymentFrequency, dateRefer: aInvestment.leaseTerm.baseCommenceDate, bolEOMRule: aInvestment.leaseTerm.endOfMonthRule)
        }
        
    }
    
    
}
