//
//  AfterTaxEndingBalanceView.swift
//  CFLTax
//
//  Created by Steven Williams on 9/11/24.
//

import SwiftUI

struct AfterTaxEndingBalanceView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    
    @State var myAmortizations: Amortizations = Amortizations()
    
    var body: some View {
       Form {
           Section(header: Text("Schedule")) {
               if myAmortizations.items.count == 0 {
                   VStack {
                       Text("No Cashflows")
                   }
               } else {
                   ForEach(myAmortizations.items) { item in
                       HStack {
                           Text("\(item.beginDate.toStringDateShort(yrDigits: 2))")
                           Spacer()
                           Text("\(amountFormatter(amount: item.balance.toString(decPlaces: 2), locale: myLocale))")
                       }
                   }
               }
           }
           Section(header: Text("Totals")) {
               if myAmortizations.items.count == 0 {
                   VStack {
                       Text("No Totals")
                   }
               } else {
                   VStack {
                       HStack {
                           Text("Total Interest:")
                           Spacer()
                           Text("\(amountFormatter(amount: myAmortizations.getTotalInterest().toString(decPlaces: 2), locale: myLocale))")
                       }
                       HStack {
                           Text("Total Principal Repaid")
                           Spacer()
                           Text("\(amountFormatter(amount: myAmortizations.getTotalPrincipalPaid().toString(decPlaces: 2), locale: myLocale))")
                       }
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
       .navigationTitle("A/T Ending Balances")
       .navigationBarTitleDisplayMode(.inline)
       .navigationBarBackButtonHidden(true)
       .onAppear {
           self.myInvestment.calculate()
           myAmortizations.createAmortizations(investCashflows: myInvestment.afterTaxCashflows, interestRate: myInvestment.getMISF_AT_Yield(), dayCountMethod: myInvestment.economics.dayCountMethod)
           
       }
    }
}

#Preview {
    AfterTaxEndingBalanceView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false))
}
