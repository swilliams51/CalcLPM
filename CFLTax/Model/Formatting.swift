//
//  Formatting.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation




public func amountFormatter(amount: String, locale: Locale, places: Int = 2) -> String {
    let decAmount: Decimal = amount.toDecimal()
    let amtFormatter = NumberFormatter()
    amtFormatter.numberStyle = .currency
    amtFormatter.usesGroupingSeparator = true
    amtFormatter.currencySymbol = ""
    amtFormatter.maximumFractionDigits = places
    amtFormatter.minimumFractionDigits = places
    amtFormatter.locale = locale
    
    let amountReturned: String = amtFormatter.string(for: decAmount) ?? "0.00"
    return amountReturned.trimmingCharacters(in: .whitespacesAndNewlines)
}

public func percentFormatter(percent: String, locale: Locale, places: Int = 3) -> String {
    let decPercent: Decimal = percent.toDecimal()
    let pctFormatter = NumberFormatter()
    pctFormatter.numberStyle = .percent
    pctFormatter.maximumFractionDigits = places
    pctFormatter.minimumFractionDigits = places
    pctFormatter.locale = locale
    
    let percentReturned: String = pctFormatter.string(for: decPercent) ?? "0.00%"
    return percentReturned.replacingOccurrences(of: " ", with: "")
}

public func decimalFormatter (decimal: String, locale: Locale, places: Int = 3) -> String {
    let decDecimal: Decimal = decimal.toDecimal()
    let decFormatter = NumberFormatter()
    decFormatter.numberStyle = .decimal
    decFormatter.maximumFractionDigits = places
    decFormatter.minimumFractionDigits = places
    decFormatter.locale = locale
    
    return decFormatter.string(for: decDecimal) ?? "0.000"
}

public func dateFormatter (dateIn: Date, locale: Locale) -> String {
    let dFormatter = DateFormatter()
    dFormatter.locale = locale
    dFormatter.setLocalizedDateFormatFromTemplate("dd MM yy")
    
    return dFormatter.string(from: dateIn)
}

public func getFormattedValue (amount: String, viewAsPercentOfCost: Bool, aInvestment: Investment, places: Int = 3) -> String {
    if viewAsPercentOfCost {
        let decAmount = amount.toDecimal()
        let decCost = aInvestment.getAssetCost(asCashflow: false)
        let decPercent = decAmount / decCost
        let strPercent: String = decPercent.toString(decPlaces: 8)
        
        return percentFormatter(percent: strPercent, locale: myLocale, places: places)
    } else {
         return amountFormatter(amount: amount, locale: myLocale, places: places)
    }
}
