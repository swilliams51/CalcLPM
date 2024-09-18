//
//  PeriodicLeaseCashflows.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation

@Observable
public class PeriodicLeaseCashflows: CollCashflows {
    public var myLeaseTemplate: LeaseTemplateCashflows = LeaseTemplateCashflows()
    var myAssetCashflows: AssetCashflows = AssetCashflows()
    var myRentalCashflows: RentalCashflows = RentalCashflows()
    var myResidualCashflows: ResidualCashflows = ResidualCashflows()
    
    public func createTable(aInvestment: Investment, lesseePerspective: Bool) {
        self.myLeaseTemplate.removeAll()
        self.myAssetCashflows.removeAll()
        self.myRentalCashflows.removeAll()
        self.myResidualCashflows.removeAll()
        self.myLeaseTemplate.removeAll()
        
        myLeaseTemplate.createTemplate(aInvestment: aInvestment)
        if lesseePerspective {
            myAssetCashflows.createTable_Lessee(aInvestment: aInvestment, aLeaseTemplate: myLeaseTemplate)
        } else {
            myAssetCashflows.createTable_Lessor(aInvestment: aInvestment,aLeaseTemplate: myLeaseTemplate)
        }
        self.addCashflows(myAssetCashflows)
        myRentalCashflows.createTable(aInvestment: aInvestment)
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
    
  
    
    
}
