//
//  Extensions.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation




extension Decimal {
    public func toInteger() -> Int {
        let doubleOf = self.toDouble()
        return doubleOf.toInteger()
    }
}

extension Decimal {
    public func toString (decPlaces: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = decPlaces
        formatter.maximumFractionDigits = decPlaces
        return formatter.string(from: self as NSDecimalNumber) ?? "0.0"
    }
}

extension Double {
    public func toInteger() -> Int {
        return Int(self)
    }
}


extension Int {
    public func toDouble() -> Double {
        return Double(self)
    }
}

extension Decimal {
    func toDouble() -> Double {
        return Double(self.description)!
    }
}

extension String {
    public func toDecimal() -> Decimal {
        return Decimal(string: self) ?? 0.0
    }
}

extension String {
    public func toDate() -> Date {
        //date in mm/dd/yy or yyyy-mm-dd
        let myArray: [String] = self.components(separatedBy: "/")
        let intMonth: Int = Int(myArray[0])!
        let intDay: Int = Int(myArray[1])!
        let intYear: Int = Int(myArray[2])!
        
        var components = DateComponents()
        components.day = intDay
        components.month = intMonth
        components.year = intYear
        
        return Calendar.current.date(from: components) ?? Date()
    }
}


extension String {
    public func toDepreciationType () -> DepreciationType {
        switch self {
        case "MACRS":
            return .MACRS
        case "One Fifty DB":
            return .One_Fifty_DB
        case "One SeventyFive DB":
            return .One_Seventy_Five_DB
        default:
            return .StraightLine
        }
    }
}


extension Int {
    func toString () -> String {
        return String(self)
    }
}
