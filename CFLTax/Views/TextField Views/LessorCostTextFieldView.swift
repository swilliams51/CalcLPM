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
    
    @State var myAmount: String = ""
    @State private var editAmountStarted: Bool = false
    @State private var maximumAmount: Decimal = 1.0
    @FocusState private var amountIsFocused: Bool
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
            self.amountOnEntry = myInvestment.asset.lessorCost
            self.maximumAmount = maximumLessorCost.toDecimal()
            self.myAmount = myInvestment.asset.lessorCost
            
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
                      text: $myAmount,
              onEditingChanged: { (editing) in
                if editing == true {
                    self.editAmountStarted = true
            }})
                .keyboardType(.decimalPad).foregroundColor(.clear)
                .focused($amountIsFocused)
                .textFieldStyle(PlainTextFieldStyle())
                .disableAutocorrection(true)
                .accentColor(.clear)
            Text("\(amountFormatted(editStarted: editAmountStarted))")
                .font(myFont)
                .foregroundColor(isDark ? .white : .black)
        }
    }
    
    func amountFormatted(editStarted: Bool) -> String {
        if editStarted == true {
            return myAmount
        } else {
            return amountFormatter(amount: myAmount, locale: myLocale)
        }
    }
    
}

#Preview {
    LessorCostTextFieldView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false))
}


extension LessorCostTextFieldView {
    func updateForCancel() {
        if self.editAmountStarted == true {
            self.myAmount = self.amountOnEntry
            self.editAmountStarted = false
        }
        self.amountIsFocused = false
    }
    
    func copyToClipboard() {
        if self.amountIsFocused {
            pasteBoard.string = self.myAmount
        }
    }
    
    func paste() {
        if var string = pasteBoard.string {
            string.removeAll(where: { removeCharacters.contains($0) } )
            if string.isDecimal() {
                if self.amountIsFocused {
                    self.myAmount = string
                }
            }
        }
    }
    
    func clearAllText() {
        if self.amountIsFocused == true {
            self.myAmount = ""
        }
    }
   
    func updateForSubmit() {
        if self.editAmountStarted == true {
            updateForLeaseAmount()
            path.removeLast()
        }
        self.amountIsFocused = false
    }
    
    func updateForLeaseAmount() {
        if isAmountValid(strAmount: myAmount, decLow: 0.0, decHigh: maximumLessorCost.toDecimal(), inclusiveLow: true, inclusiveHigh: true) == false {
            self.myAmount = self.amountOnEntry
            alertTitle = alertMaxAmount
            showAlert.toggle()
        } else {
            //Amount is Valid
            self.myInvestment.asset.lessorCost = myAmount
        }
            
        self.editAmountStarted = false
    }
    
}

let alertMaxAmount: String = "The calculated Lease/Loan amount exceeds the maximum allowable amount (50,000,000). As a result, the Lease/Loan will be reset to the default parameters.  It is likely that one or more of the Payment Groups has an incorrect payment amount!"
