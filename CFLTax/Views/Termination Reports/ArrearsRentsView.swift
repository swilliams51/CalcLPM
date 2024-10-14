//
//  ArrearsRentsView.swift
//  CFLTax
//
//  Created by Steven Williams on 10/6/24.
//

import SwiftUI

struct ArrearsRentsView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var myPeriodicArrearsRents: PeriodicArrearsRents = PeriodicArrearsRents()
    
    var body: some View {
        Form {
            Section(header: Text("\(currentFile)")) {
                ForEach(myPeriodicArrearsRents.items) { item in
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
                    Text("\(myPeriodicArrearsRents.items.count)")
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
            if myPeriodicArrearsRents.items.count > 0 {
                myPeriodicArrearsRents.items.removeAll()
            }
            myPeriodicArrearsRents.createTable(aInvestment: myInvestment)
        }
    }
}

#Preview {
    ArrearsRentsView(myInvestment: Investment(), path: .constant(([Int]())), isDark: .constant(false), currentFile: .constant("File is New"))
}
