//
//  TaxAssumptionsView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/9/24.
//

import SwiftUI

struct TaxAssumptionsView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    
    var body: some View {
        Form {
            Section (header: Text("Details")) {
                HStack {
                    Text("Federal Tax Rate:")
                    Spacer()
                    Text("\(myInvestment.taxAssumptions.federalTaxRate)%")
                }
                HStack {
                    Text("Fiscal Month End:")
                    Spacer()
                    Text("\(myInvestment.taxAssumptions.fiscalMonthEnd)")
                }
                HStack {
                    Text("Day of Month for Payments:")
                    Spacer()
                    Text("\(myInvestment.taxAssumptions.dayOfMonPaid)")
                }
            }
            Section(header: Text("Submit Form")) {
                SubmitFormButtonsView(cancelName: "Cancel", doneName: "Done", cancel: myCancel, done: myDone, isDark: $isDark)
            }
        }
        .navigationBarTitle("Tax Assumptions")
    }
    
    private func myCancel() {
        path.removeLast()
    }
    
    private func myDone() {
        path.removeLast()
    }
}

#Preview {
    TaxAssumptionsView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false))
}

