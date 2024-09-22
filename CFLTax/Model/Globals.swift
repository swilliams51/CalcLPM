//
//  Globals.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import Foundation
import SwiftUI

public let myLocale: Locale = Locale.current
public let tolerancePaymentAmounts: Decimal = 0.025
public let myFont: Font = .subheadline
public let myFont2: Font = .body
public let maximumLessorCost: String = "50000000.00"
public let minimumLessorCost: String = "999.99"
public let maximumYield: String = "0.30"
public let feeAmortizationMethod: FeeAmortizationMethod = .monthly
public let maxBaseTerm: Int = 360
public let removeCharacters: Set<Character> = [",", "$","-", "+","%"]
public let str_split_Cashflows = "#"
