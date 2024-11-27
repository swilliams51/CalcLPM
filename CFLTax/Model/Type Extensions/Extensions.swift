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

extension Decimal {
    public func truncate(places: Int = 0) -> Double {
        let string = self.toString(decPlaces: places)
        let strDecimal = string.toDecimal()
        let doubleOf = strDecimal.toDouble()
        return doubleOf
    }
}

extension Double {
    public func toInteger() -> Int {
        return Int(self)
    }
}

extension Double {
    public func toString(decPlaces: Int = 2) -> String {
        let decimalOf = Decimal(self)
        return decimalOf.toString(decPlaces: decPlaces)
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

extension String {
    func isDecimal() -> Bool {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        formatter.locale = Locale.current
        return formatter.number (from: self) != nil
    }
}


extension String {
    func toInteger () -> Int {
        return Int(self)!
    }
}




extension String {
    func toTimingType() -> TimingType {
        switch self {
        case "Advance":
            return .advance
        case "Arrears":
            return .arrears
        default:
            return .equals
        }
    }
}


extension String {
    func toBool() -> Bool {
        switch self {
        case "True":
            return true
        case "False":
            return false
        default:
            return false
        }
    }
}


extension String {
    func hasIllegalChars() -> Bool {
        let myIllegalChars = "!@$%^&|"
        let charSet = CharacterSet(charactersIn: myIllegalChars)
        if (self.rangeOfCharacter(from: charSet) != nil) {
            return true
        } else {
            return false
        }
    }
}

extension Bool {
    func toString() -> String {
        if (self) {
            return "True"
        } else {
            return "False"
        }
    }
}


extension Int {
    func toString () -> String {
        return String(self)
    }
}
