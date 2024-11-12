//
//  YTDIncomesView.swift
//  CFLTax
//
//  Created by Steven Williams on 9/18/24.
//

import SwiftUI

struct YTDIncomesView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var myPeriodicIncomes: PeriodicYTDIncomes = PeriodicYTDIncomes()
    
    var body: some View {
        VStack {
            CustomHeaderView(name: "YTD Incomes", isReport: true, path: $path, isDark: $isDark)
            Form {
                Section(header: Text("\(currentFile)")) {
                    ForEach(myPeriodicIncomes.items) { item in
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
                        Text("\(myPeriodicIncomes.items.count)")
                    }
                    .font(myFont)
                }
               
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if myPeriodicIncomes.items.count > 0 {
                myPeriodicIncomes.items.removeAll()
            }
            myPeriodicIncomes.createTable(aInvestment: myInvestment)
        }
    }
}

#Preview {
    YTDIncomesView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
