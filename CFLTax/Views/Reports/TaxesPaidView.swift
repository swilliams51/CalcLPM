//
//  TaxesPaidView.swift
//  CFLTax
//
//  Created by Steven Williams on 9/1/24.
//

import SwiftUI

struct TaxesPaidView: View {
    @Bindable var myInvestment: Investment
    @Bindable var myTaxableIncomes: AnnualTaxableIncomes
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    @State var myPeriodicTaxesPaid: Cashflows = Cashflows()
    
    var body: some View {
        VStack {
            CustomHeaderView(name: "Taxes Paid", isReport: true, path: $path, isDark: $isDark)
            Form {
                Section(header: Text("\(currentFile)")) {
                    ForEach(myPeriodicTaxesPaid.items) { item in
                        HStack {
                            Text("\(item.dueDate.toStringDateShort(yrDigits: 2))")
                            Spacer()
                            Text("\(amountFormatter(amount: item.amount, locale: myLocale))")
                        }
                        .font(myFont)
                    }
                }
                Section(header: Text("Totals")) {
                    HStack {
                        Text("\(myPeriodicTaxesPaid.items.count)")
                        Spacer()
                        Text("\(amountFormatter(amount: myPeriodicTaxesPaid.getTotal().toString(decPlaces: 4), locale: myLocale))")
                    }
                    .font(myFont)
                }
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            myPeriodicTaxesPaid =   myTaxableIncomes.createPeriodicTaxesPaid_STD(aInvestment: myInvestment)
        }
    }
}

#Preview {
    TaxesPaidView(myInvestment: Investment(), myTaxableIncomes: AnnualTaxableIncomes(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
