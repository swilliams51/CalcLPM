//
//  EBOAfterTaxCashflowsView.swift
//  CFLTax
//
//  Created by Steven Williams on 10/16/24.
//

import SwiftUI

struct EBOAfterTaxCashflowsView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var myATCashflows: Cashflows = Cashflows()
    
    var body: some View {
        VStack {
            CustomHeaderView(name: "After-Tax Cashflows", isReport: true, path: $path, isDark: $isDark)
            Form {
                Section(header: Text("\(currentFile)")) {
                    ForEach(myATCashflows.items) { item in
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
                        Text("\(myATCashflows.items.count)")
                        Spacer()
                        Text("\(amountFormatter(amount: myATCashflows.getTotal().toString(decPlaces: 4), locale: myLocale))")
                    }
                    .font(myFont)
                }
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if myATCashflows.items.count > 0 {
                myATCashflows.items.removeAll()
            }
            myATCashflows = myInvestment.getEBO_ATCashflows(aEBO: myInvestment.earlyBuyout)
        }
    }
}

#Preview {
    EBOAfterTaxCashflowsView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
