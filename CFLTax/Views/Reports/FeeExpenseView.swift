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
    @Binding var currentFile: String
    
    @State var viewAsPct: Bool = false
    
    var body: some View {
        VStack {
            ReportHeaderView(name: "Fee Amortization", viewAsPct: myViewAsPct, path: $path, isDark: $isDark)
            Form {
               Section(header: Text("\(currentFile)")) {
                   ForEach(myFeeAmortization.items) { item in
                       HStack {
                           Text("\(item.dueDate.toStringDateShort(yrDigits: 2))")
                           Spacer()
                           Text("\(getFormattedValue(amount: item.amount, viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment))")
                       }
                       .font(myFont)
                   }
               }
               
               Section(header: Text("Totals")) {
                   HStack {
                       Text("\(myFeeAmortization.items.count)")
                       Spacer()
                       Text("\(amountFormatter(amount: myFeeAmortization.getTotal().toString(decPlaces: 4), locale: myLocale))")
                   }
                   .font(myFont)
               }
           }
        }
        
       .environment(\.colorScheme, isDark ? .dark : .light)
       .navigationBarBackButtonHidden(true)
       .onAppear {
           if myFeeAmortization.items.count > 0 {
               myFeeAmortization.items.removeAll()
           }
           myFeeAmortization.createTable(aInvestment: myInvestment)
       }
    }
    
    private func myViewAsPct() {
        self.viewAsPct.toggle()
    }
}


#Preview {
    FeeExpenseView(myInvestment: Investment(), myFeeAmortization: FeeIncomes(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
