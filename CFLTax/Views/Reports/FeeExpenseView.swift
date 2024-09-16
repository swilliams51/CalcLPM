//
//  FeeExpenseView.swift
//  CFLTax
//
//  Created by Steven Williams on 9/9/24.
//

import SwiftUI

struct FeeExpenseView: View {
    @Bindable var myInvestment: Investment
    @Bindable var myFeeAmortization: FeeIncomes
    @Binding var path: [Int]
    @Binding var isDark: Bool
    
    var body: some View {
       Form {
           Section(header: Text("Schedule")) {
               ForEach(myFeeAmortization.items) { item in
                   HStack {
                       Text("\(item.dueDate.toStringDateShort(yrDigits: 2))")
                       Spacer()
                       Text("\(amountFormatter(amount: item.amount, locale: myLocale))")
                   }
               }
           }
           
           Section(header: Text("Totals")) {
               HStack {
                   Text("\(myFeeAmortization.items.count)")
                   Spacer()
                   Text("\(amountFormatter(amount: myFeeAmortization.getTotal().toString(decPlaces: 4), locale: myLocale))")
               }
           }
       }
       .toolbar {
           ToolbarItem(placement: .topBarLeading) {
               BackButtonView(path: $path, isDark: $isDark)
           }
       }
       .environment(\.colorScheme, isDark ? .dark : .light)
       .navigationTitle("Fee Amortization")
       .navigationBarTitleDisplayMode(.inline)
       .navigationBarBackButtonHidden(true)
       .onAppear {
           if myFeeAmortization.items.count > 0 {
               myFeeAmortization.items.removeAll()
           }
           myFeeAmortization.createTable(aInvestment: myInvestment)
       }
    }
}


#Preview {
    FeeExpenseView(myInvestment: Investment(), myFeeAmortization: FeeIncomes(), path: .constant([Int]()), isDark: .constant(false))
}
