//
//  NetAfterTaxCashflowsView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/19/24.
//

import SwiftUI

struct NetAfterTaxCashflowsView: View {
    @Bindable var myInvestment: Investment
    @Bindable var myATCashflows: Cashflows
    @Binding var path: [Int]
    @Binding var isDark: Bool
    
    @State var myAfterTaxYield: Decimal = 0.0
    @State var myBeforeTaxYield: Decimal = 0.0
    
    var body: some View {
        Form {
            Section(header: Text("Schedule")) {
                if myATCashflows.items.count == 0 {
                    VStack {
                        Text("No Cashflows")
                    }
                } else {
                    ForEach(myATCashflows.items) { item in
                        HStack {
                            Text("\(item.dueDate.toStringDateShort(yrDigits: 2))")
                            Spacer()
                            Text("\(amountFormatter(amount: item.amount, locale: myLocale))")
                        }
                        
                    }
                }
            }
            Section(header: Text("Totals")) {
                if myATCashflows.items.count == 0 {
                    VStack {
                        Text("No Totals")
                    }
                } else {
                    HStack {
                        Text("\(myATCashflows.items.count)")
                        Spacer()
                        Text("\(amountFormatter(amount: myATCashflows.getTotal().toString(decPlaces: 4), locale: myLocale))")
                    }
                }
               
            }
            Section(header: Text("Yield")) {
                if myATCashflows.items.count == 0 {
                    VStack {
                        Text("No Yield")
                    }
                } else {
                    VStack {
                        HStack{
                            Text("A/T Yield:")
                            Spacer()
                            Text("\(percentFormatter(percent:myAfterTaxYield.toString(decPlaces: 4), locale: myLocale,places: 2))")
                        }
                        .padding(.bottom, 5)
                        HStack{
                            Text("B/T Yield:")
                            Spacer()
                            Text("\(percentFormatter(percent:myBeforeTaxYield.toString(decPlaces: 4), locale: myLocale,places: 2))")
                        }
                    }
                }
                
            }
            
        }
        .navigationTitle("Net A/T Cashflows")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if myATCashflows.items.count > 0 {
                myAfterTaxYield = myATCashflows.XIRR2(guessRate: 0.05, _DayCountMethod: .actualThreeSixtyFive)
                myBeforeTaxYield = myAfterTaxYield / (1.0 - myInvestment.taxAssumptions.federalTaxRate.toDecimal())
            }
            
        }
    }
}

#Preview {
    NetAfterTaxCashflowsView(myInvestment: Investment(), myATCashflows: Cashflows(), path: .constant([Int]()), isDark: .constant(false))
}
