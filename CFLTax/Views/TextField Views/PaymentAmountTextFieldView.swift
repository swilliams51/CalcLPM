//
//  PaymentAmountTextFieldView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/12/24.
//

import SwiftUI

struct PaymentAmountTextFieldView: View {
    @Bindable var myInvestment: Investment
    @Binding var selectedGroup: Group
    @Binding var index: Int
    @Binding var isDark: Bool
    @Binding var path: [Int]
    
    @State private var editPaymentAmountStarted: Bool = false
    @State private var isCalculatedPayment: Bool = false
    @State private var maximumAmount: Decimal = 1.0
    @FocusState private var amount3IsFocused: Bool
    @State private var showPopover: Bool = false
    private let pasteBoard = UIPasteboard.general
    
    @State private var paymentOnEntry: String = ""
    @State private var alertTitle: String = ""
    @State private var showAlert: Bool = false
    @State var payHelp = paymentAmountHelp
    
    var body: some View {
        Form {
            Section (header: Text("Enter New Payment")){
                paymentAmountItem
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
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .environment(\.colorScheme, isDark ? .dark : .light)
        .onAppear{
            if self.selectedGroup.isCalculatedPaymentType() {
                self.isCalculatedPayment = true
            }
            self.paymentOnEntry = self.selectedGroup.amount
            self.maximumAmount = myInvestment.asset.lessorCost.toDecimal()
        }
    }
    
    var paymentAmountItem: some View {
        HStack{
            leftSideAmountItem
            Spacer()
            rightSideAmountItem
        }
    }
    
    var leftSideAmountItem: some View {
        HStack {
            Text(isCalculatedPayment ? "amount:" : "amount: \(Image(systemName: "return"))")
                .font(.subheadline)
                .foregroundColor(isDark ? .white : .black)
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
              text: $selectedGroup.amount,
              onEditingChanged: { (editing) in
                if editing == true {
                    self.editPaymentAmountStarted = true
            }})
                //.disabled(pmtTextFieldIsLocked)
                .keyboardType(.decimalPad).foregroundColor(.clear)
                .focused($amount3IsFocused)
                .textFieldStyle(PlainTextFieldStyle())
                .disableAutocorrection(true)
                .accentColor(.clear)
            Text("\(paymentFormatted(editStarted: editPaymentAmountStarted))")
                .font(.subheadline)
                .foregroundColor(isDark ? .white : .black)
        }
        
    }
    
    func paymentFormatted(editStarted: Bool) -> String {
        if isCalculatedPayment == true {
            return selectedGroup.amount
        } else {
            if editStarted == true {
                return selectedGroup.amount
            }
            return amountFormatter(amount: selectedGroup.amount, locale: myLocale)
        }
    }
    
}

#Preview {
    PaymentAmountTextFieldView(myInvestment: Investment(), selectedGroup: .constant(Group()), index: .constant(1), isDark: .constant(false), path: .constant([Int]()))
}

extension PaymentAmountTextFieldView {
    func updateForCancel() {
        if self.editPaymentAmountStarted == true {
            self.selectedGroup.amount = self.paymentOnEntry
            self.editPaymentAmountStarted = false
        }
        self.amount3IsFocused = false
    }
    
    func copyToClipboard() {
        if self.amount3IsFocused {
            pasteBoard.string = self.selectedGroup.amount
        }
    }
    
    func paste() {
        if var string = pasteBoard.string {
            string.removeAll(where: { removeCharacters.contains($0) } )
            if string.isDecimal() {
                if self.amount3IsFocused {
                    self.selectedGroup.amount = string
                }
            }
        }
    }
    
    func clearAllText() {
        if self.amount3IsFocused == true {
            self.selectedGroup.amount = ""
        }
    }
   
    func updateForSubmit() {
        if self.editPaymentAmountStarted == true {
            updateForPaymentAmount()
            self.myInvestment.rent.groups[index].amount = self.selectedGroup.amount
            path.removeLast()
        }
        self.amount3IsFocused = false
    }
    
    func updateForPaymentAmount() {
        
        if selectedGroup.amount == "" {
            self.selectedGroup.amount = "0.00"
        }

       
        if self.selectedGroup.amount.toDecimal() > 0.00 && self.selectedGroup.amount.toDecimal() < 1.0 {
            self.selectedGroup.amount = percentToAmount(percent:  selectedGroup.amount)
        }
        
        if isAmountValid(strAmount: selectedGroup.amount, decLow: 0.0, decHigh: maximumAmount, inclusiveLow: true, inclusiveHigh: true) == false {
            
            self.selectedGroup.amount = self.paymentOnEntry
            alertTitle = alertPaymentAmount
            showAlert.toggle()
        }
        
        if selectedGroup.amount.toDecimal() == 0.00 {
            selectedGroup.locked = true
        }
            
        self.editPaymentAmountStarted = false
    }
    
    func percentToAmount(percent: String) -> String {
        let decAmount: Decimal = percent.toDecimal() * myInvestment.asset.lessorCost.toDecimal()
        return decAmount.toString(decPlaces: 2)
    }
    
}
