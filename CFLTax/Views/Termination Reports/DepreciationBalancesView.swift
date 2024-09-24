//
//  DepreciationBalancesView.swift
//  CFLTax
//
//  Created by Steven Williams on 9/18/24.
//

import SwiftUI

struct DepreciationBalancesView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var myPeriodicDepreciationBalances: PeriodicDepreciableBalances = PeriodicDepreciableBalances()

    var body: some View {
        Form {
            Section(header: Text("\(currentFile)")) {
                ForEach(myPeriodicDepreciationBalances.items) { item in
                    HStack {
                        Text("\(item.dueDate.toStringDateShort(yrDigits: 2))")
                        Spacer()
                        Text("\(amountFormatter(amount: item.amount, locale: myLocale))")
                    }
                }
            }
            Section(header: Text("Totals")) {
                HStack{
                    Text("Count:")
                    Spacer()
                    Text("\(myPeriodicDepreciationBalances.items.count)")
                }
            }
           
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationTitle("Depreciation Balances")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if myPeriodicDepreciationBalances.items.count > 0 {
                myPeriodicDepreciationBalances.items.removeAll()
            }

            myPeriodicDepreciationBalances.createTable(aInvestment: myInvestment)
        }
    }
}

#Preview {
    DepreciationBalancesView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
