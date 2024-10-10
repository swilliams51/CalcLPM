//
//  AssetView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/9/24.
//

import SwiftUI

struct AssetView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var myAsset: Asset = Asset()
    // Asset Name Textfield
    @State private var editNameStarted: Bool = false
    @State private var fundingDateHasChanged: Bool = false
    @State private var nameOnEntry: String = ""
    @FocusState private var nameIsFocused: Bool
    //Lessor Cost TextField
    @State private var editLessorStarted: Bool = false
    @State private var maxLessorCost: Decimal = 1.0
    @State private var lessorCostOnEntry: String = ""
    @FocusState private var lessorCostIsFocused: Bool
    //Residual value TextField
    @State private var editResidualValueStarted: Bool = false
    @State private var maximumResidualValue: Decimal = 1.0
    @State private var residualValueOnEntry: String = ""
    @FocusState private var residualValueIsFocused: Bool
    //Lessee Guaranty TextField
    @State private var editLesseeGuarantyStarted: Bool = false
    @State private var maximumGuaranty: Decimal = 1.0
    @FocusState private var lesseeGuarantyIsFocused: Bool
    @State private var lesseeGuarantyOnEntry: String = ""
    
    @State private var alertTitle: String = ""
    @State private var showAlert: Bool = false
    @State private var showPopover: Bool = false
    @State var payHelp = leaseAmountHelp
    private let pasteBoard = UIPasteboard.general
    
    
    var body: some View {
        Form {
            Section(header: Text("Details").font(myFont2), footer: (Text("FileName: \(currentFile)").font(myFont2))) {
                assetNameItem
                lessorCostItem
                residualAmountItem
                lesseeGuarantyItem
                
                
            }
            Section(header: Text("Submit Form")) {
                SubmitFormButtonsView(cancelName: "Cancel", doneName: "Done", cancel: myCancel, done: myDone, isDark: $isDark)
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
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarTitle("Asset")
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.myAsset = myInvestment.asset
        }
    }
    
    private func myCancel() {
        path.removeLast()
    }
    
    private func myDone() {
        if myAsset.fundingDate != myInvestment.asset.fundingDate {
            self.fundingDateHasChanged = true
        }
        if myInvestment.asset.isEqual(to: myAsset) == false {
            myInvestment.asset = self.myAsset
            myInvestment.hasChanged = true
            if self.fundingDateHasChanged == true {
                self.myInvestment.resetForFundingDateChange()
            }
        }
        path.removeLast()
    }
    
}

#Preview {
    AssetView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}



//Asset Name TextField
extension AssetView {
    var assetNameItem: some View {
        HStack{
            leftSideAssetNameItem
            Spacer()
            rightSideAssetNameItem
        }
    }
    
    var leftSideAssetNameItem: some View {
        HStack {
            Text("Name: \(Image(systemName: "return"))")
                .foregroundColor(isDark ? .white : .black)
                .font(myFont)
        }
    }
    
    var rightSideAssetNameItem: some View {
        ZStack(alignment: .trailing) {
            TextField("",
                      text: $myAsset.name,
              onEditingChanged: { (editing) in
                if editing == true {
                    self.editNameStarted = true
            }})
            .onSubmit {
                updateForSubmit()
            }
                .keyboardType(.default).foregroundColor(.clear)
                .focused($nameIsFocused)
                .textFieldStyle(PlainTextFieldStyle())
                .disableAutocorrection(true)
                .accentColor(.clear)
            Text("\(myAsset.name)")
                .font(myFont2)
                .foregroundColor(isDark ? .white : .black)
        }
    }
    
}

// Lessor Cost TextField
extension AssetView {
    var lessorCostItem: some View {
        HStack{
            leftSideLessorCostItem
            Spacer()
            rightSideLessorCostItem
        }
    }
    
    var leftSideLessorCostItem: some View {
        HStack {
            Text("Lessor Cost: \(Image(systemName: "return"))")
                .font(myFont)
                .foregroundColor(isDark ? .white : .black)
        }
    }
    
    var rightSideLessorCostItem: some View {
        ZStack(alignment: .trailing) {
            TextField("",
                      text: $myAsset.lessorCost,
              onEditingChanged: { (editing) in
                if editing == true {
                    self.editLessorStarted = true
            }})
                .keyboardType(.decimalPad).foregroundColor(.clear)
                .focused($lessorCostIsFocused)
                .textFieldStyle(PlainTextFieldStyle())
                .disableAutocorrection(true)
                .accentColor(.clear)
            Text("\(amountFormatted(editStarted: editLessorStarted))")
                .font(myFont2)
                .foregroundColor(isDark ? .white : .black)
        }
    }
    
    func amountFormatted(editStarted: Bool) -> String {
        if editStarted == true {
            return myAsset.lessorCost
        } else {
            return amountFormatter(amount: myAsset.lessorCost, locale: myLocale)
        }
    }
}

//Residual Value TextField
extension AssetView {
    var residualAmountItem: some View {
        HStack{
            leftSideResidualValueItem
            Spacer()
            rightSideResidualValueItem
        }
    }
    
    var leftSideResidualValueItem: some View {
        HStack {
            Text("Residual Value: \(Image(systemName: "return"))")
                .foregroundColor(isDark ? .white : .black)
                .font(myFont)
        }
        .popover(isPresented: $showPopover) {
            PopoverView(myHelp: $payHelp, isDark: $isDark)
        }
    }
    
    var rightSideResidualValueItem: some View {
        ZStack(alignment: .trailing) {
            TextField("",
                      text: $myAsset.residualValue,
              onEditingChanged: { (editing) in
                if editing == true {
                    self.editResidualValueStarted = true
            }})
                .keyboardType(.decimalPad).foregroundColor(.clear)
                .focused($residualValueIsFocused)
                .textFieldStyle(PlainTextFieldStyle())
                .disableAutocorrection(true)
                .accentColor(.clear)
            Text("\(residualValueFormatted(editStarted: editResidualValueStarted))")
                .font(myFont2)
                .foregroundColor(isDark ? .white : .black)
        }
    }
    
    func residualValueFormatted(editStarted: Bool) -> String {
        if editStarted == true {
            return myAsset.residualValue
        } else {
            return amountFormatter(amount: myAsset.residualValue, locale: myLocale)
        }
    }
}

//Lessee Guaranty
extension AssetView {
    var lesseeGuarantyItem: some View {
        HStack{
            leftSideLesseeGuarantyItem
            Spacer()
            rightSideLesseeGuarantyItem
        }
    }
    
    var leftSideLesseeGuarantyItem: some View {
        HStack {
            Text("Lessee Guaranty: \(Image(systemName: "return"))")
                .foregroundColor(isDark ? .white : .black)
                .font(myFont)
        }
        .popover(isPresented: $showPopover) {
            PopoverView(myHelp: $payHelp, isDark: $isDark)
        }
    }
    
    var rightSideLesseeGuarantyItem: some View {
        ZStack(alignment: .trailing) {
            TextField("",
                      text: $myAsset.lesseeGuarantyAmount,
              onEditingChanged: { (editing) in
                if editing == true {
                    self.editLesseeGuarantyStarted = true
            }})
                .keyboardType(.decimalPad).foregroundColor(.clear)
                .focused($lesseeGuarantyIsFocused)
                .textFieldStyle(PlainTextFieldStyle())
                .disableAutocorrection(true)
                .accentColor(.clear)
            Text("\(lesseeGuarantyFormatted(editStarted: editLesseeGuarantyStarted))")
                .font(myFont2)
                .foregroundColor(isDark ? .white : .black)
        }
    }
    
    func lesseeGuarantyFormatted(editStarted: Bool) -> String {
        if editStarted == true {
            return myAsset.lesseeGuarantyAmount
        } else {
            return amountFormatter(amount: myAsset.lesseeGuarantyAmount, locale: myLocale)
        }
    }
}

extension AssetView {
    func updateForCancel() {
        switch getFocusedTextField() {
        case .assetName:
            if self.editNameStarted == true {
                self.myAsset.name = self.nameOnEntry
                self.editNameStarted = false
            }
            self.nameIsFocused = false
        case .lessorCost:
            if self.editLessorStarted == true {
                self.myAsset.lessorCost = self.lessorCostOnEntry
                self.editLessorStarted = false
            }
            self.lessorCostIsFocused = false
        case .residualValue:
            if self.editResidualValueStarted == true {
                self.myAsset.residualValue = self.residualValueOnEntry
                editResidualValueStarted = false
            }
            self.residualValueIsFocused = false
        case .lesseeGuaranty:
            if self.editLesseeGuarantyStarted == true {
                self.myAsset.lesseeGuarantyAmount = self.lesseeGuarantyOnEntry
                editResidualValueStarted = false
            }
            self.lesseeGuarantyIsFocused = false
        default :
            self.nameIsFocused = false
        }
    }
    
    func copyToClipboard() {
        switch getFocusedTextField() {
        case .assetName:
            pasteBoard.string = self.myAsset.name
        case .lessorCost:
            pasteBoard.string = self.myAsset.lessorCost
        case .residualValue:
            pasteBoard.string = self.myAsset.residualValue
        case .lesseeGuaranty:
            pasteBoard.string = self.myAsset.lesseeGuarantyAmount
        default :
            pasteBoard.string = ""
        }
    }
    
    func paste() {
        if var string = pasteBoard.string {
            string.removeAll(where: { removeCharacters.contains($0) } )
            if string.isDecimal() {
                switch getFocusedTextField() {
                case .assetName:
                    self.myAsset.name = string
                case .lessorCost:
                    self.myAsset.lessorCost = string
                case .residualValue:
                    self.myAsset.residualValue = string
                case .lesseeGuaranty:
                    self.myAsset.lesseeGuarantyAmount = string
                default:
                    string = ""
                }
            }
        }
    }
    
    func clearAllText() {
        switch getFocusedTextField() {
        case .assetName:
            self.myAsset.name = ""
        case .lessorCost:
            self.myAsset.lessorCost = ""
        case .residualValue:
            self.myAsset.residualValue = ""
        case .lesseeGuaranty:
            self.myAsset.lesseeGuarantyAmount = ""
        default:
            self.myAsset.name = ""
        }
    }
    
    func updateForSubmit() {
        switch getFocusedTextField() {
        case .assetName:
            updateForAssetName()
            self.nameIsFocused = false
        case .lessorCost:
            updateForLessorCost()
            self.lessorCostIsFocused = false
        case .residualValue:
            updateForResidualAmount()
            self.residualValueIsFocused = false
        case .lesseeGuaranty:
            updateForLesseeGuaranty()
            self.lesseeGuarantyIsFocused = false
        default:
            break
        }
    }
    
    func updateForAssetName() {
        if isNameValid(strIn: myAsset.name) == false {
            self.myAsset.name = self.nameOnEntry
            alertTitle = alertName
            showAlert.toggle()
        }
        
        self.editNameStarted = false
    }
    
    func updateForLessorCost() {
        if isAmountValid(strAmount: myAsset.lessorCost, decLow: minimumLessorCost.toDecimal(), decHigh: maxLessorCost, inclusiveLow: true, inclusiveHigh: true) == false {
            self.myAsset.lessorCost = self.lessorCostOnEntry
            alertTitle = alertMaxAmount
            showAlert.toggle()
        }
            
        self.editLessorStarted = false
    }
    
    func updateForResidualAmount() {
        if myAsset.residualValue.isEmpty {
            self.myAsset.residualValue = "0.00"
        }
        
        if isAmountValid(strAmount: myAsset.residualValue, decLow: 0.0, decHigh: maximumLessorCost.toDecimal(), inclusiveLow: true, inclusiveHigh: true) == false {
            self.myAsset.residualValue = self.residualValueOnEntry
            alertTitle = alertMaxResidual
            showAlert.toggle()
        } else {
            if self.myAsset.residualValue.toDecimal() > 0.00 && self.myAsset.residualValue.toDecimal() <= 1.0 {
                self.myAsset.residualValue = myInvestment.percentToAmount(percent: myAsset.residualValue)
            }
        }
            
        self.editResidualValueStarted = false
    }
    
    
    func updateForLesseeGuaranty() {
        if self.myAsset.lesseeGuarantyAmount.isEmpty {
            self.myAsset.lesseeGuarantyAmount = "0.00"
        }
        if isAmountValid(strAmount: myAsset.lesseeGuarantyAmount, decLow: 0.0, decHigh: maximumGuaranty, inclusiveLow: true, inclusiveHigh: true) == false {
            self.myAsset.lesseeGuarantyAmount = self.lesseeGuarantyOnEntry
            alertTitle = alertMaxGty
            showAlert.toggle()
        } else {
            if self.myAsset.lesseeGuarantyAmount.toDecimal() > 0.00 && self.myAsset.lesseeGuarantyAmount.toDecimal() <= 1.0 {
                self.myAsset.lesseeGuarantyAmount = myInvestment.percentToAmount(percent: myAsset.lesseeGuarantyAmount)
            }
        }
            
        self.editLesseeGuarantyStarted = false
    }
    
    
}

extension AssetView {
    func getFocusedTextField() -> AssetTextFieldType? {
        var focusedTextField: AssetTextFieldType? = nil
        
        if nameIsFocused {
           focusedTextField = .assetName
        } else if lessorCostIsFocused {
            focusedTextField = .lessorCost
        } else if residualValueIsFocused {
           focusedTextField = .residualValue
        } else if lesseeGuarantyIsFocused {
            focusedTextField = .lesseeGuaranty
        }
        
        return focusedTextField
    }
    
}
    



