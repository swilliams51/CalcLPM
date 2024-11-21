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

    //@State var lineHeight: CGFloat = 12
    @State var frameHeight: CGFloat = 12
    
    var body: some View {
        VStack {
            ReportHeaderView(name: "Cashflow Summary", viewAsPct: myViewAsPct, path: $path, isDark: $isDark)
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
        }
        //.environment(\.defaultMinListRowHeight, lineHeight)
        .environment(\.colorScheme, isDark ? .dark : .light)
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
    
    private func myViewAsPct() {
        self.viewAsPctOfCost.toggle()
    }
    
}

#Preview {
    CashflowView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}

extension CashflowView {
    
    var assetCostItem: some View {
        HStack {
            Text("Asset Cost:")
            Spacer()
            Text("\(getFormattedValue(amount: assetCost, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))" )
        }
        .font(myFont)
        .frame(width: UIScreen.main.bounds.width * 0.8, height: frameHeight)
   }
   
   var feeAmountItem: some View {
       HStack{
           Text("Fee:")
           Spacer()
           Text("\(getFormattedValue(amount: feeAmount, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
               .underline()
       }
       .font(myFont)
       .frame(width: UIScreen.main.bounds.width * 0.8, height: frameHeight)
   }
   
   var totalCashOutItem: some View {
       HStack{
           Text("Total Investment:")
           Spacer()
           Text("\(getFormattedValue(amount: totalCashOut, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
       }
       .font(myFont)
       .frame(width: UIScreen.main.bounds.width * 0.8, height: frameHeight)
   }
   
   var rentAmountItem: some View {
       HStack{
           Text("Rent:")
           Spacer()
           Text("\(getFormattedValue(amount: rentAmount, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
       }
       .font(myFont)
       .frame(width: UIScreen.main.bounds.width * 0.8, height: frameHeight)
   }
   
   var residualAmountItem: some View {
       HStack{
           Text("Residual:")
           Spacer()
           Text(getFormattedValue(amount: residualAmount, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))
               .underline()
       }
       .font(myFont)
       .frame(width: UIScreen.main.bounds.width * 0.8, height: frameHeight)
   }
   
   var btProfitItem: some View {
       HStack {
           Text("Before-Tax Profit:")
               .padding(.leading, 0)
           Spacer()
           Text("\(getFormattedValue(amount: bTProfit, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
       }
       .font(myFont)
       .frame(width: UIScreen.main.bounds.width * 0.8, height: frameHeight)
   }
   
   var taxesPaidItem: some View {
       HStack{
           Text("Taxes:")
           Spacer()
           Text("\(getFormattedValue(amount: taxesPaid, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
               .underline()
       }
       .font(myFont)
       .frame(width: UIScreen.main.bounds.width * 0.8, height: frameHeight)
   }
   
   var itcItem: some View {
       HStack {
           Text("Investment Tax Credit:")
           Spacer()
           Text(getFormattedValue(amount: itc, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))
               .underline()
       }
       .font(myFont)
       .frame(width: UIScreen.main.bounds.width * 0.8, height: frameHeight)
   }
   
   var atProfitItem: some View {
       HStack{
           Text("After-Tax Cash:")
           Spacer()
           Text("\(getFormattedValue(amount: aTCash, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
       }
       .font(myFont)
       .frame(width: UIScreen.main.bounds.width * 0.8, height: frameHeight)
   }
   
   
}
