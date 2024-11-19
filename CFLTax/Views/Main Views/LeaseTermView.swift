//
//  LeaseTermView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/9/24.
//

import SwiftUI

struct LeaseTermView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var baseCommenceDate: Date = Date()
    @State var myPaymentFrequency: Frequency = .monthly
    @State var paymentFrequencyOnEntry: Frequency = .monthly
    @State var endOfMonthRule: Bool = false
    @State var baseTermInMonths: Int = 12
   
    
    //Alerts and Popovers
    @State private var showPop1: Bool = false
    @State private var showPop2: Bool = false
    @State private var showPop3: Bool = false
    @State private var baseHelp: Help = baseTermHelp
    @State private var eomRuleHelp = leaseTermEOMRuleHelp
    
    
    var body: some View {
        VStack {
            MenuHeaderView(name: "Lease Term", path: $path, isDark: $isDark)
            Form {
                Section (header: Text("Details").font(myFont), footer: (Text("File Name: \(currentFile)").font(myFont))) {
                    baseCommenceDateItem
                    paymentFrequencyItem
                    eomRuleItem
                    baseTermInMonthsItem
                }
                Section(header: Text("Submit Form")) {
                    SubmitFormButtonsView(cancelName: "Cancel", doneName: "Done", cancel: myCancel, done: myDone, isFocused: false, isDark: $isDark)
                }
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.baseCommenceDate = myInvestment.leaseTerm.baseCommenceDate
            self.paymentFrequencyOnEntry = myInvestment.leaseTerm.paymentFrequency
            self.myPaymentFrequency = myInvestment.leaseTerm.paymentFrequency
            self.endOfMonthRule = myInvestment.leaseTerm.endOfMonthRule
        }
    }
    
    var baseCommenceDateItem: some View {
        HStack{
            Text("Base Start:")
                .font(myFont)
            Image(systemName: "questionmark.circle")
                .foregroundColor(Color.theme.accent)
                .onTapGesture {
                    self.showPop1.toggle()
                }
            Spacer()
            DatePicker("", selection: $baseCommenceDate, in: rangeBaseTermCommenceDates, displayedComponents:[.date])
                .transformEffect(.init(scaleX: 1.0, y: 0.90))
                .environment(\.locale, myLocale)
                .font(myFont)
                .onChange(of: baseCommenceDate) { oldValue, newValue in
                  
                }
        }
        .disabled(false)
        .popover(isPresented: $showPop1) {
            PopoverView(myHelp: $baseHelp, isDark: $isDark)
        }
    }
    
    var paymentFrequencyItem: some View {
        HStack {
            Text("Frequency:")
                .font(myFont)
            Picker(selection: $myPaymentFrequency, label: Text("")) {
                ForEach(Frequency.allCases, id: \.self) { item in
                   Text(item.toString())
                        .font(myFont)

               }
            }
        }
    }
    
    var eomRuleItem: some View {
        HStack{
            Toggle(isOn: $endOfMonthRule) {
                HStack {
                    Text("EOM Rule:")
                        .font(myFont)
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(Color.theme.accent)
                        .onTapGesture {
                            self.showPop2.toggle()
                        }
                }
            }
        }
        .popover(isPresented: $showPop2) {
            PopoverView(myHelp: $eomRuleHelp, isDark: $isDark)
        }
    }
    
    var baseTermInMonthsItem: some View {
        HStack{
            Text("Base Term:")
                .font(myFont)
            Image(systemName: "questionmark.circle")
                .foregroundColor(Color.theme.accent)
                .onTapGesture {
                    self.showPop3.toggle()
                }
            Spacer()
            Text("\(myInvestment.getBaseTermInMonths())")
                .font(myFont)
            
        }
        .popover(isPresented: $showPop3) {
            PopoverView(myHelp: $baseHelp, isDark: $isDark)
        }
    }
    
    func myCancel() {
        path.removeLast()
    }
    
    func myDone() {
        if self.baseCommenceDate != self.myInvestment.leaseTerm.baseCommenceDate {
            self.myInvestment.hasChanged = true
            self.myInvestment.leaseTerm.baseCommenceDate = self.baseCommenceDate
            self.myInvestment.resetForBaseTermCommenceDateChange()
        }
        if self.myPaymentFrequency != self.myInvestment.leaseTerm.paymentFrequency {
            self.myInvestment.hasChanged = true
            self.myInvestment.leaseTerm.paymentFrequency = self.myPaymentFrequency
            self.myInvestment.resetForFrequencyChange(oldFrequently: paymentFrequencyOnEntry)
        }
        if self.endOfMonthRule != self.myInvestment.leaseTerm.endOfMonthRule {
            self.myInvestment.hasChanged = true
            self.myInvestment.leaseTerm.endOfMonthRule = self.endOfMonthRule
        }
        path.removeLast()
    }
    
    var rangeBaseTermCommenceDates: ClosedRange<Date> {
        let start: Date = myInvestment.asset.fundingDate
        var maxInterim: Int

        switch myInvestment.leaseTerm.paymentFrequency {
        case .quarterly:
            maxInterim = 3
        case .semiannual:
            maxInterim = 6
        case .annual:
            maxInterim = 12
        default:
            maxInterim = 3
        }

        let end: Date = addPeriodsToDate(dateStart: start, payPerYear: .monthly, noOfPeriods: maxInterim, referDate: start, bolEOMRule: myInvestment.leaseTerm.endOfMonthRule)

        return start...end
    }
    
}

#Preview {
    LeaseTermView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}


