//
//  NetAfterTaxCashflowsView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/19/24.
//

import SwiftUI

struct NetAfterTaxCashflowsView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    
    var body: some View {
        Form {
            Section(header: Text("Schedule")) {
                if myInvestment.afterTaxCashflows.items.count == 0 {
                    VStack {
                        Text("No Cashflows")
                    }
                } else {
                    ForEach(myInvestment.afterTaxCashflows.items) { item in
                        HStack {
                            Text("\(item.dueDate.toStringDateShort(yrDigits: 2))")
                            Spacer()
                            Text("\(amountFormatter(amount: item.amount, locale: myLocale))")
                        }
                    }
                }
            }
            Section(header: Text("Totals")) {
                if myInvestment.afterTaxCashflows.items.count == 0 {
                    VStack {
                        Text("No Totals")
                    }
                } else {
                    HStack {
                        Text("\(myInvestment.afterTaxCashflows.count())")
                        Spacer()
                        Text("\(amountFormatter(amount: myInvestment.afterTaxCashflows.getTotal().toString(decPlaces: 2), locale: myLocale))")
                    }
                }
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationTitle("Net A/T Cashflows")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.myInvestment.calculate()
            
        }
    }
            
}



#Preview {
    NetAfterTaxCashflowsView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false))
}
