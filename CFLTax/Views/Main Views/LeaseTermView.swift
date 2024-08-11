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
    
    @State var baseCommenceDate: Date = Date()
    @State var myPaymentFrequency: Frequency = .monthly
    @State var endOfMonthRule: Bool = false
    @State var baseTermInMonths: Int = 12
    @State var showPopover: Bool = false
    @State var baseHelp: Help = baseTermHelp
    
    var body: some View {
        Form {
            Section (header: Text("Details")) {
                baseCommenceDateItem
                paymentFrequencyItem
                eomRuleItem
                baseTermInMonthsItem
            }
            Section(header: Text("Submit Form")) {
                SubmitFormButtonsView(cancelName: "Cancel", doneName: "Done", cancel: myCancel, done: myDone, isDark: $isDark)
            }
        }
        .navigationBarTitle("Lease Term")
        .onAppear {
            self.baseCommenceDate = myInvestment.leaseTerm.baseCommenceDate
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
                    self.showPopover.toggle()
                }
            Spacer()
            DatePicker("", selection: $baseCommenceDate, in: rangeBaseTermDates, displayedComponents:[.date])
                .transformEffect(.init(scaleX: 1.0, y: 0.90))
                .environment(\.locale, myLocale)
                .onChange(of: baseCommenceDate) { oldValue, newValue in
                    //reset for base commence date change
                    //self.myLease.resetLease()
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
                .font(myFont)
            Picker(selection: $myPaymentFrequency, label: Text("")) {
                ForEach(Frequency.three, id: \.self) { item in
                   Text(item.toString())

               }
            }
        }
    }
    
    var eomRuleItem: some View {
        HStack{
            Toggle(isOn: $endOfMonthRule) {
                Text(endOfMonthRule ? "EOM Rule is On:" : "EOM Rule is Off:")
                .font(myFont)
            }
        }
    }
    
    var baseTermInMonthsItem: some View {
        HStack{
            Text("Base Term in Months:")
                .font(myFont)
            Spacer()
            Text("\(myInvestment.getBaseTermInMonths())")
        }
    }
    
    func myCancel() {
        path.removeLast()
    }
    
    func myDone() {
        self.myInvestment.leaseTerm.baseCommenceDate = self.baseCommenceDate
        self.myInvestment.leaseTerm.paymentFrequency = self.myPaymentFrequency
        self.myInvestment.leaseTerm.endOfMonthRule = self.endOfMonthRule
        self.myInvestment.resetForBaseTermCommenceDateChange()
        self.myInvestment.resetForFrequencyChange()
        path.removeLast()
    }
    
    var rangeBaseTermDates: ClosedRange<Date> {
        let starting: Date = myInvestment.asset.fundingDate
    var maxInterim: Int
    var dayAdder: Int = -1

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

    if maxInterim == 3 {
        dayAdder = 0
    }

    var ending: Date = Calendar.current.date(byAdding: .month, value: maxInterim, to: starting)!
    ending = Calendar.current.date(byAdding: .day, value: dayAdder, to: ending)!

    return starting...ending
}
    
}

#Preview {
    LeaseTermView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false))
}


