//
//  Formatting.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation


public let str_split_Cashflows = "#"

func amountFormatter(amount: String, locale: Locale) -> String {
    let decAmount: Decimal = amount.toDecimal()
    let amtFormatter = NumberFormatter()
    amtFormatter.numberStyle = .currency
    amtFormatter.usesGroupingSeparator = true
    amtFormatter.currencySymbol = ""
    amtFormatter.maximumFractionDigits = 2
    amtFormatter.minimumFractionDigits = 2
    amtFormatter.locale = locale
    
    let amountReturned: String = amtFormatter.string(for: decAmount) ?? "0.00"
    return amountReturned.trimmingCharacters(in: .whitespacesAndNewlines)
}

func percentFormatter(percent: String, locale: Locale, places: Int = 3) -> String {
    let decPercent: Decimal = percent.toDecimal()
    let pctFormatter = NumberFormatter()
    pctFormatter.numberStyle = .percent
    pctFormatter.maximumFractionDigits = places
    pctFormatter.minimumFractionDigits = places
    pctFormatter.locale = locale
    
    let percentReturned: String = pctFormatter.string(for: decPercent) ?? "0.00%"
    return percentReturned.replacingOccurrences(of: " ", with: "")
}

func decimalFormatter (decimal: String, locale: Locale, places: Int = 3) -> String {
    let decDecimal: Decimal = decimal.toDecimal()
    let decFormatter = NumberFormatter()
    decFormatter.numberStyle = .decimal
    decFormatter.maximumFractionDigits = places
    decFormatter.minimumFractionDigits = places
    decFormatter.locale = locale
    
    return decFormatter.string(for: decDecimal) ?? "0.000"
}

func dateFormatter (dateIn: Date, locale: Locale) -> String {
    let dFormatter = DateFormatter()
    dFormatter.locale = locale
    dFormatter.setLocalizedDateFormatFromTemplate("dd MM YY")
    
    return dFormatter.string(from: dateIn)
}
