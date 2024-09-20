//
//  TerminationValuesView.swift
//  CFLTax
//
//  Created by Steven Williams on 9/20/24.
//

import SwiftUI

struct TerminationValuesView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    
    @State var myTValues: TerminationValues = TerminationValues()

    var body: some View {
        Form {
            Section(header: Text("Termination Values")) {
                ForEach(myTValues.items) { item in
                    HStack {
                        Text("\(item.dueDate.toStringDateShort(yrDigits: 2))")
                        Spacer()
                        Text("\(amountFormatter(amount: item.amount, locale: myLocale))")
                    }
                }
            }
           
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationTitle("Termination Values")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if myTValues.items.count > 0 {
                myTValues.items.removeAll()
            }
            myTValues.createTerminationValues(aInvestment: myInvestment)
        }
    }
}

#Preview {
    TerminationValuesView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false))
}
