//
//  TaxableIncomeView.swift
//  CFLTax
//
//  Created by Steven Williams on 9/1/24.
//

import SwiftUI

struct TaxableIncomeView: View {
    @Bindable var myInvestment: Investment
    @Bindable var myTaxableIncomes: AnnualTaxableIncomes
    @Binding var path: [Int]
    @Binding var isDark: Bool
    
    @State var myNetTaxableIncomes: Cashflows = Cashflows()
    
    var body: some View {
        Form{
            Section(header: Text("Taxable Income Schedule")) {
                ForEach(myNetTaxableIncomes.items) { item in
                    HStack {
                        Text("\(item.dueDate.toStringDateShort(yrDigits: 2))")
                        Spacer()
                        Text("\(amountFormatter(amount: item.amount, locale: myLocale))")
                    }
                }
            }
            Section(header: Text("Totals")) {
                HStack {
                    Text("\(myNetTaxableIncomes.items.count)")
                    Spacer()
                    Text("\(amountFormatter(amount: myNetTaxableIncomes.getTotal().toString(decPlaces: 4), locale: myLocale))")
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationTitle("Taxable Income")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            myNetTaxableIncomes =   myTaxableIncomes.createNetTaxableIncomes(aInvestment: myInvestment)
        }
    }
}

#Preview {
    TaxableIncomeView(myInvestment: Investment(), myTaxableIncomes: AnnualTaxableIncomes(), path: .constant([Int]()), isDark: .constant(false))
}
