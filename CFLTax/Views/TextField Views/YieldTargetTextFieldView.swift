//
//  YieldTargetTextFieldView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/18/24.
//

import SwiftUI

struct YieldTargetTextFieldView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    
    @State var myPercent: String = ""
    @State private var editPercentStarted: Bool = false
    @State private var maximumPercent: Decimal = 1.0
    @FocusState private var percentIsFocused: Bool
    @State private var showPopover: Bool = false
    private let pasteBoard = UIPasteboard.general
    
    @State private var percentOnEntry: String = ""
    @State private var alertTitle: String = ""
    @State private var showAlert: Bool = false
    @State var payHelp = leaseAmountHelp
    
    var body: some View {
        Form {
            Section (header: Text("Enter New Percent")) {
                discountRateItem
            }
            .font(myFont2)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
            ToolbarItemGroup(placement: .keyboard){
                DecimalPadButtonsView(cancel: updateForCancel, copy: copyToClipboard, paste: paste, clear: clearAllText, enter: updateForSubmit, isDark: $isDark)
            }
        }
        .navigationTitle("Yield Target")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .environment(\.colorScheme, isDark ? .dark : .light)
        .onAppear{
            self.percentOnEntry = myInvestment.economics.yieldTarget
            self.myPercent = myInvestment.economics.yieldTarget
        }
    }
    var discountRateItem: some View {
        HStack{
            leftSideAmountItem
            Spacer()
            rightSideAmountItem
        }
    }
    
    var leftSideAmountItem: some View {
        HStack {
            Text("Target Yield: \(Image(systemName: "return"))")
                .foregroundColor(isDark ? .white : .black)
                .font(myFont2)
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
                      text: $myPercent,
              onEditingChanged: { (editing) in
                if editing == true {
                    self.editPercentStarted = true
            }})
                .keyboardType(.decimalPad).foregroundColor(.clear)
                .focused($percentIsFocused)
                .textFieldStyle(PlainTextFieldStyle())
                .disableAutocorrection(true)
                .accentColor(.clear)
            Text("\(percentFormatted(editStarted: editPercentStarted))")
                .font(myFont2)
                .foregroundColor(isDark ? .white : .black)
        }
    }
    
    func percentFormatted(editStarted: Bool) -> String {
        if editStarted == true {
            return myPercent
        } else {
            return percentFormatter(percent: myPercent, locale: myLocale, places: 2)
        }
    }
}

#Preview {
    YieldTargetTextFieldView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false))
}


extension YieldTargetTextFieldView {
    func updateForCancel() {
        if self.editPercentStarted == true {
            self.myPercent = self.percentOnEntry
            self.editPercentStarted = false
        }
        self.percentIsFocused = false
    }
    
    func copyToClipboard() {
        if self.percentIsFocused {
            pasteBoard.string = self.myPercent
        }
    }
    
    func paste() {
        if var string = pasteBoard.string {
            string.removeAll(where: { removeCharacters.contains($0) } )
            if string.isDecimal() {
                if self.percentIsFocused {
                    self.myPercent = string
                }
            }
        }
    }
    
    func clearAllText() {
        if self.percentIsFocused == true {
            self.myPercent = ""
        }
    }
   
    func updateForSubmit() {
        if self.editPercentStarted == true {
            updateForNewYield()
            path.removeLast()
        }
        self.percentIsFocused = false
    }
    
    func updateForNewYield() {
        if isAmountValid(strAmount: myPercent, decLow: 0.0, decHigh: maximumPercent, inclusiveLow: true, inclusiveHigh: true) == false {
            self.myPercent = self.percentOnEntry
            alertTitle = alertMaxResidual
            showAlert.toggle()
        } else {
            //Amount is Valid
            self.myInvestment.economics.discountRateForRent = myPercent
        }
            
        self.editPercentStarted = false
    }
    
}

let alertMaxTargetYield: String = "The calculated Lease/Loan amount exceeds the maximum allowable amount (50,000,000). As a result, the Lease/Loan will be reset to the default parameters.  It is likely that one or more of the Payment Groups has an incorrect payment amount!"
