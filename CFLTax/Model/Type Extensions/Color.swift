//
//  Color.swift
//  CFLTax
//
//  Created by Steven Williams on 8/10/24.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
    static let launch = LaunchTheme()
    
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let inActive = Color("AccentInactive")
    let calculated = Color("AccentCalculated")
    let active = Color("AccentActive")
    let popOver = Color("PopoverBackground")
}

struct LaunchTheme {
    let accent = Color("LaunchAccentColor")
    let background = Color("LaunchBackgroundColor")
}
