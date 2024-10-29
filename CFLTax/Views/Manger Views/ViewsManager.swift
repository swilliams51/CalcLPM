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
    @Binding var minimumEBOAmount: Decimal
    @Binding var maximumEBOAmount: Decimal
    
    var selectedView: Int
    
    var body: some View {
      switch selectedView {
        case 1:
            AssetView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 2:
            LeaseTermView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 3:
            RentView(myInvestment: myInvestment, selectedGroup: $selectedGroup, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 4:
            DepreciationView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 5:
            TaxAssumptionsView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 6:
            FeeView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 7:
            EconomicsView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 8:
          EarlyBuyoutView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile, minimumEBOAmount: $minimumEBOAmount, maximumEBOAmount: $maximumEBOAmount)
        case 9:
            Text("No Lessor Cost")
        case 10:
            Text("No Residual value")
        case 11:
           Text("No Lessee Guaranty")
        case 12:
           Text("No Asset name")
        case 13:
            GroupDetailView(myInvestment: myInvestment, selectedGroup: $selectedGroup, isDark: $isDark, path: $path, currentFile: $currentFile)
        case 14:
            CashflowView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 15:
            RentSummaryView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 16:
            EBOSummaryView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 17:
            EBOBeforeTaxCashflowsView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 18:
          EBOAfterTaxCashflowsView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 19:
            Text("No Fee")
        case 20:
           Text("No Salvage")
        case 21:
          RentScheduleView(myInvestment: myInvestment, myRentalSchedule: myRentalSchedule, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 22:
          DepreciationScheduleView(myInvestment: myInvestment, myDepreciationSchedule: myDepreciationSchedule, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 23:
          PreTaxLeaseCashflowsView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 24:
          NetAfterTaxCashflowsView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 25:
            SummaryOfResultsView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 26:
            FileMenuView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 27:
            FileOpenView(myInvestment: myInvestment, currentFile: $currentFile, path: $path, isDark: $isDark)
        case 28:
            FeeExpenseView(myInvestment: myInvestment, myFeeAmortization: myFeeAmortization, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 29:
            FileSaveAsView(myInvestment: myInvestment, currentFile: $currentFile, path: $path, isDark: $isDark)
        case 30:
            ReportsManagerView(myInvestment: myInvestment, myDepreciationSchedule: myDepreciationSchedule, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 31:
          PreferencesView(myInvestment: myInvestment, isDark: $isDark, path: $path)
        case 32:
            Text("About")
        case 33:
            TaxableIncomeView(myInvestment: myInvestment, myTaxableIncomes: myTaxableIncomes, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 34:
            TaxesPaidView(myInvestment: myInvestment, myTaxableIncomes: myTaxableIncomes, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 35:
            InvestmentAmortizationView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 36:
            TerminationViewsManager(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 37:
            InvestmentBalancesView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 38:
            DepreciationBalancesView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 39:
            YTDIncomesView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 40:
            YTDTaxesPaidView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        case 41:
            AdvanceRentsView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
      case 42:
            TerminationValuesView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
      case 43:
            YTDTaxesDueView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
      case 44:
            TerminationValuesProofView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
      case 45:
            ArrearsRentsView(myInvestment: myInvestment, path: $path, isDark: $isDark, currentFile: $currentFile)
        default:
            Text("Hello")
        }
    }
}

#Preview {
    ViewsManager(myInvestment: Investment(), myDepreciationSchedule: DepreciationIncomes(), myRentalSchedule: RentalCashflows(), myTaxableIncomes: AnnualTaxableIncomes(), myFeeAmortization: FeeIncomes(), path: .constant([Int]()), isDark: .constant(false), selectedGroup: .constant(Group()), currentFile: .constant("File is New"), minimumEBOAmount: .constant(0), maximumEBOAmount: .constant(0), selectedView: 36)
}
