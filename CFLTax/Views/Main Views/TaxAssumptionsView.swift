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
    @Binding var currentFile: String
    
    @State var myTaxRate: String = "0.21"
    @State var myFiscalMonthEnd: TaxYearEnd = .December
    @State var myDayOfMonPaid: Int = 15
    @State var days: [Int] = [1, 5, 10, 15, 20, 25, 30]
    
    var body: some View {
        Form {
            Section (header: Text("Details").font(myFont2), footer: (Text("FileName: \(currentFile)").font(myFont2))) {
                taxRateItem
                fiscalMonthEndItem
                dayOfMonthTaxesPaidItem
            }.font(myFont2)
            Section(header: Text("Submit Form")) {
                SubmitFormButtonsView(cancelName: "Cancel", doneName: "Done", cancel: myCancel, done: myDone, isDark: $isDark)
            }.font(myFont2)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarTitle("Tax Assumptions")
        .navigationBarBackButtonHidden(true)
        .onAppear() {
            self.myTaxRate  = self.myInvestment.taxAssumptions.federalTaxRate
            self.myFiscalMonthEnd = self.myInvestment.taxAssumptions.fiscalMonthEnd
            self.myDayOfMonPaid = self.myInvestment.taxAssumptions.dayOfMonPaid
        }
    }
    
    var taxRateItem: some View {
        HStack {
            Text("Federal Tax Rate:")
                .font(myFont2)
                .onTapGesture {
                    self.path.append(15)
                }
            Spacer()
            Text("\(percentFormatter(percent: myTaxRate, locale: myLocale, places: 2))")
                .font(myFont2)
                .onTapGesture {
                    self.path.append(15)
                }
        }
    }
    
    var fiscalMonthEndItem: some View {
        HStack {
            Text("Fiscal Month End:")
                .font(myFont2)
            Picker(selection: $myFiscalMonthEnd, label: Text("")) {
                ForEach(TaxYearEnd.allCases, id: \.self) { item in
                   Text(item.toString())
                        .font(myFont2)
               }
            }
        }
    }
    
    var dayOfMonthTaxesPaidItem: some View {
        HStack {
            Text("Day Taxes Paid:")
                .font(myFont2)
            Picker(selection: $myDayOfMonPaid, label: Text("")) {
                ForEach(days, id: \.self) { item in
                   Text(item.toString())
                        .font(myFont2)
               }
            }
        }
    }
    
    private func myCancel() {
        path.removeLast()
    }
    
    private func myDone() {
        self.myInvestment.taxAssumptions.federalTaxRate = myTaxRate
        
        if self.myFiscalMonthEnd != myInvestment.taxAssumptions.fiscalMonthEnd {
            self.myInvestment.hasChanged = true
            self.myInvestment.taxAssumptions.fiscalMonthEnd = myFiscalMonthEnd
        }
        
        if self.myDayOfMonPaid != myInvestment.taxAssumptions.dayOfMonPaid {
            self.myInvestment.hasChanged = true
            self.myInvestment.taxAssumptions.dayOfMonPaid = myDayOfMonPaid
        }
        
        path.removeLast()
    }
}

#Preview {
    TaxAssumptionsView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}

