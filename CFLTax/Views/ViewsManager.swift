//
//  ViewsManager.swift
//  CFLTax
//
//  Created by Steven Williams on 8/9/24.
//

import SwiftUI

struct ViewsManager: View {
    @Bindable var myInvestment: Investment
    @Bindable var myDepreciationTable: DepreciationIncomes
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var selectedGroup: Group
    
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
            Text("Early Buyout Option Form")
        case 9:
            //Asset
            LessorCostTextFieldView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 10:
            //Asset
            ResidualTextFieldView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 11:
            //Asset
            LseGtyTextFieldView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 12:
            //Asset
            AssetNameTextFieldView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 13:
            //Rent
            GroupDetailView(myInvestment: myInvestment, selectedGroup: $selectedGroup, isDark: $isDark, path: $path)
        case 14:
            //Rent
            PaymentAmountTextFieldView(myInvestment: myInvestment, selectedGroup: $selectedGroup, isDark: $isDark, path: $path)
        case 15:
            FedTaxRateTextFieldView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 16:
            BonusDeprecTextFieldView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 17:
            YieldTargetTextFieldView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 18:
            DiscountRateTextFieldView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 19:
            FeeAmountTextFieldView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 20:
            NetAfterTaxCashflowsView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 21:
            ReportsManagerView(myInvestment: myInvestment, myDepreciationTable: myDepreciationTable, path: $path, isDark: $isDark)
        case 22:
           Text("Depreciation Schedule")
        case 23:
            PreTaxLeaseCashflowsView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 24:
            NetAfterTaxCashflowsView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 25:
            SummaryOfResultsView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        default:
            Text("Hello")
        }
    }
}

#Preview {
    ViewsManager(myInvestment: Investment(), myDepreciationTable: DepreciationIncomes(), path: .constant([Int]()), isDark: .constant(false), selectedGroup: .constant(Group()), selectedView: 22)
}
