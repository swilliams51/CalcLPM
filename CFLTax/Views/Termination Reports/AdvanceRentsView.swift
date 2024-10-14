//
//  AdvanceRentsView.swift
//  CFLTax
//
//  Created by Steven Williams on 9/20/24.
//

import SwiftUI

struct AdvanceRentsView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var myPeriodicAdvanceRents: PeriodicAdvanceRents = PeriodicAdvanceRents()
    
    var body: some View {
        Form {
            Section(header: Text("\(currentFile)")) {
                ForEach(myPeriodicAdvanceRents.items) { item in
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
                    Text("\(myPeriodicAdvanceRents.items.count)")
                }
                .font(myFont)
            }
           
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationTitle("Advanced Rents")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if myPeriodicAdvanceRents.items.count > 0 {
                myPeriodicAdvanceRents.items.removeAll()
            }
            myPeriodicAdvanceRents.createTable(aInvestment: myInvestment)
        }
    }
}

#Preview {
    AdvanceRentsView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
