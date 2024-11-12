//
//  AfterTaxEndingBalanceView.swift
//  CFLTax
//
//  Created by Steven Williams on 9/11/24.
//

import SwiftUI

struct InvestmentAmortizationView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var myAmortizations: Amortizations = Amortizations()
    
    var body: some View {
        VStack {
            CustomHeaderView(name: "A/T Ending Balances", isReport: true, path: $path, isDark: $isDark)
            Form {
                Section(header: Text("\(currentFile)")
                    .font(myFont)) {
                    ScrollView {
                        Grid (alignment: .trailing, horizontalSpacing: 23, verticalSpacing: 10) {
                            rateAndCostGridRow
                            amortHeaderGridRow
                            ForEach(myAmortizations.items) { item in
                                amortGridRow(item: item)
                            }
                            amortTotalsGridRow
                        }
                    }
                }
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.myInvestment.calculate()
            myAmortizations.createAmortizations(investCashflows: myInvestment.afterTaxCashflows, interestRate: myInvestment.getMISF_AT_Yield(), dayCountMethod: myInvestment.economics.dayCountMethod)
        }
    }
    
    var rateAndCostGridRow: some View {
        GridRow {
            Text("MISF AT:")
            Text("\(yieldFormatted())")
            Text("Cost:")
            Text("1.00")
        }
        .font(myFont)
    }
    
    var amortHeaderGridRow: some View {
        GridRow {
            Text("Date")
            Text("Cashflow")
            Text("Interest")
            Text("Balance")
        }
        .font(myFont)
        .bold()
    }
    
    @ViewBuilder func amortGridRow(item: Amortization) -> some View {
        GridRow {
            Text(item.dueDate.toStringDateShort(yrDigits: 2))
            Text("\(expressedAsFactor(amount: item.cashflow))")
            Text("\(expressedAsFactor(amount:item.interest))")
            Text("\(expressedAsFactor(amount:item.endBalance))")
        }
        .gridColumnAlignment(.trailing)
        .font(myFont)
    }
    
    var amortTotalsGridRow: some View {
        GridRow{
            Text("Totals")
            Text("\(expressedAsFactor(amount: myAmortizations.totalCashflow))")
            Text("\(expressedAsFactor(amount: myAmortizations.totalInterest))")
            
            Text("")
        }.font(myFont)
    }
    
    func expressedAsFactor(amount: Decimal) -> String {
        let denominator = myInvestment.asset.lessorCost.toDecimal()
        let factor = amount / denominator
        
        return factor.toString(decPlaces: 4)
        
    }

    func yieldFormatted() -> String {
        let yield = myInvestment.getMISF_AT_Yield().toString(decPlaces: 6)
        let strYield = percentFormatter(percent: yield, locale: myLocale, places: 3)
        
        return strYield
    }
    
}

#Preview {
    InvestmentAmortizationView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
