//
//  GroupDetailView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/12/24.
//

import SwiftUI

struct GroupDetailView: View {
    @Bindable var myInvestment: Investment
    @Binding var selectedGroup: Group
    @Binding var isDark: Bool
    @Binding var path: [Int]
    @Binding var currentFile: String

    @State var index: Int = 0
    @State var amount: String = "10000.00"
    @State private var alertTitle: String = ""

    @State private var count = 0
    @State private var maximumAmount: Decimal = 1.0
    @State private var noOfPayments: Double = 1.0
    @State private var paymentOnEntry: String = "0.0"
    @State var payHelp = paymentAmountHelp
    @State private var rangeOfPayments: ClosedRange<Double> = 1.0...120.0
    @State private var startingNoOfPayments: Double = 120.0
    @State private var startingTotalPayments: Double = 120.0
    
    @State private var editStarted: Bool = false
    @State private var isInterimGroup: Bool = false
    @State private var isResidualGroup: Bool = false
    @State private var isCalculatedPayment: Bool = false
    @State private var pmtTextFieldIsLocked: Bool = false
    @State private var showAlert: Bool = false
    @State var showPopover: Bool = false
    @State private var sliderIsLocked: Bool = false
    @State private var timingIsLocked: Bool = false
    private let pasteBoard = UIPasteboard.general
    
    var body: some View {
            Form {
                Section(header: Text(isInterimGroup ? "Interim Rent Details" : "Base Rent Details").font(myFont2), footer: (Text("FileName: \(currentFile)").font(myFont2))) {
                   groupDetailsSection
                }
                Section(header: Text("Submit Form").font(.footnote)){
                    SubmitFormButtonsView(cancelName: "Delete", doneName: "Done", cancel: deleteGroup, done: submitForm, isDark: $isDark)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackButtonView(path: $path, isDark: $isDark)
                }
            }
            .environment(\.colorScheme, isDark ? .dark : .light)
            .navigationTitle("Payment Group")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .onAppear{
                viewOnAppear()
              
            }
            .alert(isPresented: $showAlert, content: getAlert)
       
        }
}

#Preview {
    GroupDetailView(myInvestment: Investment(), selectedGroup: .constant(Group()), isDark: .constant(false), path: .constant([Int]()), currentFile: .constant("File is New"))
}

//View on Appear
//Group Details Section
//Delete and Done Buttons
extension GroupDetailView {
    func viewOnAppear() {
        self.index = self.myInvestment.rent.getIndexOfGroup(aGroup: selectedGroup)
        //print("\(index)")
        self.count = self.myInvestment.rent.groups.count - 1
        
        if self.selectedGroup.isInterim == true {
            isInterimGroup = true
        }
        
        if self.isInterimGroup == true {
            self.sliderIsLocked = true
        }
        
        if self.isInterimGroup == false {
            self.rangeOfPayments = rangeNumberOfPayments()
        }
        if self.selectedGroup.isCalculatedPaymentType() {
            self.resetForPaymentTypeChange()
        }
        self.maximumAmount = myInvestment.getAssetCost(asCashflow: true)
        self.noOfPayments = self.selectedGroup.noOfPayments.toDouble()
        self.startingNoOfPayments = self.noOfPayments
        self.startingTotalPayments = Double(self.myInvestment.rent.getTotalNumberOfPayments())
        self.paymentOnEntry = self.selectedGroup.amount
    }
}

extension GroupDetailView {
    var groupDetailsSection: some View {
        VStack {
            paymentTypeItem
            noOfPaymentsItem
            paymentTimingItem
            tempPaymentItem
            paymentLockedItem
        }
    }
    var paymentTypeItem: some View {
        Picker(selection: $selectedGroup.paymentType, label: Text("Type:").font(myFont2)) {
            ForEach(getPaymentTypes(), id: \.self) { paymentType in
                Text(paymentType.toString())
                    .font(myFont2)
            }
            .onChange(of: selectedGroup.paymentType) { oldValue, newValue in
                self.resetForPaymentTypeChange()
            }
            .font(.subheadline)
        }
    }
    
    var noOfPaymentsItem: some View {
        VStack {
            HStack {
                Text("No. of payments:")
                    .font(myFont2)
                Spacer()
                Text("\(selectedGroup.noOfPayments.toString())")
                    .font(myFont2)
            }
            Slider(value: $noOfPayments, in: rangeOfPayments, step: 1) {

            }
            .accentColor(ColorTheme().accent)
            .disabled(sliderIsLocked)
            .onChange(of: noOfPayments) { oldValue, newValue in
                self.selectedGroup.noOfPayments = newValue.toInteger()
            }
            HStack {
                Spacer()
                Stepper("", value: $noOfPayments, in: rangeOfPayments, step: 1, onEditingChanged: { _ in
                   
                }).labelsHidden()
                .transformEffect(.init(scaleX: 1.0, y: 0.9))
                .disabled(sliderIsLocked)
            }
        }
            
    }
    
    var paymentTimingItem: some View {
        Picker(selection: $selectedGroup.timing, label: Text("Timing:").font(myFont2)) {
            ForEach(TimingType.nonResidualPayments, id: \.self) { PaymentTiming in
                Text(PaymentTiming.toString())
                    .font(myFont2)
            }
            .onChange(of: selectedGroup.timing) { oldValue, newValue in
              
            }
        }.disabled(timingIsLocked)
    }
    
    var tempPaymentItem: some View {
        HStack{
            Text("Amount:")
                .font(myFont2)
                .onTapGesture {
                    if isCalculatedPayment == false {
                        path.append(14)
                    }
                }
            Spacer()
            Text("\(paymentFormatted(editStarted: editStarted))")
                .font(myFont2)
                .onTapGesture {
                    if isCalculatedPayment == false {
                        path.append(14)
                    }
                    
                }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if isCalculatedPayment == false {
                path.append(14)
            }
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
    
    var paymentLockedItem: some View {
        Toggle(isOn: $selectedGroup.locked) {
            Text(selectedGroup.locked ? "Locked:" : "Unlocked:")
                .font(myFont2)
        }
        .disabled(self.selectedGroup.isCalculatedPaymentType() ? true : false)
        .font(myFont2)
    }
}


//Cancel and Submit Buttons{today()
extension GroupDetailView {
    var textButtonsForCancelAndDoneRow: some View {
        HStack {
            Text("Delete")
                //.disabled(amountIsFocused)
                .font(.subheadline)
                .foregroundColor(ColorTheme().accent)
                .onTapGesture {
                    deleteGroup()
                }
            Spacer()
            Text("Done")
                //.disabled(amountIsFocused)
                .font(.subheadline)
                .foregroundColor(ColorTheme().accent)
                .onTapGesture {
                    submitForm()
                }
        }
    }
}

//Local Functions
extension GroupDetailView {
    func deleteGroup () {
        let result = isGroupDeletable()
        
        if result.condition == false {
            if result.message == 0 {
                self.alertTitle = alertInterimGroup
                self.showAlert.toggle()
            } else {
                self.alertTitle = alertFirstPaymentGroup
                self.showAlert.toggle()
            }
        } else {
            self.myInvestment.rent.groups.remove(at: index)
            self.myInvestment.resetFirstGroup(isInterim: self.myInvestment.rent.interimExists())
            self.path.removeLast()
            }
        }
    
    func submitForm() {
        
        if self.selectedGroup.paymentType != self.myInvestment.rent.groups[index].paymentType {
            self.myInvestment.hasChanged = true
            self.myInvestment.rent.groups[index].paymentType = selectedGroup.paymentType
        }
        
        if self.selectedGroup.noOfPayments != self.myInvestment.rent.groups[index].noOfPayments {
            self.myInvestment.hasChanged = true
            self.myInvestment.rent.groups[index].noOfPayments = self.selectedGroup.noOfPayments
        }
       
        if self.selectedGroup.timing != self.myInvestment.rent.groups[index].timing {
            self.myInvestment.hasChanged = true
            self.myInvestment.rent.groups[index].timing = selectedGroup.timing
        }
        
        self.myInvestment.rent.groups[index].amount = self.selectedGroup.amount
        
        if self.selectedGroup.locked != self.myInvestment.rent.groups[index].locked {
            self.myInvestment.hasChanged = true
            self.myInvestment.rent.groups[index].locked = self.selectedGroup.locked
        }
       
        self.myInvestment.resetFirstGroup(isInterim: self.myInvestment.rent.interimExists())
        
        self.path.removeLast()
    }
    
    func isGroupDeletable() -> (condition:Bool, message: Int) {
        if self.selectedGroup.isInterim == true {
            return (false, 0)
        }
        
        if myInvestment.rent.interimExists() {
            if self.index == 1 {
                return (false, 0)
            }
        }
        
        if myInvestment.rent.interimExists() == false {
            if self.index == 0 {
                return (false, 0)
            }
        }
         
        return (true, -1)
    }
    
    
    func getAlert() -> Alert{
        return Alert(title: Text(alertTitle))
    }
    
    
    func getPaymentTypes() -> [PaymentType] {
        if self.isInterimGroup {
            return PaymentType.interimTypes
        } else {
            return PaymentType.baseTermTypes
        }
    }
    
    func getTimingTypes() -> [TimingType] {
        return TimingType.nonResidualPayments
    }
    
    func getDefaultPaymentAmount() -> String {
        var defaultAmount: String =  (self.myInvestment.getAssetCost(asCashflow: true)  * 0.015).toString(decPlaces: 4)
        
        if self.myInvestment.rent.groups.count > 1 {
            for x in 0..<self.myInvestment.rent.groups.count {
                if self.myInvestment.rent.groups[x].amount != "CALCULATED" {
                    defaultAmount = self.myInvestment.rent.groups[x].amount.toDecimal().toString(decPlaces: 3)
                    break
                }
            }
        }
        return defaultAmount
    }
    
    func rangeNumberOfPayments () -> ClosedRange<Double> {
        let starting: Double = 1.0
        let maxNumber: Double = myInvestment.rent.getMaxRemainNumberPayments(maxBaseTerm: maxBaseTerm, freq: myInvestment.leaseTerm.paymentFrequency, eom: myInvestment.leaseTerm.endOfMonthRule, aRefer: myInvestment.leaseTerm.baseCommenceDate).toDouble()
        let currentNumber:Double = selectedGroup.noOfPayments.toDouble()
        let ending: Double = maxNumber + currentNumber
        
        return starting...ending
    }
    
    func resetForPaymentTypeChange() {
        if selectedGroup.isCalculatedPaymentType() == true {
            isCalculatedPayment = true
            pmtTextFieldIsLocked = true
            selectedGroup.locked = true
            selectedGroup.amount = "CALCULATED"
            self.sliderIsLocked = true
        } else {
            isCalculatedPayment = false
            pmtTextFieldIsLocked = false
            selectedGroup.amount = getDefaultPaymentAmount()
            selectedGroup.locked = false
            self.sliderIsLocked = false
        }
        
    }
    
}


let alertInterimGroup: String = "To delete an interim payment group go to the home screen and reset the base term commencement date to equal the funding date!!"
let alertFirstPaymentGroup: String = "The last payment group in which the number of payments is greater than 1 cannot be deleted!!"
let alertPaymentAmount: String = "The amount entered exceeds the maximum allowable amount which is constrained by the Lease/Loan amount. To enter such an amount first return to the Home screen and enter a temporary amount that is greater than the payment amount that was rejected.  Then return the Payment Group screen and the desired amount."
