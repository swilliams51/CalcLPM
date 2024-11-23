//
//  Globals.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation
import SwiftUI

public let myLocale: Locale = Locale.current
public let tolerancePaymentAmounts: Decimal = 0.050
public let toleranceLumpSums: Decimal = 0.005
public let myFont: Font = .subheadline
public let myFont2: Font = .footnote
public let maximumLessorCost: String = "9999999.99"
public let minimumLessorCost: String = "999.99"
public let maximumYield: String = "0.15"
public let maxEBOSpread: Int = 500
public let feeAmortizationMethod: FeeAmortizationMethod = .monthly
public let maxBaseTerm: Int = 180
public let removeCharacters: Set<Character> = [",", "$","-", "+","%","*","#","|","&","/","!"]
public let str_split_Cashflows = "#"



