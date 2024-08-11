//
//  AssetNameTextFieldView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/11/24.
//

import SwiftUI

struct AssetNameTextFieldView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    
    @State var myName: String = ""
    @State private var editNameStarted: Bool = false
    @FocusState private var nameIsFocused: Bool
    @State private var showPopover: Bool = false
    private let pasteBoard = UIPasteboard.general
    
    @State private var nameOnEntry: String = ""
    @State private var alertTitle: String = ""
    @State private var showAlert: Bool = false
    @State var payHelp = leaseAmountHelp
    
    var body: some View {
       
            Form {
                Section (header: Text("Enter New Name")) {
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
            .navigationTitle("Name")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden()
            .environment(\.colorScheme, isDark ? .dark : .light)
            .onAppear{
                self.nameOnEntry = myInvestment.asset.name
                self.myName = myInvestment.asset.name
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
            Text("Name: \(Image(systemName: "return"))")
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
                      text: $myName,
              onEditingChanged: { (editing) in
                if editing == true {
                    self.editNameStarted = true
            }})
                .keyboardType(.default).foregroundColor(.clear)
                .focused($nameIsFocused)
                .textFieldStyle(PlainTextFieldStyle())
                .disableAutocorrection(true)
                .accentColor(.clear)
            Text("\(myName)")
                .font(myFont)
                .foregroundColor(isDark ? .white : .black)
        }
    }
    
}

#Preview {
    AssetNameTextFieldView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false))
}


extension AssetNameTextFieldView {
    func updateForCancel() {
        if self.editNameStarted == true {
            self.myName = self.nameOnEntry
            self.editNameStarted = false
        }
        self.nameIsFocused = false
    }
    
    func copyToClipboard() {
        if self.nameIsFocused {
            pasteBoard.string = self.myName
        }
    }
    
    func paste() {
        if var string = pasteBoard.string {
            string.removeAll(where: { removeCharacters.contains($0) } )
            if string.isDecimal() {
                if self.nameIsFocused {
                    self.myName = string
                }
            }
        }
    }
    
    func clearAllText() {
        if self.nameIsFocused == true {
            self.myName = ""
        }
    }
   
    func updateForSubmit() {
        if self.editNameStarted == true {
            updateForAssetName()
            path.removeLast()
        }
        self.nameIsFocused = false
    }
    
    func updateForAssetName() {
        if isNameValid(strIn: myName) == false {
            self.myName = self.nameOnEntry
            alertTitle = alertName
            showAlert.toggle()
        } else {
            self.myInvestment.asset.name = myName
        }
            
        self.editNameStarted = false
    }
    
}

let alertName: String = "The calculated Lease/Loan amount exceeds the maximum allowable amount (50,000,000). As a result, the Lease/Loan will be reset to the default parameters.  It is likely that one or more of the Payment Groups has an incorrect payment amount!"
