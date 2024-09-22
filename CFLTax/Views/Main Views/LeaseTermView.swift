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
    @State var showPopover: Bool = false
    @State var baseHelp: Help = baseTermHelp
    
    var body: some View {
        Form {
            Section (header: Text("Details").font(myFont2), footer: (Text("FileName: \(currentFile)").font(myFont2))) {
                paymentFrequencyItem
                eomRuleItem
                baseCommenceDateItem
                baseTermInMonthsItem
            }
            Section(header: Text("Submit Form")) {
                SubmitFormButtonsView(cancelName: "Cancel", doneName: "Done", cancel: myCancel, done: myDone, isDark: $isDark)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarTitle("Lease Term")
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
                .font(myFont2)
            Image(systemName: "questionmark.circle")
                .foregroundColor(Color.theme.accent)
                .onTapGesture {
                    self.showPopover.toggle()
                }
            Spacer()
            DatePicker("", selection: $baseCommenceDate, in: rangeBaseTermCommenceDates, displayedComponents:[.date])
                .transformEffect(.init(scaleX: 1.0, y: 0.90))
                .environment(\.locale, myLocale)
                .font(myFont2)
                .onChange(of: baseCommenceDate) { oldValue, newValue in
                  
                }
        }
        .disabled(false)
        
        .popover(isPresented: $showPopover) {
            PopoverView(myHelp: $baseHelp, isDark: $isDark)
        }
    }
    
    var paymentFrequencyItem: some View {
        HStack {
            Text("Frequency:")
                .font(myFont2)
            Picker(selection: $myPaymentFrequency, label: Text("")) {
                ForEach(Frequency.allCases, id: \.self) { item in
                   Text(item.toString())
                        .font(myFont2)

               }
            }
        }
    }
    
    var eomRuleItem: some View {
        HStack{
            Toggle(isOn: $endOfMonthRule) {
                Text(endOfMonthRule ? "EOM Rule is On:" : "EOM Rule is Off:")
                .font(myFont2)
            }
        }
    }
    
    var baseTermInMonthsItem: some View {
        HStack{
            Text("Base Term in Months:")
                .font(myFont2)
            Spacer()
            Text("\(myInvestment.getBaseTermInMonths())")
                .font(myFont2)
        }
    }
    
    func myCancel() {
        path.removeLast()
    }
    
    func myDone() {
        
        
        if self.baseCommenceDate != self.myInvestment.leaseTerm.baseCommenceDate {
            self.myInvestment.leaseTerm.baseCommenceDate = self.baseCommenceDate
            self.myInvestment.resetForBaseTermCommenceDateChange()
        }
        if self.myPaymentFrequency != self.myInvestment.leaseTerm.paymentFrequency {
            self.myInvestment.leaseTerm.paymentFrequency = self.myPaymentFrequency
            self.myInvestment.resetForFrequencyChange(oldFrequently: paymentFrequencyOnEntry)
        }
        
        self.myInvestment.leaseTerm.endOfMonthRule = self.endOfMonthRule
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


