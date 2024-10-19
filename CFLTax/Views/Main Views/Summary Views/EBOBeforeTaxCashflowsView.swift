//
//  EBOPreTaxCashflowsView.swift
//  CFLTax
//
//  Created by Steven Williams on 10/16/24.
//

import SwiftUI

struct EBOBeforeTaxCashflowsView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var myBTCashflows: Cashflows = Cashflows()
    
    var body: some View {
        Form {
            Section(header: Text("\(currentFile)")) {
                ForEach(myBTCashflows.items) { item in
                    HStack {
                        Text("\(item.dueDate.toStringDateShort(yrDigits: 2))")
                        Spacer()
                        Text("\(amountFormatter(amount: item.amount, locale: myLocale))")
                    }
                    .font(myFont)
                }
            }
            Section(header: Text("Totals")) {
                HStack{
                    Text("\(myBTCashflows.items.count)")
                    Spacer()
                    Text("\(amountFormatter(amount: myBTCashflows.getTotal().toString(decPlaces: 4), locale: myLocale))")
                }
                .font(myFont)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationTitle("Before-Tax Cashflows")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if myBTCashflows.items.count > 0 {
                myBTCashflows.items.removeAll()
            }
            myBTCashflows = myInvestment.getEBO_BTCashflows(aEBO: myInvestment.earlyBuyout)
        }
    }
}

#Preview {
    EBOBeforeTaxCashflowsView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
