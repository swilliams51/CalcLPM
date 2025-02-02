//
//  Dates.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


import Foundation

public func addOnePeriodToDate (dateStart: Date, payPerYear: Frequency, dateRefer: Date, bolEOMRule: Bool) -> Date {
    let theStartDay = getDayComponent(dateIn: dateStart)
    let theStartMonth = getMonthComponent(dateIn: dateStart)
    let theStartYear = getYearComponent(dateIn: dateStart)
    let referDay = getDayComponent(dateIn: dateRefer)
    let referMonth = getMonthComponent(dateIn: dateRefer)
    let referYear = getYearComponent(dateIn: dateRefer)
    let isReferLDM = isLastDayOfMonth(iDay: referDay, iMonth: referMonth, iYear: referYear)
    var theEndMonth = 0
    var theEndYear = 0
    
    switch payPerYear {
    case .monthly:
        if theStartMonth == 12 {
            theEndMonth = 1
            theEndYear = theStartYear + 1
        } else {
            theEndMonth = theStartMonth + 1
            theEndYear = theStartYear
        }
    case .quarterly:
        if theStartMonth > 9 {
            theEndMonth = theStartMonth + 3 - 12
            theEndYear = theStartYear + 1
        } else {
            theEndMonth = theStartMonth + 3
            theEndYear = theStartYear
        }
    case .semiannual:
        if theStartMonth > 6 {
            theEndMonth = theStartMonth + 6 - 12
            theEndYear = theStartYear + 1
        } else {
            theEndMonth = theStartMonth + 6
            theEndYear = theStartYear
        }
    case .annual:
        theEndMonth = theStartMonth
        theEndYear = theStartYear + 1
    }
    let theEndDay = getTheDay(referDay: referDay, startDay: theStartDay, endMonth: theEndMonth, endYear: theEndYear, bolEOM: bolEOMRule, bolReferIsLDM: isReferLDM)
    
    var comps = DateComponents()
    comps.day = theEndDay
    comps.month = theEndMonth
    comps.year = theEndYear
    
    let dateNew = Calendar.current.date(from: comps)!
    
    return dateNew
}

func subtractOnePeriodFromDate(dateStart: Date, payperYear: Frequency, dateRefer: Date, bolEOMRule: Bool) -> Date {
    let theStartDay = getDayComponent(dateIn: dateStart)
    let theStartMonth = getMonthComponent(dateIn: dateStart)
    let theStartYear = getYearComponent(dateIn: dateStart)
    let referDay = getDayComponent(dateIn: dateRefer)
    let referMonth = getMonthComponent(dateIn: dateRefer)
    let referYear = getYearComponent(dateIn: dateRefer)
    let isReferLDM = isLastDayOfMonth(iDay: referDay, iMonth: referMonth, iYear: referYear)
    var theEndMonth = 0
    var theEndYear = 0
    
    switch payperYear {
    case .monthly:
        if theStartMonth == 1 {
            theEndMonth = 12
            theEndYear = theStartYear - 1
        } else {
            theEndMonth = theStartMonth - 1
            theEndYear = theStartYear
        }
    case .quarterly:
        if theStartMonth <= 3 {
            theEndMonth = theStartMonth - 3 + 12
            theEndYear = theStartYear - 1
        } else {
            theEndMonth = theStartMonth - 3
            theEndYear = theStartYear
        }
    case .semiannual:
        if theStartMonth <= 6 {
            theEndMonth = theStartMonth - 6 + 12
            theEndYear = theStartYear - 1
        } else {
            theEndMonth = theStartMonth - 6
            theEndYear = theStartYear
        }
    case .annual:
        theEndMonth = theStartMonth
        theEndYear = theStartYear - 1
    }
    let theEndDay = getTheDay(referDay: referDay, startDay: theStartDay, endMonth: theEndMonth, endYear: theEndYear, bolEOM: bolEOMRule, bolReferIsLDM: isReferLDM)
    
    var comps = DateComponents()
    comps.day = theEndDay
    comps.month = theEndMonth
    comps.year = theEndYear
    
    let dateNew = Calendar.current.date(from: comps)!
    
    return dateNew
}



public func getFiscalYearEnd(askDate: Date, fiscalMonthEnd: Int) -> Date {
    let year:Int = getYearComponent(dateIn: askDate)
    let monthAsk: Int = getMonthComponent(dateIn: askDate)
    let day: Int = lastDayOfMonth(iMonth: fiscalMonthEnd, iYear: year)
    var comps = DateComponents()
    
    comps.day = day
    comps.month = fiscalMonthEnd
    comps.year = year
    if monthAsk > fiscalMonthEnd {
        comps.year = year + 1
    }
    
    if comps.month == 2 && comps.day == 29 {
        if comps.year! % 4 != 0 {
            comps.day = 28
        }
    }
   
    let dateNew = Calendar.current.date(from: comps)!
    
    return dateNew
}

public func addNextFiscalYearEnd(aDateIn: Date) -> Date {
    let year:Int = getYearComponent(dateIn: aDateIn)
    let month: Int = getMonthComponent(dateIn: aDateIn)
    let day: Int = lastDayOfMonth(iMonth: month, iYear: year)
    
    
    var comps = DateComponents()
    comps.day = day
    comps.month = month
    comps.year = year + 1
    
    let dateNew = Calendar.current.date(from: comps)!
    
    return dateNew
}

//MARK: - addPeriodsToDate
public func addPeriodsToDate (dateStart: Date, payPerYear: Frequency, noOfPeriods: Int, referDate: Date, bolEOMRule: Bool) -> Date {
    var iCounter = 0
    var tempDate = dateStart
    if noOfPeriods > 0 {
        while iCounter < noOfPeriods {
            tempDate = addOnePeriodToDate(dateStart: tempDate, payPerYear: payPerYear, dateRefer: referDate, bolEOMRule: bolEOMRule)
            iCounter += 1
        }
    }
    return tempDate
}

public func subtractPeriodsFromDate(dateStart: Date, payPerYear: Frequency, noOfPeriods: Int, referDate: Date, bolEOMRule: Bool) -> Date {
    var iCounter = 0
    var tempDate = dateStart
    if noOfPeriods > 0 {
        while iCounter < noOfPeriods {
            tempDate = subtractOnePeriodFromDate(dateStart: tempDate, payperYear: payPerYear, dateRefer: referDate, bolEOMRule: bolEOMRule)
            iCounter += 1
        }
    }
    
    return tempDate
}


public func getDayComponent (dateIn: Date) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: dateIn)
    let theDay = components.day!
    
    return theDay
}

public func getMonthComponent (dateIn: Date) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: dateIn)
    let theMonth = components.month!
    
    return theMonth
}

public func getYearComponent (dateIn: Date) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.month], from: dateIn)
    let theYear = components.year!

    return theYear
}

public func getTheDay (referDay: Int, startDay: Int, endMonth: Int, endYear: Int, bolEOM: Bool, bolReferIsLDM: Bool) -> Int {
    var theDay = 0
    
    if startDay < 28 {
        return startDay
    }
    
    if (bolEOM == true && bolReferIsLDM == true) {
        return lastDayOfMonth(iMonth: endMonth, iYear: endYear)
    }
    
    if (bolEOM == false && bolReferIsLDM == true) {
        return min(referDay, lastDayOfMonth(iMonth: endMonth, iYear: endYear))
    }
    
    if referDay > startDay {
        theDay = min(referDay, lastDayOfMonth(iMonth: endMonth, iYear: endYear))
    } else {
        theDay = min(startDay, lastDayOfMonth(iMonth: endMonth, iYear: endYear))
    }
    return theDay
    }


public func lastDayOfMonth(iMonth: Int, iYear: Int) -> Int {
    var day = 0
    
    switch iMonth {
    case 1:
        day = 31
    case 2:
        if iYear % 4 == 0 {
            day = 29
        } else {
            day = 28
        }
    case 3:
        day = 31
    case 4:
        day = 30
    case 5:
        day = 31
    case 6:
        day = 30
    case 7:
        day = 31
    case 8:
        day = 31
    case 9:
        day = 30
    case 10:
        day = 31
    case 11:
        day = 30
    case 12:
        day = 31
    default:
        day = 0
    }
    return day
}

public func isLastDayOfMonth(iDay: Int, iMonth: Int, iYear: Int) -> Bool {
    var bolLastDay = false
    let theDay = iDay
    
    switch iMonth {
        case 1:
            if theDay == 31 {
                bolLastDay = true
            }
        case 2:
            if (theDay == 28 && iYear % 4 > 0) {
                bolLastDay = true
            } else if (theDay == 29 && iYear % 4 == 0) {
                bolLastDay = true
            }
        case 3:
            if theDay == 31 {
                bolLastDay = true
            }
        case 4:
            if theDay == 30 {
                bolLastDay = true
            }
        case 5:
            if theDay == 31 {
                bolLastDay = true
            }
        case 6:
            if theDay == 30 {
                bolLastDay = true
            }
        case 7:
            if theDay == 31 {
                bolLastDay = true
            }
        case 8:
            if theDay == 31 {
                bolLastDay = true
            }
        case 9:
            if theDay == 30 {
                bolLastDay = true
            }
        case 10:
            if theDay == 31 {
                bolLastDay = true
            }
        case 11:
            if theDay == 30 {
                bolLastDay = true
            }
        case 12:
            if theDay == 31 {
                bolLastDay = true
            }
        default:
            bolLastDay = false
    }
    return bolLastDay
}

func isLastDayOfFebruary (dateAsk: Date) -> Bool {
    let day = getDayComponent(dateIn: dateAsk)
    let month = getMonthComponent(dateIn: dateAsk)
    let year = getYearComponent(dateIn: dateAsk)
    
    if month == 2 {
        if year % 4 == 0 {
            if day == 29 {
                return true
            }
        } else {
            if day == 28 {
                return true
            }
        }
    }
    return false
}

public func monthsDifference (start: Date, end: Date, inclusive: Bool) -> Int {
    let adder: Int = inclusive ? 1 : 0
    let startMonth = getMonthComponent(dateIn: start)
    let startYear = getYearComponent(dateIn: start)
    let endMonth = getMonthComponent(dateIn: end)
    let endYear = getYearComponent(dateIn: end)
    
    let monthsDiff = endMonth - startMonth
    let yearsDiff = endYear - startYear
    let totalMonths: Int = yearsDiff * 12 + monthsDiff + adder
    
    
    return totalMonths
}

public func getYearsDiff(start: Date, end: Date, inclusive: Bool) -> Int {
    let adder: Int = inclusive ? 1 : 0
    let startYear = getYearComponent(dateIn: start)
    let endYear = getYearComponent(dateIn: end)
    
    let yearsDiff: Int = endYear - startYear + adder
    
    return yearsDiff
}


public func dayCount(aDate1: Date, aDate2: Date, aDayCount: DayCountMethod) -> Int {
    var noOfDays: Int
    
    switch aDayCount {
    case .thirtyThreeSixty:
        noOfDays = daysDiff360ConvUS(aDate1: aDate1, aDate2: aDate2)
    case .actualActual:
        noOfDays = Calendar.current.dateComponents([.day], from: aDate1, to: aDate2).day!
    case .actualThreeSixtyFive:
        noOfDays = Calendar.current.dateComponents([.day], from: aDate1, to: aDate2).day!
    case .actualThreeSixty:
        noOfDays = Calendar.current.dateComponents([.day], from: aDate1, to: aDate2).day!
    }
    
    return noOfDays
}

public func daysDiff360ConvUS (aDate1: Date, aDate2: Date) -> Int {
    var noOfDays: Int = 0
    let dayStartDate = getDayComponent(dateIn: aDate1)
    let monthStartDate = getMonthComponent(dateIn: aDate1)
    let yearStartDate = getYearComponent(dateIn: aDate1)
    let dayEndDate = getDayComponent(dateIn: aDate2)
    let monthEndDate = getMonthComponent(dateIn: aDate2)
    let yearEndDate = getYearComponent(dateIn: aDate2)
    var d1 = dayStartDate
    var d2 = dayEndDate
    
    if dayStartDate == 31 || isLastDayOfFebruary(dateAsk: aDate1) == true {
        d1 = 30
    }
    
    if dayEndDate == 31 || isLastDayOfFebruary(dateAsk: aDate2) == true {
        d2 = 30
    }
    
    noOfDays = (360 * (yearEndDate - yearStartDate) + (30 * (monthEndDate - monthStartDate)) + (d2 - d1))
    return noOfDays
    
}
 

public func dailyRate (iRate: Decimal, aDate1: Date, aDate2: Date, aDayCountMethod: DayCountMethod) -> Decimal {
    let days = daysInYear(aDate1: aDate1, aDate2: aDate2, aDayCountMethod: aDayCountMethod)
    if days == 0 {
        return 0.0
    } else {
        return iRate / Decimal(days)
    }
    
}

public func daysInPmtPeriod (aFrequency: Frequency) -> Decimal {
    switch aFrequency {
    case .annual:
        return 360
    case .semiannual:
        return 180
    case .quarterly:
        return 90
    case .monthly:
        return 30
    }
}

public func daysInYear (aDate1: Date, aDate2: Date, aDayCountMethod: DayCountMethod) -> Double {
    switch aDayCountMethod {
    case .thirtyThreeSixty:
        return 360.0
    case .actualActual:
        let yearDateStart = getYearComponent(dateIn: aDate1)
        let yearDateEnd = getYearComponent(dateIn: aDate2)
        if yearDateStart % 4 > 0 && yearDateEnd % 4 > 0 {
            return 365.0
        } else if yearDateStart % 4 == 0 && yearDateEnd % 4 == 0 {
            return 366.0
        } else {
            var daysNotInLeapYear: Int
            let daysInPeriod = Calendar.current.dateComponents([.day], from: aDate1, to: aDate2).day!
            if yearDateStart % 4 > 0 && yearDateEnd % 4 == 0 {
                let dateDEC31 = dateValue(day: 31, month: 12, year: yearDateStart)
                daysNotInLeapYear = Calendar.current.dateComponents([.day], from: aDate1, to: dateDEC31).day!
            } else {
                let dateJAN01 = dateValue(day: 1, month: 1, year: yearDateEnd)
                daysNotInLeapYear = Calendar.current.dateComponents([.day], from: dateJAN01, to: aDate2).day! + 1
            }
            return 365.0 + Double(daysNotInLeapYear/daysInPeriod)
        }
    case .actualThreeSixtyFive:
        return 365.0
    case .actualThreeSixty:
        return 360.0
    }
}

func dateValue (day: Int, month: Int, year: Int) -> Date {
    let strDefaultDate = "01/01/1900"
    let defaultDate = strDefaultDate.toDate()
    var dateComponents = DateComponents()
    dateComponents.day = day
    dateComponents.month = month
    dateComponents.year = year
    
    return Calendar.current.date(from: dateComponents) ?? defaultDate
}

public func dateDefault () -> Date {
    let strDefaultDate = "01/01/1900"
    return strDefaultDate.toDate()
}

public func isDatePeriodic(compareDate: Date, askDate: Date, aFreq: Frequency, endOfMonthRule: Bool, referDate: Date) -> Bool {
    var bolIsPeriodic: Bool = false
    
    if compareDate.isLessThan(date: askDate) {
        let newDate = addOnePeriodToDate(dateStart: compareDate, payPerYear: aFreq, dateRefer: referDate, bolEOMRule: endOfMonthRule)
        if newDate.isEqualTo(date: askDate){
            bolIsPeriodic = true
        }
    }
    return bolIsPeriodic
}

public func areDatesEqual(date1: Date, date2: Date) -> Bool {
    let day1 = getDayComponent(dateIn: date1)
    let month1 = getMonthComponent(dateIn: date1)
    let year1 = getYearComponent(dateIn: date1)
    
    let day2 = getDayComponent(dateIn: date2)
    let month2 = getMonthComponent(dateIn: date2)
    let year2 = getYearComponent(dateIn: date2)
    
    if year1 == year2 && month1 == month2 && day1 == day2 {
        return true
    } else {
        return false
    }
}


public func areDatesUnequal(date1: Date, date2: Date) -> Bool {
    if areDatesEqual(date1: date1, date2: date2) == false {
        return true
    } else {
        return false
    }
}

public func isDateLessThan(date1: Date, date2: Date) -> Bool {
    let day1 = getDayComponent(dateIn: date1)
    let month1 = getMonthComponent(dateIn: date1)
    let year1 = getYearComponent(dateIn: date1)
    
    let day2 = getDayComponent(dateIn: date2)
    let month2 = getMonthComponent(dateIn: date2)
    let year2 = getYearComponent(dateIn: date2)
    
    if year1 < year2 || (year1 == year2 && month1 < month2) || (year1 == year2 && month1 == month2 && day1 < day2) {
        return true
    } else {
        return false
    }
}

public func isDateLessThanOrEqual(date1: Date, date2: Date) -> Bool {
    if isDateLessThan(date1: date1, date2: date2) || areDatesEqual(date1: date1, date2: date2) {
        return true
    } else {
        return false
    }
}

public func isDateGreaterThan(date1: Date, date2: Date) -> Bool {
    if !isDateLessThan(date1: date1, date2: date2) && !areDatesEqual(date1: date1, date2: date2) {
        return true
    } else {
        return false
    }
}




public func getTheMonth(mon: Int) -> String {
    switch mon {
    case 1:
        return "January"
    case 2:
        return "February"
    case 3:
        return "March"
    case 4:
        return "April"
    case 5:
        return "May"
    case 6:
        return "June"
    case 7:
        return "July"
    case 8:
        return "August"
    case 9:
        return "September"
    case 10:
        return "October"
    case 11:
        return "November"
    default:
        return "December"
        
    }
}
