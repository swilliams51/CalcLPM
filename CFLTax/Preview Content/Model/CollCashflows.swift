//
//  CollCashflows.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


@Observable
public class CollCashflows {
    public var items: [Cashflows]
    
    public init() {
        items = [Cashflows]()
    }
    
    public func addCashflows(_ cfs: Cashflows) {
        items.append(cfs)
    }
    
    public func removeAll() {
        items.removeAll()
    }
    
    public func count() -> Int {
        return items.count
    }
    
    public func netCashflows() {
        if items.count > 1 {
            while items.count > 1 {
                while items[1].items.count > 0 {
                    var x = 0
                    while x < items[0].items.count {
                        if items[1].items[0].dueDate < items[0].items[x].dueDate {
                            let myDate: Date = items[1].items[0].dueDate
                            let myAmount: String = items[1].items[0].amount
                            let newCashflow = Cashflow(dueDate: myDate, amount: myAmount)
                            items[0].items.insert(newCashflow, at: x)
                            items[1].items.remove(at: 0)
                            break
                        } else if items[1].items[0].dueDate == items[0].items[x].dueDate { // occurs on same date
                            let myAmount: Decimal = (items[1].items[0].amount.toDecimal() + items[0].items[x].amount.toDecimal())
                            items[0].items[x].amount = myAmount.toString(decPlaces: 4)
                            items[1].items.remove(at: 0)
                            break
                        } else {
                            if x == items[0].items.count - 1 {
                                let myDate: Date = items[1].items[0].dueDate
                                let myAmount: String = items[1].items[0].amount
                                let newCashflow = Cashflow(dueDate: myDate, amount: myAmount)
                                items[0].items.append(newCashflow)
                                items[1].items.remove(at: 0)
                                break
                            }
                        }
                        x += 1
                    }
                    x = 0
                }
                if items[1].items.count == 0 {
                    items.remove(at: 1)
                }
            }
        }
    }

    public func totalCashflow() -> Decimal {
        var runTotal: Decimal = 0.0
        
        if items.count == 0 {
            runTotal = 0.0
        } else {
            for i in 0..<items.count {
                runTotal = runTotal + items[i].getTotal()
            }
        }
       
        return runTotal
    }
    
}
