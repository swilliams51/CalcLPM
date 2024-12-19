//
//  Date.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


extension Date {
    func toStringDateShort(yrDigits: Int) -> String {
        let iDay: String = String(getDayComponent(dateIn: self))
        let iMonth: String = String(getMonthComponent(dateIn: self))
        let iYear: String = String(getYearComponent(dateIn: self))
        
        return  iMonth + "/" + iDay + "/" + iYear
    }
}

extension Date {
    func toStringDateLong() -> String {
        let iDay: String = String(getDayComponent(dateIn: self))
        let iMonth: Int = getMonthComponent(dateIn: self)
        let iYear: String = String(getYearComponent(dateIn: self))
        let strMonth: String = getTheMonth(mon: iMonth)
        
        return strMonth + " " + iDay + ", " + iYear
    }
}

extension Date {
    func isEqualTo(date: Date) -> Bool {
        if areDatesEqual(date1: self, date2: date) {
            return true
        } else {
            return false
        }
        
    }
}

extension Date {
    func isLessThanOrEqualTo(date: Date) -> Bool {
        if areDatesEqual(date1: self, date2: date) || isDateLessThan(date1: self, date2: date) {
            return true
        } else {
            return false
        }
    }
}

extension Date {
    func isGreaterThan(date: Date) -> Bool {
        if isDateGreaterThan(date1: self, date2: date) {
            return true
        } else {
            return false
        }
    }
}

extension Date {
    func isNotEqualTo(date: Date) -> Bool {
        if !areDatesEqual(date1: self, date2: date) {
            return true
        } else {
            return false
        }
    }
}

extension Date {
    func isLessThan(date: Date) -> Bool {
        if isDateLessThan(date1: self, date2: date) {
            return true
        } else {
            return false
        }
    }
}


