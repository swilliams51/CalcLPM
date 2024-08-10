//
//  LessorCostTexFieldView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/9/24.
//

import SwiftUI

struct LessorCostTextFieldView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    
    @State private var editLeaseAmountStarted: Bool = false
    @State private var maximumAmount: Decimal = 1.0
    @FocusState private var amount2IsFocused: Bool
    @State private var showPopover: Bool = false
    private let pasteBoard = UIPasteboard.general
    
    @State private var amountOnEntry: String = ""
    @State private var alertTitle: String = ""
    @State private var showAlert: Bool = false
    @State var payHelp = leaseAmountHelp
    
    var body: some View {
        Form {
            Section (header: Text("Enter New Amount")) {
                leaseAmountItem
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
            ToolbarItemGroup(placement: .keyboard){
                DecimalPadButtonsView(cancel: updateForCancel, copy: copyToClipboard, paste: paste, clear: clearAllText, enter: updateForSubmit, isDark: $isDark)
            }
        }
        .navigationTitle("Amount")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .environment(\.colorScheme, isDark ? .dark : .light)
        .onAppear{
            self.maximumAmount = maximumLeaseAmount.toDecimal()
        }
    }
    var leaseAmountItem: some View {
        HStack{
            leftSideAmountItem
            Spacer()
            rightSideAmountItem
        }
    }
    
    var leftSideAmountItem: some View {
        HStack {
            Text("amount: \(Image(systemName: "return"))")
                .foregroundColor(isDark ? .white : .black)
                .font(myFont)
            Image(systemName: "questionmark.circle")
                .foregroundColor(Color.theme.accent)
                .onTapGesture {
                    self.showPopover = true
                }
        }
        .popover(isPresented: $showPopover) {
            PopoverView(myHelp: $payHelp, isDark: $isDark)
        }
    }
    
    var rightSideAmountItem: some View {
        ZStack(alignment: .trailing) {
            TextField("",
              text: $myLease.amount,
              onEditingChanged: { (editing) in
                if editing == true {
                    self.editLeaseAmountStarted = true
            }})
                .keyboardType(.decimalPad).foregroundColor(.clear)
                .focused($amount2IsFocused)
                .textFieldStyle(PlainTextFieldStyle())
                .disableAutocorrection(true)
                .accentColor(.clear)
            Text("\(amountFormatted(editStarted: editLeaseAmountStarted))")
                .font(myFont)
                .foregroundColor(isDark ? .white : .black)
        }
    }
    
    func amountFormatted(editStarted: Bool) -> String {
        if editStarted == true {
            return myLease.amount
        } else {
            return amountFormatter(amount: myLease.amount, locale: myLocale)
        }
    }
    
}

#Preview {
    LessorCostTextFieldView()
}





extension LessorCostTextFieldView {
    func updateForCancel() {
        if self.editLeaseAmountStarted == true {
            self.myLease.amount = self.amountOnEntry
            self.editLeaseAmountStarted = false
        }
        self.amount2IsFocused = false
    }
    
    func copyToClipboard() {
        if self.amount2IsFocused {
            pasteBoard.string = self.myLease.amount
        }
    }
    
    func paste() {
        if var string = pasteBoard.string {
            string.removeAll(where: { removeCharacters.contains($0) } )
            if string.isDecimal() {
                if self.amount2IsFocused {
                    self.myLease.amount = string
                }
            }
        }
    }
    
    func clearAllText() {
        if self.amount2IsFocused == true {
            self.myLease.amount = ""
        }
    }
   
    func updateForSubmit() {
        if self.editLeaseAmountStarted == true {
            updateForLeaseAmount()
            path.removeLast()
        }
        self.amount2IsFocused = false
    }
    
    func updateForLeaseAmount() {
        if isAmountValid(strAmount: myLease.amount, decLow: 0.0, decHigh: maximumAmount, inclusiveLow: true, inclusiveHigh: true) == false {
            self.myLease.amount = self.amountOnEntry
            alertTitle = alertPaymentAmount
            showAlert.toggle()
        } else {
            //Amount is Valid
            self.myLease.resetPaymentAmountToMax()
        }
            
        self.editLeaseAmountStarted = false
    }
    
}

let alertMaxAmount: String = "The calculated Lease/Loan amount exceeds the maximum allowable amount (50,000,000). As a result, the Lease/Loan will be reset to the default parameters.  It is likely that one or more of the Payment Groups has an incorrect payment amount!"
