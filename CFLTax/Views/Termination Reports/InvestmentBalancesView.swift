//
//  InvestmentBalancesView.swift
//  CFLTax
//
//  Created by Steven Williams on 9/18/24.
//

import SwiftUI

struct InvestmentBalancesView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var myPeriodicInvestmentBalances: PeriodicInvestmentBalances = PeriodicInvestmentBalances()
    
    var body: some View {
        VStack {
            CustomHeaderView(name: "Investment Balances", isReport: true, path: $path, isDark: $isDark)
            Form {
                Section(header: Text("\(currentFile)")) {
                    ForEach(myPeriodicInvestmentBalances.items) { item in
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
                        Text("Count:")
                        Spacer()
                        Text("\(myPeriodicInvestmentBalances.items.count)")
                    }
                    .font(myFont)
                }
               
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if myPeriodicInvestmentBalances.items.count > 0 {
                myPeriodicInvestmentBalances.items.removeAll()
            }

            myPeriodicInvestmentBalances.createInvestmentBalances(aInvestment: myInvestment)
        }
    }
}

#Preview {
    InvestmentBalancesView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
