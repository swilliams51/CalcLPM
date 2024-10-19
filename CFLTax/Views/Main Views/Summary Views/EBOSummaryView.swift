//
//  EBOSummaryView.swift
//  CFLTax
//
//  Created by Steven Williams on 10/10/24.
//

import SwiftUI

struct EBOSummaryView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var myEBO: EarlyBuyout = EarlyBuyout()
    @State var viewAsPctOfCost: Bool = false
    //Yields
    @State var myTaxRate: Decimal = 0.21
    @State var myATYield: Decimal = 0.075
    @State var myBTYield: Decimal = 0.075
    @State var myIRRofPTCF: Decimal = 0.075
    
    //EBO Details
    @State var myEBOAmount: Decimal = 0.0
    @State var myArrearsRent: Decimal = 0.0
    @State var myTotalEBOAmountDue: Decimal = 0.0
    //Cashflow
    @State var myPreTaxCashflow: Decimal = 0.0
    @State var myAfterTaxCashflow: Decimal = 0.0
    @State var myTaxesPaid: Decimal = 0.0
    
    @State var lineHeight: CGFloat = 12
    @State var frameHeight: CGFloat = 12
    
    var body: some View {
       Form {
           Section(header: Text("EBO Yields")) {
               afterTaxYieldItem
               beforeTaxYieldItem
               preTaxIRRItem
           }
           
           Section(header: Text("EBO Details"), footer: Text("Exercise Date: \(dateFormatter(dateIn: myEBO.exerciseDate, locale: myLocale))")) {
               eboAmountItem
               arrearsRentItem
               eboTotalDueItem
           }
           
           Section(header: Text("EBO Cashflow")) {
               preTaxEBOCashItem
               afterTaxEBOCashItem
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
        
       .onAppear {
           self.myTaxRate = myInvestment.taxAssumptions.federalTaxRate.toDecimal()
           self.myEBO = myInvestment.earlyBuyout
           self.myATYield = myInvestment.solveForEBOYield(aEBO: myEBO)
           self.myBTYield = myATYield / (1.0 - myTaxRate)
           self.myIRRofPTCF = myInvestment.solveEBOIRR_Of_PTCF(aEBO: myEBO)
           self.myEBOAmount = myEBO.amount.toDecimal()
           self.myArrearsRent = myInvestment.getArrearsRent(dateAsk: myEBO.exerciseDate)
           self.myTotalEBOAmountDue = myEBO.amount.toDecimal() + myArrearsRent
       }
    }
}

#Preview {
    EBOSummaryView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}

//Yields
extension EBOSummaryView {
    var afterTaxYieldItem: some View {
        HStack{
            Text("After-Tax MISF:")
            Spacer()
            Text("\(percentFormatter(percent: myATYield.toString(decPlaces: 5), locale: myLocale, places:3))")
        }
        .font(myFont)
        .frame(height: frameHeight)
    }
    
    var beforeTaxYieldItem: some View {
        HStack{
            Text("Before-Tax MISF:")
            Spacer()
            Text("\(percentFormatter(percent:myBTYield.toString(decPlaces: 5), locale: myLocale, places: 3))")
        }
        .font(myFont)
        .frame(height: frameHeight)
    }
    
    
    var preTaxIRRItem: some View {
        HStack{
            Text("IRR PTCF:")
            Spacer()
            Text("\(percentFormatter(percent:myIRRofPTCF.toString(decPlaces: 5), locale: myLocale, places: 3))")
        }
        .font(myFont)
        .frame(height: frameHeight)
    }
}

//EBO Details
extension EBOSummaryView {
    var eboAmountItem: some View {
        HStack {
            Text("EBO Amount:")
            Spacer()
            Text("\(getFormattedValue(amount: myEBOAmount.toString(decPlaces: 2), viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
        }
        .font(myFont)
    }
    
    var arrearsRentItem: some View {
        HStack {
            Text("Arrears Rent:")
            Spacer()
            Text("\(getFormattedValue(amount:myArrearsRent.toString(decPlaces: 2), viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
                .underline()
        }
        .font(myFont)
    }
    
    var eboTotalDueItem: some View {
        HStack {
            Text("Total Amount Due:")
            Spacer()
            Text("\(getFormattedValue(amount:myTotalEBOAmountDue.toString(decPlaces: 2), viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
        }
        .font(myFont)
    }
}

extension EBOSummaryView {
    var preTaxEBOCashItem: some View {
        HStack {
            Text("Before-Tax Cashflows")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(17)
        }
    }
    
    var afterTaxEBOCashItem: some View {
        HStack {
            Text("After-Tax Cashflows")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(18)
        }
    }
    
}

