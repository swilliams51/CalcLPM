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
    
    @State var baseCommencementDate: Date = Date()
    @State var myPaymentFrequency: Frequency = .monthly
    @State var endOfMonthRule: Bool = false
    @State var baseTermInMonths: Int = 12
    
    var body: some View {
        Form {
            Section (header: Text("Details")) {
                HStack{
                    Text("Base Commence Date:")
                    Spacer()
                    Text("\(myInvestment.leaseTerm.baseCommenceDate.toStringDateShort(yrDigits: 2))")
                }
               
                HStack{
                    Text("Pay Frequency:")
                    Spacer()
                    Text("\(myInvestment.leaseTerm.paymentFrequency.toString())")
                }
                
                HStack{
                    Toggle(isOn: $myInvestment.leaseTerm.endOfMonthRule) {
                        Text(myInvestment.leaseTerm.endOfMonthRule ? "EOM Rule is on:" : "EOM Rule is off:")
                            //.font(.subheadline)
                    }
                    //.font(.subheadline)
                }
                HStack{
                    Text("Base Term in Months:")
                    Spacer()
                    Text("\(myInvestment.leaseTerm.baseTermInMonths)")
                }
            }
            Section(header: Text("Submit Form")) {
                SubmitFormButtonsView(cancelName: "Cancel", doneName: "Done", cancel: myCancel, done: myDone, isDark: $isDark)
            }
           
        }
        .navigationBarTitle("Lease Term")
        .onAppear {
            
        }
    }
    
    func myCancel() {
        
    }
    
    func myDone() {
        
    }
}

#Preview {
    LeaseTermView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false))
}
