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
    
    @State var myEBOInvestment: Investment = Investment()
    @State var myPeriodicArrearsRents: PeriodicArrearsRents = PeriodicArrearsRents()
    @State var myPlannedIncome: Decimal = 0.0
    @State var myDateOfUnplannedIncome: Date = Date()
    @State var viewAsPctOfCost: Bool = false
    //Yields
    @State var myATYield: Decimal = 0.075
    @State var myBTYield: Decimal = 0.075
    @State var myIRRPTCF: Decimal = 0.075
    
    //EBO Details
    @State var myEBOAmount: Decimal = 0.0
    @State var myArrearsRent: Decimal = 0.0
    @State var myTotalEBODue: Decimal = 0.0
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
           
           Section(header: Text("EBO Details"), footer: Text("Exercise Date: \(dateFormatter(dateIn: myDateOfUnplannedIncome, locale: myLocale))")) {
               eboAmountItem
               arrearsRentItem
               eboTotalDueItem
           }
           
           Section(header: Text("EBO Cashflow")) {
               preTaxEBOCashItem
               taxesPaidItem
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
           self.myDateOfUnplannedIncome = myInvestment.earlyBuyout.exerciseDate
           self.myPlannedIncome = myInvestment.plannedIncome(aInvestment: myInvestment, dateAsk: myDateOfUnplannedIncome)
           self.myPeriodicArrearsRents.createTable(aInvestment: myInvestment)
           self.myArrearsRent = myPeriodicArrearsRents.vLookup(dateAsk: myDateOfUnplannedIncome)
           self.myEBOInvestment.createEBOInvestment(from: myInvestment, unplannedDate: myDateOfUnplannedIncome)
           self.myEBOInvestment.calculate(plannedIncome: myPlannedIncome.toString(decPlaces: 5), unplannedDate: myDateOfUnplannedIncome)
           self.myATYield = myEBOInvestment.getMISF_AT_Yield()
           self.myBTYield = myEBOInvestment.getMISF_BT_Yield()
           self.myIRRPTCF = myEBOInvestment.getIRR_PTCF()
           self.myEBOAmount = myEBOInvestment.asset.residualValue.toDecimal()
           
           self.myPreTaxCashflow = myEBOInvestment.getBeforeTaxCash().toDecimal()
           self.myAfterTaxCashflow = myEBOInvestment.getAfterTaxCash().toDecimal()
           self.myTaxesPaid = self.myPreTaxCashflow - self.myAfterTaxCashflow
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
            Text("\(percentFormatter(percent:myIRRPTCF.toString(decPlaces: 5), locale: myLocale, places: 3))")
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
        }
        .font(myFont)
    }
    
    var eboTotalDueItem: some View {
        HStack {
            Text("Total Amount Due:")
            Spacer()
            Text("\(getFormattedValue(amount:myTotalEBODue.toString(decPlaces: 2), viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
        }
        .font(myFont)
    }
}

extension EBOSummaryView {
    var preTaxEBOCashItem: some View {
        HStack {
            Text("Pre-Tax Cash:")
            Spacer()
            Text("\(getFormattedValue(amount:myPreTaxCashflow.toString(decPlaces: 2), viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
        }
        .font(myFont)
    }
    
    var taxesPaidItem: some View {
        HStack {
            Text("Tax Paid:")
            Spacer()
            Text("\(getFormattedValue(amount:myTaxesPaid.toString(decPlaces: 2), viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
        }
        .font(myFont)
    }
    
    var afterTaxEBOCashItem: some View {
        HStack {
            Text("After-Tax Cash:")
            Spacer()
            Text("\(getFormattedValue(amount:myAfterTaxCashflow.toString(decPlaces: 2), viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
        }
        .font(myFont)
    }
    
}

