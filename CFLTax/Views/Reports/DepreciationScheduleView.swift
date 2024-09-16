//
//  DepreciationScheduleView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/21/24.
//

import SwiftUI

struct DepreciationScheduleView: View {
    @Bindable var myInvestment: Investment
    @Bindable var myDepreciationSchedule: DepreciationIncomes
    @Binding var path: [Int]
    @Binding var isDark: Bool
    
    var body: some View {
        Form {
            Section(header: Text("Schedule")) {
                ForEach(myDepreciationSchedule.items) { item in
                    HStack {
                        Text("\(item.dueDate.toStringDateShort(yrDigits: 2))")
                        Spacer()
                        Text("\(amountFormatter(amount: item.amount, locale: myLocale))")
                    }
                }
            }
            
            Section(header: Text("Totals")) {
                HStack {
                    Text("\(myDepreciationSchedule.items.count)")
                    Spacer()
                    Text("\(amountFormatter(amount: myDepreciationSchedule.getTotal().toString(decPlaces: 4), locale: myLocale))")
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationTitle("Deprec Schedule")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if myDepreciationSchedule.items.count > 0 {
                myDepreciationSchedule.items.removeAll()
            }
            myDepreciationSchedule.createTable(aInvestment: myInvestment)
        }
    }
}

#Preview {
    DepreciationScheduleView(myInvestment: Investment(), myDepreciationSchedule: DepreciationIncomes(), path: .constant([Int]()), isDark: .constant(false))
}
