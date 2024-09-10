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
    @Binding var currentFile: String
    
    @State var myAmount: String = "2000.00"
    @State var myDatePaid: Date = Date()
    @State var myFeeType: FeeType = .expense
    
    var body: some View {
        Form{
            Section(header: Text("Details").font(myFont2), footer: (Text("FileName: \(currentFile)").font(myFont2))) {
                feeAmountItem
                datePaidItem
                feeTypeItem
            }
            Section(header: Text("Submit Form")) {
                SubmitFormButtonsView(cancelName: "Cancel", doneName: "Done", cancel: myCancel, done: myDone, isDark: $isDark)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarTitle("Fee")
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.myAmount = self.myInvestment.fee.amount
            self.myDatePaid = self.myInvestment.fee.datePaid
            self.myFeeType = self.myInvestment.fee.feeType
        }
    }
    
    var feeAmountItem: some View {
        HStack {
            Text("Amount:")
                .font(myFont2)
                .onTapGesture {
                    self.path.append(19)
                }
            Spacer()
            Text("\(amountFormatter(amount: myAmount, locale: .current))")
                .font(myFont2)
                .onTapGesture {
                    self.path.append(19)
                }
        }
    }
    
    var datePaidItem: some View {
        HStack {
            Text("Date Paid:")
                .font(myFont2)
            Spacer()
            Text("\(myDatePaid.toStringDateShort(yrDigits: 2))")
                .font(myFont2)
        }
    }
    
    var feeTypeItem: some View {
        HStack {
            Text("Type:")
                .font(myFont2)
            Picker(selection: $myFeeType, label: Text("")) {
                ForEach(FeeType.allTypes, id: \.self) { item in
                    Text(item.toString())
                        .font(myFont2)
                }
            }
        }
    }
        
    
    func myCancel() {
        path.removeLast()
    }
    func myDone() {
        self.myInvestment.fee.amount = myAmount
        self.myInvestment.fee.datePaid = myDatePaid
        self.myInvestment.fee.feeType = myFeeType
        path.removeLast()
    }
}

#Preview {
    FeeView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("Fole is New"))
}
