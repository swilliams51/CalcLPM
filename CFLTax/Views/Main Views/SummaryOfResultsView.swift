//
//  SummaryOfResultsView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/20/24.
//

import SwiftUI

struct SummaryOfResultsView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    
    @State var myATYield: Decimal = 0.075
    @State var myBTYield: Decimal = 0.075
    @State var myIRRPTCF: Decimal = 0.075
    
    @State var viewAsPercentOfCost: Bool = true
    @State var assetCost: String = "-100000.00"
    @State var feeAmount: String = "-2750.00"
    @State var totalInvestment: String = "-100000.00"
    @State var rentAmount: String = "92500.00"
    @State var residualAmount: String = "21500.00"
    @State var bTProfit: String = "-100000.00"
    @State var taxesPaid: String = "-7100.00"
    @State var itc: String = "0.00"
    @State var aTCash: String = "-100000.00"
    
    
    var body: some View {
        Form {
            Section(header: Text("Profitablity")) {
                afterTaxYieldItem
                beforeTaxYieldItem
                preTaxIRRItem
            }
            Section(header: Text("Cashflow")) {
                assetCostItem
                feeAmountItem
                totalAmountItem
                rentAmountItem
                residualAmountItem
                btProfitItem
                taxesPaidItem
                itcItem
                atProfitItem
            }
            
            Section(header: Text("Rentals")){
                
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationTitle("Summary")
        .navigationBarBackButtonHidden(true)
        .onAppear{
            myInvestment.calculate()
            myATYield = myInvestment.getMISF_AT_Yield()
            myBTYield = myInvestment.getMISF_BT_Yield()
            myIRRPTCF = myInvestment.getIRR_PTCF()
            
            let myTotal: Decimal = assetCost.toDecimal() + feeAmount.toDecimal()
            totalInvestment = myTotal.toString(decPlaces: 2)
            
            let myPTProfit: Decimal = (rentAmount.toDecimal() + residualAmount.toDecimal()) + totalInvestment.toDecimal()
            bTProfit = myPTProfit.toString(decPlaces: 2)
            
            let myATProfit: Decimal = myPTProfit + taxesPaid.toDecimal() + itc.toDecimal()
            aTCash = myATProfit.toString(decPlaces: 2)
        }
        
        
    }
}

#Preview {
    SummaryOfResultsView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false))
}

// Yields
extension SummaryOfResultsView {
    var afterTaxYieldItem: some View {
        HStack{
            Text("After-Tax MISF:")
                .font(myFont)
            Spacer()
            Text("\(percentFormatter(percent: myATYield.toString(decPlaces: 5), locale: myLocale, places:3))")
                .font(myFont)
        }
    }
    
    var beforeTaxYieldItem: some View {
        HStack{
            Text("Before-Tax MISF:")
                .font(myFont)
            Spacer()
            Text("\(percentFormatter(percent:myBTYield.toString(decPlaces: 5), locale: myLocale, places: 3))")
                .font(myFont)
        }
    }
    
    
    var preTaxIRRItem: some View {
        HStack{
            Text("IRR PTCF:")
                .font(myFont)
            Spacer()
            Text("\(percentFormatter(percent:myIRRPTCF.toString(decPlaces: 5), locale: myLocale, places: 3))")
                .font(myFont)
        }
    }
}

extension SummaryOfResultsView {
     var assetCostItem: some View {
         HStack {
             Text("Asset Cost:")
                 .font(myFont)
             Spacer()
             Text("\(getFormattedValue(amount: assetCost))" )
                 .font(myFont)
         }
    }
    
    var feeAmountItem: some View {
        HStack{
            Text("Fee:")
                .font(myFont)
            Spacer()
            Text("\(getFormattedValue(amount: feeAmount))")
                .font(myFont)
        }
    }
    
    var totalAmountItem: some View {
        HStack{
            Text("Total")
                .font(myFont)
                .textCase(.uppercase)
                .padding(.leading, 50)
            Spacer()
            Text("\(getFormattedValue(amount: totalInvestment))")
                .font(myFont)
        }
    }
    
    var rentAmountItem: some View {
        HStack{
            Text("Rent:")
                .font(myFont)
            Spacer()
            Text("\(getFormattedValue(amount: rentAmount))")
                .font(myFont)
        }
    }
    
    var residualAmountItem: some View {
        HStack{
            Text("Residual:")
                .font(myFont)
            Spacer()
            Text(getFormattedValue(amount: residualAmount))
                .font(myFont)
        }
    }
    
    var btProfitItem: some View {
        HStack {
            Text("B/T Profit")
                .font(myFont)
                .textCase(.uppercase)
                .padding(.leading, 50)
            Spacer()
            Text("\(getFormattedValue(amount: bTProfit))")
                .font(myFont)
        }
    }
    
    var taxesPaidItem: some View {
        HStack{
            Text("Taxes Paid:")
                .font(myFont)
            Spacer()
            Text("\(getFormattedValue(amount: taxesPaid))")
                .font(myFont)
        }
    }
    
    var itcItem: some View {
        HStack {
            Text("ITC:")
                .font(myFont)
            Spacer()
            Text(getFormattedValue(amount: itc))
                .font(myFont)
        }
    }
    
    var atProfitItem: some View {
        HStack{
            Text("A/T Cash")
                .font(myFont)
                .textCase(.uppercase)
                .padding(.leading, 50)
            Spacer()
            Text("\(getFormattedValue(amount: aTCash))")
                .font(myFont)
        }
    }
    
    func getFormattedValue (amount: String) -> String {
        if viewAsPercentOfCost {
            let decAmount = amount.toDecimal()
            let decCost = assetCost.toDecimal()
            let decPercent = decAmount / decCost
            let strPercent: String = decPercent.toString(decPlaces: 3)
            
            return percentFormatter(percent: strPercent, locale: myLocale, places: 2)
        } else {
             return amountFormatter(amount: amount, locale: myLocale)
        }
    }
}
