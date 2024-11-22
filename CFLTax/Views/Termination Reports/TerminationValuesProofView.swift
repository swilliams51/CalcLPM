//
//  SummaryScrollView.swift
//  CFLTax
//
//  Created by Steven Williams on 9/26/24.
//

import SwiftUI

struct TerminationValuesProofView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var myPeriodicIB: PeriodicInvestmentBalances = PeriodicInvestmentBalances()
    @State var myComponentValues: TerminationValues = TerminationValues()
    @State var myTValues: Cashflows = Cashflows()
    @State var myTVDate: Date = Date()
    @State var myTV: Decimal = 0.0
    @State var myIB: Decimal = 0.0
    @State var myDeprecBalance: Decimal = 0.0
    @State var myGain: Decimal = 0.0
    @State var myTaxOnGain: Decimal = 0.0
    @State var myYTDIncome:  Decimal = 0.0
    @State var myAdvanceRent:  Decimal = 0.0
    @State var myAdjustedYTDIncome:  Decimal = 0.0
    @State var myTaxOnYTDIncome:  Decimal = 0.0
    @State var myTaxesPaidYTD: Decimal = 0.0
    @State var myCalculatedIB:  Decimal = 0.0
    @State var myAdjustedIB:  Decimal = 0.0
    @State var myActualIB:  Decimal = 0.0
    @State var myTaxRate:  Decimal = 0.0
    @State var x: Int = 0
    @State var viewAsPct: Bool = false
    
    var body: some View {
        VStack {
            ReportHeaderView(name: "Termination Values Proof", viewAsPct: myViewAsPct, path: $path, isDark: $isDark)
            terminationDateItem
            Grid(alignment: .trailing, horizontalSpacing: 20, verticalSpacing: 5) {
                terminationValueRowItem
                depreciationRowItem
                gainOnTerminationRowItem
                taxOnGainRowItem
                ytdIncomeRowItem
                advanceRentRowItem
                adjustedYTDIncomeRowItem
                taxOnAdjustedYTDIncomeRowItem
                taxesPaidYTDRowItem
                calculatedInvestmentBalanceRowItem
                advanceRentRowItem
                adjustedInvestmentBalanceRowItem
                blankRowItem
                actualInvestmentBalanceRowItem
            }
            Spacer()
            terminationDateButtonsRow
        }
        Spacer()
        .background(Color.black.opacity(isDark ? 1.0 : 0.1))
        .ignoresSafeArea(.all)
       
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.myComponentValues.createTable(aInvestment: self.myInvestment)
            self.myTValues = myComponentValues.createTerminationValues()
            if myPeriodicIB.items.count > 0 {
                myPeriodicIB.items.removeAll()
            }

            myPeriodicIB.createInvestmentBalances(aInvestment: myInvestment)
            self.myTaxRate = myInvestment.taxAssumptions.federalTaxRate.toDecimal()
            updateValues()
        }

    }
    
    private func updateValues() {
        self.myTVDate = myTValues.items[x].dueDate
        self.myTV = myTValues.items[x].amount.toDecimal()
        self.myIB = myComponentValues.items[0].items[x].amount.toDecimal()
        self.myDeprecBalance = myComponentValues.items[1].items[x].amount.toDecimal()
        self.myYTDIncome = myComponentValues.items[2].items[x].amount.toDecimal()
        self.myTaxesPaidYTD = myComponentValues.items[3].items[x].amount.toDecimal()
        self.myAdvanceRent = myComponentValues.items[4].items[x].amount.toDecimal()
        self.myActualIB = myPeriodicIB.items[x].amount.toDecimal()
        
        self.myGain = myTV - myDeprecBalance
        self.myTaxOnGain = myGain * myTaxRate * -1.0
        self.myAdjustedYTDIncome = myYTDIncome - myAdvanceRent
        self.myTaxOnYTDIncome = myAdjustedYTDIncome * myTaxRate * -1.0
        
        self.myCalculatedIB = myTV + myTaxOnGain + myTaxOnYTDIncome + myTaxesPaidYTD
        self.myAdjustedIB = myCalculatedIB - myAdvanceRent
        
    }
    
    private func myViewAsPct() {
        self.viewAsPct.toggle()
    }
}
   


#Preview {
    TerminationValuesProofView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}

extension TerminationValuesProofView {
    var terminationDateButtonsRow: some View {
        HStack{
            Text("Next")
                .onTapGesture {
                    if x < myTValues.count() - 1 {
                        x += 1
                        updateValues()
                    }
                }
            Image(systemName: "chevron.right")
            Spacer()
            Image(systemName: "chevron.left")
            Text("Previous")
                .onTapGesture {
                    if x > 0 {
                        x -= 1
                        updateValues()
                    }
                }
        }
        .font(myFont)
        .foregroundColor(Color("BackButtonColor"))
        .padding()
    }
}

extension TerminationValuesProofView {
    var terminationDateItem: some View {
        HStack {
            Text("Termination Date: ")
            Text("\(myTVDate.toStringDateShort(yrDigits: 2))")
        }
        .font(myFont)
        .padding()
    }
    
    var terminationValueRowItem: some View {
        GridRow() {
            Text("Termination Value:")
            Text("Blank Cell")
                .foregroundColor(.clear)
            Text("\(getFormattedValue(amount: myTV.toString(),viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, places: 0))")
                .gridColumnAlignment(.trailing)
        }.font(myFont)
    }
    
    var depreciationRowItem: some View {
        GridRow() {
            Text("Depreciable Balance:")
            Text("\(getFormattedValue(amount: myDeprecBalance.toString(), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, places: 0))")
            Text("Blank Cell")
                .foregroundColor(.clear)
        }.font(myFont)
    }
    
    var gainOnTerminationRowItem: some View {
        GridRow() {
            Text("Gain on Termination:")
            Text("\(getFormattedValue(amount: myGain.toString(), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, places: 0))")
            Text("Blank Cell")
                .foregroundColor(.clear)
        }.font(myFont)
    }
    
     var taxOnGainRowItem: some View {
         GridRow() {
             Text("Tax on Gain:")
             Text("Blank Cell")
                 .foregroundColor(.clear)
             Text("\(getFormattedValue(amount: myTaxOnGain.toString(), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, places: 0))")
         }.font(myFont)
    }
    
    var ytdIncomeRowItem: some View {
        GridRow() {
            Text("YTD Income:")
            Text("\(getFormattedValue(amount: myYTDIncome.toString(), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, places: 0))")
            Text("Blank Cell")
                .gridColumnAlignment(.trailing)
                .foregroundColor(.clear)
        }.font(myFont)
    }
    
    var advanceRentRowItem: some View {
        GridRow() {
            Text("Advance Rent:")
            Text("\(getFormattedValue(amount: myAdvanceRent.toString(), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, places: 0))")
            Text("Blank Cell")
                .foregroundColor(.clear)
       }.font(myFont)
    }
    
    var adjustedYTDIncomeRowItem: some View {
        GridRow() {
            Text("Adj YTD Income:")
            Text("\(getFormattedValue(amount: myAdjustedYTDIncome.toString(), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, places: 0))")
            Text("Blank Cell")
                .gridColumnAlignment(.trailing)
                .foregroundColor(.clear)
        }.font(myFont)
    }
    
    var taxOnAdjustedYTDIncomeRowItem: some View {
        GridRow() {
            Text("Tax on Adj Income:")
            Text("Blank Cell")
                .foregroundColor(.clear)
            Text("\(getFormattedValue(amount: myTaxOnYTDIncome.toString(),viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, places: 0))")
        }.font(myFont)
    }
    
    var taxesPaidYTDRowItem: some View {
        GridRow() {
            Text("Taxes Paid YTD:")
            Text("Blank Cell")
                .foregroundColor(.clear)
            Text("\(getFormattedValue(amount: myTaxesPaidYTD.toString(), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, places: 0))")
        }.font(myFont)
    }
    
    var calculatedInvestmentBalanceRowItem: some View {
        GridRow() {
            Text("Investment Balance:")
            Text("Blank Cell")
                .foregroundColor(.clear)
            Text("\(getFormattedValue(amount: myCalculatedIB.toString(), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, places: 0))")
        }.font(myFont)
    }
    
    var adjustedInvestmentBalanceRowItem: some View {
        GridRow() {
            Text("Investment Balance:")
            Text("Blank Cell")
                .foregroundColor(.clear)
            Text("\(getFormattedValue(amount: myAdjustedIB.toString(), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, places: 0))")
        }.font(myFont)
    }
    
    var blankRowItem: some View {
        GridRow() {
            Text("Blank Cell")
                .foregroundColor(.clear)
            Text("Blank Cell")
                .foregroundColor(.clear)
            Text("Blank Cell")
                .foregroundColor(.clear)
        }.font(myFont)
    }
    
    var actualInvestmentBalanceRowItem: some View {
        GridRow() {
            Text("Investment Balance:")
            Text("Blank Cell")
                .foregroundColor(.clear)
            Text("\(getFormattedValue(amount: myActualIB.toString(), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, places: 0))")
        }.font(myFont)
    }
    
    
    
}
