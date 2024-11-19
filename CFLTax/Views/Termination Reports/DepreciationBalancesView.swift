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
        VStack {
            ReportHeaderView(name: "Depreciation Balances", viewAsPct: myViewAsPct, path: $path, isDark: $isDark)
            Form {
                Section(header: Text("\(currentFile)")) {
                    ForEach(myPeriodicDepreciationBalances.items) { item in
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
                        Text("\(myPeriodicDepreciationBalances.items.count)")
                    }
                    .font(myFont)
                }
               
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if myPeriodicDepreciationBalances.items.count > 0 {
                myPeriodicDepreciationBalances.items.removeAll()
            }

            myPeriodicDepreciationBalances.createTable(aInvestment: myInvestment)
        }
    }
    
    private func myViewAsPct() {
        
    }
}

#Preview {
    DepreciationBalancesView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
