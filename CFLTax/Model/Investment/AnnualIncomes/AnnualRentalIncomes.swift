//
//  AnnualRentalIncomes.swift
//  CFLTax
//
//  Created by Steven Williams on 9/17/24.
//

import Foundation


@Observable
public class AnnualRentalIncomes: CollCashflows {
    public var myInterimRentalIncomes: InterimRentalIncomes = InterimRentalIncomes()
    public var myBaseRentalIncomes: BaseRentalIncomes = BaseRentalIncomes()
    
    public func createTable(aInvestment: Investment) {
        self.myInterimRentalIncomes.removeAll()
        self.myBaseRentalIncomes.removeAll()
        
        myInterimRentalIncomes.createTable(aInvestment: aInvestment)
        self.addCashflows(myInterimRentalIncomes)
        
        myBaseRentalIncomes.createTable(aInvestment: aInvestment)
        self.addCashflows(myBaseRentalIncomes)
        
    }
    
    
    public func createAnnualRentalIncomes(aInvestment: Investment) -> Cashflows {
        self.createTable(aInvestment: aInvestment)
        self.netCashflows()
        
        let annualRentalIncome: Cashflows = Cashflows()
        for x in 0..<items[0].count() {
            let item: Cashflow = items[0].items[x]
            annualRentalIncome.add(item: item)
        }
        
        self.items.removeAll()
        return annualRentalIncome
    }
}

