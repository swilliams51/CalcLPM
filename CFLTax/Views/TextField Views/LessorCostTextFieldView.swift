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
    
    @State var myLessorCost: String = ""
    @State private var editLessorCostStarted: Bool = false
    @State private var maximumCost: Decimal = 1.0
    @FocusState private var costIsFocused: Bool
    @State private var showPopover: Bool = false
    private let pasteBoard = UIPasteboard.general
    
    @State private var costOnEntry: String = ""
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
            self.costOnEntry = myInvestment.asset.lessorCost
            self.maximumCost = maximumLessorCost.toDecimal()
            self.myLessorCost = myInvestment.asset.lessorCost
            
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
                .foregroundColor(.black)
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
                      text: $myLessorCost,
              onEditingChanged: { (editing) in
                if editing == true {
                    self.editLessorCostStarted = true
            }})
                .keyboardType(.decimalPad).foregroundColor(.clear)
                .focused($costIsFocused)
                .textFieldStyle(PlainTextFieldStyle())
                .disableAutocorrection(true)
                .accentColor(.clear)
            Text("\(amountFormatted(editStarted: editLessorCostStarted))")
                .font(myFont)
                .foregroundColor(isDark ? .white : .black)
        }
    }
    
    func amountFormatted(editStarted: Bool) -> String {
        if editStarted == true {
            return myLessorCost
        } else {
            return amountFormatter(amount: myLessorCost, locale: myLocale)
        }
    }
    
}

#Preview {
    LessorCostTextFieldView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false))
}


extension LessorCostTextFieldView {
    func updateForCancel() {
        if self.editLessorCostStarted == true {
            self.myLessorCost = self.costOnEntry
            self.editLessorCostStarted = false
        }
        self.costIsFocused = false
    }
    
    func copyToClipboard() {
        if self.costIsFocused {
            pasteBoard.string = self.myLessorCost
        }
    }
    
    func paste() {
        if var string = pasteBoard.string {
            string.removeAll(where: { removeCharacters.contains($0) } )
            if string.isDecimal() {
                if self.costIsFocused {
                    self.myLessorCost = string
                }
            }
        }
    }
    
    func clearAllText() {
        if self.costIsFocused == true {
            self.myLessorCost = ""
        }
    }
   
    func updateForSubmit() {
        if self.editLessorCostStarted == true {
            updateForLeaseAmount()
            path.removeLast()
        }
        self.costIsFocused = false
    }
    
    func updateForLeaseAmount() {
        if isAmountValid(strAmount: myLessorCost, decLow: 0.0, decHigh: maximumLessorCost.toDecimal(), inclusiveLow: true, inclusiveHigh: true) == false {
            self.myLessorCost = self.costOnEntry
            alertTitle = alertMaxAmount
            showAlert.toggle()
        } else {
            //Amount is Valid
            //self.myLease.resetPaymentAmountToMax()
        }
            
        self.editLessorCostStarted = false
    }
    
}

let alertMaxAmount: String = "The calculated Lease/Loan amount exceeds the maximum allowable amount (50,000,000). As a result, the Lease/Loan will be reset to the default parameters.  It is likely that one or more of the Payment Groups has an incorrect payment amount!"
