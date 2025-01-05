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
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var isLandscape: Bool { verticalSizeClass == .compact }
    
    var body: some View {
        VStack (spacing: 0) {
            HeaderView(headerType: .menu, name: "Amortization", viewAsPct: myViewAsPct, goBack: myGoBack, withBackButton: true, withPctButton: false, path: $path, isDark: $isDark)
            if isLandscape {
                Form {
                    Section(header: Text("Current File: \(currentFile)     MISF A/T Yield: \(yieldFormatted())").font(myFont)) {
                        ScrollView {
                            Grid (alignment: .leading, horizontalSpacing: 70, verticalSpacing: 10){
                                amortHeaderGridRowLandscape
                                ForEach(myAmortizations.items) { item in
                                    amortGridRowLandscape(item: item)
                                }
                                amortTotalsGridRowLandscape
                            }
                        }
                    }
                }
            } else {
                Form {
                    Section(header: Text("\(currentFile)").font(myFont3)) {
                        ScrollView {
                            Grid (alignment: .trailing, horizontalSpacing: 30, verticalSpacing: 10){
                                rateAndCostGridRow
                                amortHeaderGridRowPortrait
                                ForEach(myAmortizations.items) { item in
                                    amortGridRowPortrait(item: item)
                                }
                                amortTotalsGridRowPortrait
                            }
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
    
    private func myViewAsPct() {
        
    }
    private func myGoBack() {
        self.path.removeLast()
    }
    
    var rateAndCostGridRow: some View {
        GridRow {
            Text("MISF AT:")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("\(yieldFormatted())")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Cost:")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("1.00")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .font(myFont3)
    }
    
    var amortHeaderGridRowLandscape: some View {
        GridRow {
            Text("Date")
            Text("Cashflow")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Interest")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Principal")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Balance")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .font(myFont)
        .bold()
    }
    
    var amortHeaderGridRowPortrait: some View {
        GridRow {
            Text("Date")
            Text("Cashflow")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Interest")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Balance")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .font(myFont3)
        .bold()
    }
    
    @ViewBuilder func amortGridRowLandscape(item: Amortization) -> some View {
        GridRow {
            Text(item.dueDate.toStringDateShort())
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("\(amountFormatter(amount: item.cashflow.toString(decPlaces: 3), locale: myLocale))")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("\(amountFormatter(amount: item.interest.toString(decPlaces: 3), locale:myLocale))")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("\(amountFormatter(amount: item.principal.toString(decPlaces: 3), locale:myLocale))")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("\(amountFormatter(amount: item.endBalance.toString(decPlaces: 3), locale:myLocale))")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .gridColumnAlignment(.trailing)
        .font(myFont)
    }
    
    
    @ViewBuilder func amortGridRowPortrait(item: Amortization) -> some View {
        GridRow {
            Text(item.dueDate.toStringDateShort(yrDigits: 2))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("\(expressedAsFactor(amount: item.cashflow))")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("\(expressedAsFactor(amount:item.interest))")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("\(expressedAsFactor(amount:item.endBalance))")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .gridColumnAlignment(.trailing)
        .font(myFont2)
    }
    
    var amortTotalsGridRowPortrait: some View {
        GridRow{
            Text("Totals")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("\(expressedAsFactor(amount: myAmortizations.totalCashflow))")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("\(expressedAsFactor(amount: myAmortizations.totalInterest))")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("")
        }.font(myFont3)
    }
    
    var amortTotalsGridRowLandscape: some View {
        GridRow{
            Text("Totals")
            Text("\(amountFormatter(amount: myAmortizations.totalCashflow.toString(decPlaces: 2), locale: myLocale))")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("\(amountFormatter(amount: myAmortizations.totalInterest.toString(decPlaces: 2), locale: myLocale))")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("\(amountFormatter(amount: myAmortizations.totalPrincipal.toString(decPlaces: 2), locale: myLocale))")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
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
