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
    @Binding var currentFile: String
    
    //Yields
    @State var myATYield: Decimal = 0.075
    @State var myBTYield: Decimal = 0.075
    @State var myIRRPTCF: Decimal = 0.075
    //Cashflow
    @State var viewAsPercentOfCost: Bool = false
    @State var assetCost: String = "-100000.00"
    @State var feeAmount: String = "-2750.00"
    @State var totalCashOut: String = "-100000.00"
    @State var totalCashIn: String = "120000.00"
    @State var rentAmount: String = "92500.00"
    @State var residualAmount: String = "21500.00"
    @State var bTProfit: String = "-100000.00"
    @State var taxesPaid: String = "-7100.00"
    @State var itc: String = "0.00"
    @State var aTCash: String = "-100000.00"
    //Rentals
    @State var implicitRate: String = "0.00"
    @State var presentValue1: String = "0.00"
    @State var presentValue2: String = "0.00"
    @State var discountRate: String = "0.00"
    
    
    @State var lineHeight: CGFloat = 10
    @State var frameHeight: CGFloat = 10
    
    var body: some View {
        Form {
            Section(header: Text("Yields"), footer: (Text("FileName: \(currentFile)"))) {
                afterTaxYieldItem
                beforeTaxYieldItem
                preTaxIRRItem
            }
            Section(header: Text("Cashflow")) {
                assetCostItem
                feeAmountItem
                totalCashOutItem
                rentAmountItem
                residualAmountItem
                btProfitItem
                taxesPaidItem
                itcItem
                atProfitItem
            }
            
            Section(header: Text("Rentals")){
                implicitRateItem
                presentValueItem
                presentValue2Item
            }
        }
        .environment(\.defaultMinListRowHeight, lineHeight)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
            ToolbarItem(placement: .topBarTrailing){
                Button(action: {
                    viewAsPercentOfCost.toggle()
                }) {
                    Image(systemName: "command.circle")
                        .tint(viewAsPercentOfCost ? Color.red : Color.black)
                }
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationTitle("Summary")
        .navigationBarBackButtonHidden(true)
        .onAppear{
            myInvestment.calculate()
            myInvestment.hasChanged = false
            myATYield = myInvestment.getMISF_AT_Yield()
            myBTYield = myInvestment.getMISF_BT_Yield()
            myIRRPTCF = myInvestment.getIRR_PTCF()
            
            self.assetCost = myInvestment.getAssetCost(asCashflow: true).toString(decPlaces: 2)
            self.feeAmount = myInvestment.getFeeAmount().toString(decPlaces: 2)
            
            self.rentAmount = myInvestment.getTotalRent().toDecimal().toString(decPlaces: 2)
            self.residualAmount = myInvestment.getAssetResidualValue().toString(decPlaces: 2)
            self.bTProfit = myInvestment.getBeforeTaxCash().toDecimal().toString(decPlaces: 2)
            self.taxesPaid = myInvestment.getTaxesPaid().toDecimal().toString(decPlaces: 2)
            self.aTCash = myInvestment.getAfterTaxCash().toDecimal().toString(decPlaces: 2)
            
            let myTotalOut: Decimal = assetCost.toDecimal() + feeAmount.toDecimal()
            totalCashOut = myTotalOut.toString(decPlaces: 2)
            let myTotalIn: Decimal = rentAmount.toDecimal() + residualAmount.toDecimal()
            totalCashIn = myTotalIn.toString(decPlaces: 2)
            
            self.implicitRate = myInvestment.getImplicitRate().toString(decPlaces: 5)
            self.discountRate = myInvestment.economics.discountRateForRent.toDecimal().toString(decPlaces: 5)
            self.presentValue1 = myInvestment.getPVOfRents().toString(decPlaces: 5)
            self.presentValue2 = myInvestment.getPVOfObligations().toString(decPlaces: 5)
        }
        
        
    }
    
}

#Preview {
    SummaryOfResultsView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
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
        }.frame(height: frameHeight)
    }
    
    var beforeTaxYieldItem: some View {
        HStack{
            Text("Before-Tax MISF:")
                .font(myFont)
            Spacer()
            Text("\(percentFormatter(percent:myBTYield.toString(decPlaces: 5), locale: myLocale, places: 3))")
                .font(myFont)
        }.frame(height: frameHeight)
    }
    
    
    var preTaxIRRItem: some View {
        HStack{
            Text("IRR PTCF:")
                .font(myFont)
            Spacer()
            Text("\(percentFormatter(percent:myIRRPTCF.toString(decPlaces: 5), locale: myLocale, places: 3))")
                .font(myFont)
        }.frame(height: frameHeight)
    }
}
// Cashflow
extension SummaryOfResultsView {
     var assetCostItem: some View {
         HStack {
             Text("Asset Cost:")
                 .font(myFont)
             Spacer()
             Text("\(getFormattedValue(amount: assetCost))" )
                 .font(myFont)
         }.frame(height: frameHeight)
    }
    
    var feeAmountItem: some View {
        HStack{
            Text("Fee:")
                .font(myFont)
            Spacer()
            Text("\(getFormattedValue(amount: feeAmount))")
                .font(myFont)
                .underline()
        }.frame(height: frameHeight)
    }
    
    var totalCashOutItem: some View {
        HStack{
            Text("Total Investment:")
                .font(myFont)
                .padding(.leading, 0)
            Spacer()
            Text("\(getFormattedValue(amount: totalCashOut))")
                .font(myFont)
        }.frame(height: frameHeight)
    }
    
    var rentAmountItem: some View {
        HStack{
            Text("Rent:")
                .font(myFont)
            Spacer()
            Text("\(getFormattedValue(amount: rentAmount))")
                .font(myFont)
        }.frame(height: frameHeight)
    }
    
    var residualAmountItem: some View {
        HStack{
            Text("Residual:")
                .font(myFont)
            Spacer()
            Text(getFormattedValue(amount: residualAmount))
                .font(myFont)
                .underline()
        }.frame(height: frameHeight)
    }
    
    var btProfitItem: some View {
        HStack {
            Text("Before-Tax Profit:")
                .font(myFont)
                .padding(.leading, 0)
            Spacer()
            Text("\(getFormattedValue(amount: bTProfit))")
                .font(myFont)
        }.frame(height: frameHeight)
    }
    
    var taxesPaidItem: some View {
        HStack{
            Text("Taxes Paid:")
                .font(myFont)
            Spacer()
            Text("\(getFormattedValue(amount: taxesPaid))")
                .font(myFont)
        }.frame(height: frameHeight)
    }
    
    var itcItem: some View {
        HStack {
            Text("Investment Tax Credit:")
                .font(myFont)

            Spacer()
            Text(getFormattedValue(amount: itc))
                .font(myFont)
                .underline()
        }.frame(height: frameHeight)
    }
    
    var atProfitItem: some View {
        HStack{
            Text("After-Tax Cash:")
                .font(myFont)
                .padding(.leading, 0)
            Spacer()
            Text("\(getFormattedValue(amount: aTCash))")
                .font(myFont)
        }.frame(height: frameHeight)
    }
    
    func getFormattedValue (amount: String) -> String {
        if viewAsPercentOfCost {
            let decAmount = amount.toDecimal()
            let decCost = myInvestment.getAssetCost(asCashflow: false)
            let decPercent = decAmount / decCost
            let strPercent: String = decPercent.toString(decPlaces: 5)
            
            return percentFormatter(percent: strPercent, locale: myLocale, places: 3)
        } else {
             return amountFormatter(amount: amount, locale: myLocale)
        }
    }
}

//Rentals
extension SummaryOfResultsView {
    var implicitRateItem: some View {
        HStack{
            Text("Implicit Rate:")
                .font(myFont)
            Spacer()
            Text("\(percentFormatter(percent: implicitRate, locale: myLocale, places: 3))")
                .font(myFont)
        }.frame(height: frameHeight)
    }
    
    var presentValueItem: some View {
            HStack{
                Text("PV1 @ \(getDiscountRateText()):")
                    .font(myFont)
                Spacer()
                Text("\(getFormattedValue(amount: presentValue1))")
                    .font(myFont)
            }.frame(height: frameHeight)
    }
    
    var presentValue2Item: some View {
        HStack{
            Text("PV2 @ \(getDiscountRateText()):")
                .font(myFont)
            Spacer()
            Text("\(getFormattedValue(amount: presentValue2))")
                .font(myFont)
        }.frame(height: frameHeight)
    }
    
    func getDiscountRateText() -> String {
        let strDiscountRate: String = percentFormatter(percent: discountRate, locale: myLocale, places: 3)
        return strDiscountRate
    }
    
}
