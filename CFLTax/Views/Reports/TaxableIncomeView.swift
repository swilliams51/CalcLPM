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
    @Binding var currentFile: String
    
    @State var myNetTaxableIncomes: Cashflows = Cashflows()
    @State var viewAsPct: Bool = false
    
    var body: some View {
        VStack {
            ReportHeaderView(name: "Taxable Income", viewAsPct: myViewAsPct, path: $path, isDark: $isDark)
            Form{
                Section(header: Text("\(currentFile)")) {
                    ForEach(myNetTaxableIncomes.items) { item in
                        HStack {
                            Text("\(item.dueDate.toStringDateShort(yrDigits: 2))")
                            Spacer()
                            Text("\(getFormattedValue(amount: item.amount, viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment))")
                        }
                        .font(myFont)
                    }
                }
                Section(header: Text("Totals")) {
                    HStack {
                        Text("\(myNetTaxableIncomes.items.count)")
                        Spacer()
                        Text("\(amountFormatter(amount: myNetTaxableIncomes.getTotal().toString(decPlaces: 4), locale: myLocale))")
                    }
                    .font(myFont)
                }
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            myNetTaxableIncomes =   myTaxableIncomes.createNetTaxableIncomes(aInvestment: myInvestment)
        }
    }
    
    private func myViewAsPct() {
        self.viewAsPct.toggle()
    }
}

#Preview {
    TaxableIncomeView(myInvestment: Investment(), myTaxableIncomes: AnnualTaxableIncomes(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
