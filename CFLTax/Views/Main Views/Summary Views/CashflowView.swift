//
//  CashflowView.swift
//  CFLTax
//
//  Created by Steven Williams on 10/10/24.
//

import SwiftUI

struct CashflowView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var viewAsPctOfCost: Bool = false
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

    @State var lineHeight: CGFloat = 12
    @State var frameHeight: CGFloat = 12
    
    var body: some View {
        Form {
            Section(header: Text("Cashflow")) {
                assetCostItem
                feeAmountItem
                totalCashOutItem
                rentAmountItem
                residualAmountItem
                btProfitItem
                taxesPaidItem
                atProfitItem
            }
        }
        .environment(\.defaultMinListRowHeight, lineHeight)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
            ToolbarItem(placement: .topBarTrailing){
                Button(action: {
                    viewAsPctOfCost.toggle()
                }) {
                    Image(systemName: "command.circle")
                        .tint(viewAsPctOfCost ? Color.red : Color.black)
                }
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationTitle("Summary")
        .navigationBarBackButtonHidden(true)
        .onAppear{
            myInvestment.calculate()
            myInvestment.hasChanged = false
            
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
            
        }
    }
}

#Preview {
    CashflowView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}

extension CashflowView {
    var assetCostItem: some View {
        HStack {
            Text("Asset Cost:")
                .font(myFont)
            Spacer()
            Text("\(getFormattedValue(amount: assetCost, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))" )
                .font(myFont)
        }.frame(height: frameHeight)
   }
   
   var feeAmountItem: some View {
       HStack{
           Text("Fee:")
               .font(myFont)
           Spacer()
           Text("\(getFormattedValue(amount: feeAmount, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
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
           Text("\(getFormattedValue(amount: totalCashOut, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")   
               .font(myFont)
       }.frame(height: frameHeight)
   }
   
   var rentAmountItem: some View {
       HStack{
           Text("Rent:")
               .font(myFont)
           Spacer()
           Text("\(getFormattedValue(amount: rentAmount, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
               .font(myFont)
       }.frame(height: frameHeight)
   }
   
   var residualAmountItem: some View {
       HStack{
           Text("Residual:")
               .font(myFont)
           Spacer()
           Text(getFormattedValue(amount: residualAmount, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))
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
           Text("\(getFormattedValue(amount: bTProfit, viewAsPercentOfCost: true, aInvestment: myInvestment))")
               .font(myFont)
       }.frame(height: frameHeight)
   }
   
   var taxesPaidItem: some View {
       HStack{
           Text("Taxes:")
               .font(myFont)
           Spacer()
           Text("\(getFormattedValue(amount: taxesPaid, viewAsPercentOfCost: true, aInvestment: myInvestment))")
               .font(myFont)
       }.frame(height: frameHeight)
   }
   
   var itcItem: some View {
       HStack {
           Text("Investment Tax Credit:")
               .font(myFont)

           Spacer()
           Text(getFormattedValue(amount: itc, viewAsPercentOfCost: true, aInvestment: myInvestment))
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
           Text("\(getFormattedValue(amount: aTCash, viewAsPercentOfCost: true, aInvestment: myInvestment))")
               .font(myFont)
       }.frame(height: frameHeight)
   }
   
   
}
