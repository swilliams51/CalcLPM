//
//  ViewsManager.swift
//  CFLTax
//
//  Created by Steven Williams on 8/9/24.
//

import SwiftUI

struct ViewsManager: View {
    @Bindable var myInvestment: Investment
    @Bindable var myDepreciationSchedule: DepreciationIncomes
    @Bindable var myRentalSchedule: RentalCashflows
    @Bindable var myTaxableIncomes: AnnualTaxableIncomes
    @Bindable var myFeeAmortization: FeeIncomes
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var selectedGroup: Group
    @Binding var currentFile: String
    
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
            Text("Early Buyout Option Text Field")
        case 21:
          RentScheduleView(myInvestment: myInvestment, myRentalSchedule: myRentalSchedule, path: $path, isDark: $isDark)
        case 22:
          DepreciationScheduleView(myInvestment: myInvestment, myDepreciationSchedule: myDepreciationSchedule, path: $path, isDark: $isDark)
        case 23:
            PreTaxLeaseCashflowsView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 24:
            NetAfterTaxCashflowsView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 25:
            SummaryOfResultsView(myInvestment: myInvestment, path: $path, isDark: $isDark)
        case 26:
          FileMenuView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 27:
          FileOpenView(myInvestment: myInvestment, currentFile: $currentFile, path: $path, isDark: $isDark)
        case 28:
          FeeExpenseView(myInvestment: myInvestment, myFeeAmortization: myFeeAmortization, path: $path, isDark: $isDark)
        case 29:
            FileSaveAsView(myInvestment: myInvestment, currentFile: $currentFile, path: $path, isDark: $isDark)
        case 30:
            ReportsManagerView(myInvestment: myInvestment, myDepreciationSchedule: myDepreciationSchedule, path: $path, isDark: $isDark)
        case 31:
            Text("Preferences")
        case 32:
            Text("About")
        case 33:
            TaxableIncomeView(myInvestment: myInvestment, myTaxableIncomes: myTaxableIncomes, path: $path, isDark: $isDark)
        case 34:
            TaxesPaidView(myInvestment: myInvestment, myTaxableIncomes: myTaxableIncomes, path: $path, isDark: $isDark)
        default:
            Text("Hello")
        }
    }
}

#Preview {
    ViewsManager(myInvestment: Investment(), myDepreciationSchedule: DepreciationIncomes(), myRentalSchedule: RentalCashflows(), myTaxableIncomes: AnnualTaxableIncomes(), myFeeAmortization: FeeIncomes(), path: .constant([Int]()), isDark: .constant(false), selectedGroup: .constant(Group()), currentFile: .constant("File is New"), selectedView: 22)
}
