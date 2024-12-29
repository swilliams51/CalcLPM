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
    @State var viewAsPct: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(headerType: .report, name: "Taxes Paid", viewAsPct: myViewAsPct, goBack: myGoBack, withBackButton: true, withPctButton: true, path: $path, isDark: $isDark)
            Form {
                Section(header: Text("\(currentFile)")) {
                    ForEach(myPeriodicTaxesPaid.items) { item in
                        HStack {
                            Text("\(item.dueDate.toStringDateShort())")
                            Spacer()
                            Text("\(getFormattedValue(amount: item.amount, viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment))")
                        }
                        .font(myFont)
                    }
                }
                Section(header: Text("Totals")) {
                    HStack {
                        Text("\(myPeriodicTaxesPaid.items.count)")
                        Spacer()
                        Text("\(getFormattedValue(amount: myPeriodicTaxesPaid.getTotal().toString(decPlaces: 4), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment))")
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
    
    private func myViewAsPct() {
        self.viewAsPct.toggle()
    }
    
    private func myGoBack() {
        self.path.removeLast()
    }
}

#Preview {
    TaxesPaidView(myInvestment: Investment(), myTaxableIncomes: AnnualTaxableIncomes(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
