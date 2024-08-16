//
//  ViewsManager.swift
//  CFLTax
//
//  Created by Steven Williams on 8/9/24.
//

import SwiftUI

struct ViewsManager: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var selectedGroup: Group
    @Binding var index: Int
    
    var selectedView: Int
    
    
    var body: some View {
      switch selectedView {
        case 1:
          AssetView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 2:
            LeaseTermView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 3:
          RentView(myInvestment: myInvestment, selectedGroup: $selectedGroup, path: $path, isDark: $isDark)
        case 4:
           DepreciationView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 5:
           TaxAssumptionsView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 6:
            FeeView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 7:
            EconomicsView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 8:
            Text("Lease Payment")
        case 9:
            LessorCostTextFieldView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 10:
            ResidualTextFieldView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 11:
            LseGtyTextFieldView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 12:
          AssetNameTextFieldView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 13:
          GroupDetailView(myInvestment: myInvestment, selectedGroup: $selectedGroup, isDark: $isDark, path: $path)
      case 14:
          PaymentAmountTextFieldView(myInvestment: myInvestment, selectedGroup: $selectedGroup, index: $index, isDark: $isDark, path: $path)
        default:
            Text("Hello")
        }
    }
}

#Preview {
    ViewsManager(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), selectedGroup: .constant(Group()), index: .constant(0), selectedView: 4)
}
