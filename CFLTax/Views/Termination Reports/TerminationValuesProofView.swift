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
    
    var body: some View {
        VStack {
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
            HStack{
                Text("Next")
                    .onTapGesture {
                        x += 1
                        updateValues()
                    }
                Spacer()
                Text("Previous")
                    .onTapGesture {
                        x -= 1
                        updateValues()
                    }
            }.padding()
            
        }
           
       
        Spacer()
        .navigationTitle("TValue Proof")
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
        self.myTaxOnYTDIncome = myAdjustedYTDIncome * myTaxRate * 1.0
        
        self.myCalculatedIB = myTV + myTaxOnGain + myTaxOnYTDIncome + myTaxesPaidYTD
        self.myAdjustedIB = myCalculatedIB - myAdvanceRent
        
    }


}
   


#Preview {
    TerminationValuesProofView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}



extension TerminationValuesProofView {
    var terminationDateItem: some View {
        HStack {
            Text("Termination Date:")
                .padding()
            Spacer()
            Text("\(myTVDate.toStringDateShort(yrDigits: 2))")
                .padding(.trailing, 10)
        }
        .padding()
    }
    
    var terminationValueRowItem: some View {
        GridRow() {
            Text("Termination Value:")
                .font(.subheadline)
        
            Text("Blank Cell")
                .font(.subheadline)
                .foregroundColor(.clear)
    
            Text("\(amountFormatter(amount: myTV.toString(),locale: myLocale, places: 0))")
                .font(.subheadline)
                .gridColumnAlignment(.trailing)
        }
    }
    
    var depreciationRowItem: some View {
        GridRow() {
            Text("Depreciable Balance:")
                .font(.subheadline)
            Text("\(amountFormatter(amount: myDeprecBalance.toString(), locale: myLocale, places: 0))")
                .font(.subheadline)
            Text("Blank Cell")
                .font(.subheadline)
                .foregroundColor(.clear)
        }
    }
    
    var gainOnTerminationRowItem: some View {
        GridRow() {
            Text("Gain on Termination:")
                .font(.subheadline)
            Text("\(amountFormatter(amount: myGain.toString(), locale: myLocale, places: 0))")
                .font(.subheadline)
            Text("Blank Cell")
                .font(.subheadline)
                .foregroundColor(.clear)
       }
    }
    
     var taxOnGainRowItem: some View {
         GridRow() {
             Text("Tax on Gain:")
                 .font(.subheadline)
         
             Text("Blank Cell")
                 .font(.subheadline)
                 .foregroundColor(.clear)
     
             Text("\(amountFormatter(amount: myTaxOnGain.toString(), locale: myLocale, places: 0))")
                 .font(.subheadline)
         }
    }
    
    var ytdIncomeRowItem: some View {
        GridRow() {
            Text("YTD Income:")
                .font(.subheadline)
            Text("\(amountFormatter(amount: myYTDIncome.toString(), locale: myLocale, places: 0))")
                .font(.subheadline)
            Text("Blank Cell")
                .font(.subheadline)
                .gridColumnAlignment(.leading)
                .foregroundColor(.clear)
       }
    }
    
    var advanceRentRowItem: some View {
        GridRow() {
            Text("Advance Rent:")
                .font(.subheadline)
            Text("\(amountFormatter(amount: myAdvanceRent.toString(), locale: myLocale, places: 0))")
                .font(.subheadline)
            Text("Blank Cell")
                .font(.subheadline)
                .foregroundColor(.clear)
       }
    }
    
    var adjustedYTDIncomeRowItem: some View {
        GridRow() {
            Text("Adj YTD Income:")
                .font(.subheadline)
            Text("\(amountFormatter(amount: myAdjustedYTDIncome.toString(), locale: myLocale, places: 0))")
                .font(.subheadline)
            Text("Blank Cell")
                .font(.subheadline)
                .gridColumnAlignment(.leading)
                .foregroundColor(.clear)
       }
    }
    
    var taxOnAdjustedYTDIncomeRowItem: some View {
        GridRow() {
            Text("Tax on Adj Income:")
                .font(.subheadline)

            Text("Blank Cell")
                .font(.subheadline)
                .foregroundColor(.clear)
    
            Text("\(amountFormatter(amount: myTaxOnYTDIncome.toString(), locale: myLocale, places: 0))")
                .font(.subheadline)
        }
    }
    
    var taxesPaidYTDRowItem: some View {
        GridRow() {
            Text("Taxes Paid YTD:")
                .font(.subheadline)
            Text("Blank Cell")
                .font(.subheadline)
                .foregroundColor(.clear)
            
            Text("\(amountFormatter(amount: myTaxesPaidYTD.toString(), locale: myLocale, places: 0))")
                .font(.subheadline)
        }
    }
    
    var calculatedInvestmentBalanceRowItem: some View {
        GridRow() {
            Text("Investment Balance:")
                .font(.subheadline)
            Text("Blank Cell")
                .font(.subheadline)
                .foregroundColor(.clear)
            
            Text("\(amountFormatter(amount: myCalculatedIB.toString(), locale: myLocale, places: 0))")
                .font(.subheadline)
        }
    }
    
    var adjustedInvestmentBalanceRowItem: some View {
        GridRow() {
            Text("Investment Balance:")
                .font(.subheadline)
            Text("Blank Cell")
                .font(.subheadline)
                .foregroundColor(.clear)
            
            Text("\(amountFormatter(amount: myAdjustedIB.toString(), locale: myLocale, places: 0))")
                .font(.subheadline)
        }
    }
    
    var blankRowItem: some View {
        GridRow() {
            Text("Blank Cell")
                .font(.subheadline)
                .foregroundColor(.clear)
            Text("Blank Cell")
                .font(.subheadline)
                .foregroundColor(.clear)
            Text("Blank Cell")
                .font(.subheadline)
                .foregroundColor(.clear)
        }
    }
    
    var actualInvestmentBalanceRowItem: some View {
        GridRow() {
            Text("Investment Balance:")
                .font(.subheadline)
            Text("Blank Cell")
                .font(.subheadline)
                .foregroundColor(.clear)
            
            Text("\(amountFormatter(amount: myActualIB.toString(), locale: myLocale, places: 0))")
                .font(.subheadline)
        }
    }
    
    
    
}
