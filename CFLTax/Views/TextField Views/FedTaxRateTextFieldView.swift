//
//  FedTaxRateTextFieldView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/18/24.
//

import SwiftUI

struct FedTaxRateTextFieldView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    
    @State var myTaxRate: String = ""
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
            Section (header: Text("Enter Tax Rate")){
                federalTaxRateItem
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
        .navigationTitle("Federal Tax Rate")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .environment(\.colorScheme, isDark ? .dark : .light)
        .onAppear{
            self.percentOnEntry = myInvestment.taxAssumptions.federalTaxRate
            self.myTaxRate = myInvestment.taxAssumptions.federalTaxRate
        }
    }
    var federalTaxRateItem: some View {
        HStack{
            leftSideAmountItem
            Spacer()
            rightSideAmountItem
        }
    }
    
    var leftSideAmountItem: some View {
        HStack {
            Text("Tax Rate: \(Image(systemName: "return"))")
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
                      text: $myTaxRate,
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
            return myTaxRate
        } else {
            return percentFormatter(percent: myTaxRate, locale: myLocale, places: 2)
        }
    }
}


#Preview {
    FedTaxRateTextFieldView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false))
}

extension FedTaxRateTextFieldView {
    func updateForCancel() {
        if self.editPercentStarted == true {
            self.myTaxRate = self.percentOnEntry
            self.editPercentStarted = false
        }
        self.percentIsFocused = false
    }
    
    func copyToClipboard() {
        if self.percentIsFocused {
            pasteBoard.string = self.myTaxRate
        }
    }
    
    func paste() {
        if var string = pasteBoard.string {
            string.removeAll(where: { removeCharacters.contains($0) } )
            if string.isDecimal() {
                if self.percentIsFocused {
                    self.myTaxRate = string
                }
            }
        }
    }
    
    func clearAllText() {
        if self.percentIsFocused == true {
            self.myTaxRate = ""
        }
    }
   
    func updateForSubmit() {
        if self.editPercentStarted == true {
            updateForNewTaxRate()
            path.removeLast()
        }
        self.percentIsFocused = false
    }
    
    func updateForNewTaxRate() {
        if isAmountValid(strAmount: myTaxRate, decLow: 0.0, decHigh: maximumPercent, inclusiveLow: true, inclusiveHigh: true) == false {
            self.myTaxRate = self.percentOnEntry
            alertTitle = alertMaxResidual
            showAlert.toggle()
        } else {
            //Amount is Valid
            self.myInvestment.economics.discountRateForRent = myTaxRate
        }
            
        self.editPercentStarted = false
    }
    
}

let alertMaxFedTaxRate: String = "The calculated Lease/Loan amount exceeds the maximum allowable amount (50,000,000). As a result, the Lease/Loan will be reset to the default parameters.  It is likely that one or more of the Payment Groups has an incorrect payment amount!"
