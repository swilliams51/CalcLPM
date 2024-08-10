//
//  FeeView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/10/24.
//

import SwiftUI

struct FeeView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    
    var body: some View {
        Form{
            Section(header: Text("Details")) {
                HStack {
                    Text("Amount:")
                    Spacer()
                    Text("\(amountFormatter(amount: myInvestment.fee.amount, locale: .current))")
                }
                
                HStack {
                    Text("Date Paid:")
                    Spacer()
                    Text("\(myInvestment.fee.datePaid.toStringDateShort(yrDigits: 2))")
                    
                }
                
                HStack {
                    Text("Type:")
                    Spacer()
                    Text("\(myInvestment.fee.feeType.toString())")
                }
            }
            Section(header: Text("Submit Form")) {
                SubmitFormButtonsView(cancelName: "Cancel", doneName: "Done", cancel: myCancel, done: myDone, isDark: $isDark)
            }
        }
        .navigationBarTitle("Fee")
        
    }
    
    func myCancel() {
        path.removeLast()
    }
    func myDone() {
        path.removeLast()
    }
}

#Preview {
    FeeView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false))
}
