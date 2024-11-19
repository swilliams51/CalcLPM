//
//  PreTaxLeaseCashflowsView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/20/24.
//

import SwiftUI

struct PreTaxLeaseCashflowsView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    var body: some View {
        VStack {
            ReportHeaderView(name: "Pre-Tax Cash", viewAsPct: myViewAsPct, path: $path, isDark: $isDark)
            Form{
                Section(header: Text("\(currentFile)")) {
                    ForEach(myInvestment.beforeTaxCashflows.items) { item in
                        HStack {
                            Text("\(item.dueDate.toStringDateShort(yrDigits: 2))")
                            Spacer()
                            Text("\(amountFormatter(amount: item.amount, locale: myLocale))")
                        }
                        .font(myFont)
                    }
                }
                Section(header: Text("Results")) {
                    HStack {
                        Text("\(myInvestment.beforeTaxCashflows.count())")
                        Spacer()
                        Text("\(amountFormatter(amount: myInvestment.beforeTaxCashflows.getTotal().toString(decPlaces: 2), locale: myLocale))")
                    }
                    .font(myFont)
                }
                    
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            myInvestment.setBeforeTaxCashflows()
        }
    }
    
    private func myViewAsPct() {
        
    }
}


#Preview {
    PreTaxLeaseCashflowsView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
