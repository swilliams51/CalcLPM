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
        HeaderView(headerType: .report, name: "Termination Values Proof", viewAsPct: myViewAsPct, goBack: myGoBack, withBackButton: true, withPctButton: true, path: $path, isDark: $isDark)
        VStack (spacing: 0){
            ScrollView {
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
                terminationDateButtonsRow
            }
            
            Spacer()
        }.background(isDark ? Color.black : Color.white)
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
    
    private func myGoBack() {
        self.path.removeLast()
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
        .foregroundColor(isDark ? Color.white : Color.black)
        .font(myFont)
        .padding()
    }
    
    var terminationValueRowItem: some View {
        GridRow() {
            Text("Termination Value:")
                .font(myFont)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Blank Cell")
                .foregroundColor(.clear)
            Text("\(getFormattedValue(amount: myTV.toString(),viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, pctPlaces: 0, amtPlaces: 0))")
                .gridColumnAlignment(.trailing)
                .font(myFont)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .foregroundColor(isDark ? Color.white : Color.black)
    }
    
    var depreciationRowItem: some View {
        GridRow() {
            Text("Depreciable Balance:")
                .font(myFont)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("\(getFormattedValue(amount: myDeprecBalance.toString(), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, pctPlaces: 0, amtPlaces: 0))")
                .font(myFont)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Blank Cell")
                .foregroundColor(.clear)
        }
        .foregroundColor(isDark ? Color.white : Color.black)
    }
    
    var gainOnTerminationRowItem: some View {
        GridRow() {
            Text("Gain on Termination:")
                .font(myFont)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("\(getFormattedValue(amount: myGain.toString(), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, pctPlaces: 0, amtPlaces: 0))")
                .font(myFont)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Blank Cell")
                .foregroundColor(.clear)
        }
        .foregroundColor(isDark ? Color.white : Color.black)
    }
    
     var taxOnGainRowItem: some View {
         GridRow() {
             Text("Tax on Gain:")
                 .font(myFont)
                 .lineLimit(1)
                 .minimumScaleFactor(0.5)
             Text("Blank Cell")
                 .foregroundColor(.clear)
             Text("\(getFormattedValue(amount: myTaxOnGain.toString(), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, pctPlaces: 0, amtPlaces: 0))")
                 .font(myFont)
                 .lineLimit(1)
                 .minimumScaleFactor(0.5)
         }
         .foregroundColor(isDark ? Color.white : Color.black)
    }
    
    var ytdIncomeRowItem: some View {
        GridRow() {
            Text("YTD Income:")
                .font(myFont)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("\(getFormattedValue(amount: myYTDIncome.toString(), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, pctPlaces: 0, amtPlaces: 0))")
                .font(myFont)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Blank Cell")
                .gridColumnAlignment(.trailing)
                .foregroundColor(.clear)
        }
        .foregroundColor(isDark ? Color.white : Color.black)
    }
    
    var advanceRentRowItem: some View {
        GridRow() {
            Text("Advance Rent:")
                .font(myFont)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("\(getFormattedValue(amount: myAdvanceRent.toString(), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, pctPlaces: 0, amtPlaces: 0))")
                .font(myFont)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Blank Cell")
                .foregroundColor(.clear)
       }
        .foregroundColor(isDark ? Color.white : Color.black)
    }
    
    var adjustedYTDIncomeRowItem: some View {
        GridRow() {
            Text("Adj YTD Income:")
                .font(myFont)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("\(getFormattedValue(amount: myAdjustedYTDIncome.toString(), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, pctPlaces: 0, amtPlaces: 0))")
                .font(myFont)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Blank Cell")
                .gridColumnAlignment(.trailing)
                .foregroundColor(.clear)
        }
        .foregroundColor(isDark ? Color.white : Color.black)
    }
    
    var taxOnAdjustedYTDIncomeRowItem: some View {
        GridRow() {
            Text("Tax on Adj Income:")
                .font(myFont)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Blank Cell")
                .foregroundColor(.clear)
            Text("\(getFormattedValue(amount: myTaxOnYTDIncome.toString(),viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, pctPlaces: 0, amtPlaces: 0))")
                .font(myFont)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .foregroundColor(isDark ? Color.white : Color.black)
    }
    
    var taxesPaidYTDRowItem: some View {
        GridRow() {
            Text("Taxes Paid YTD:")
                .font(myFont)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Blank Cell")
                .foregroundColor(.clear)
            Text("\(getFormattedValue(amount: myTaxesPaidYTD.toString(), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, pctPlaces: 0, amtPlaces: 0))")
                .font(myFont)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .foregroundColor(isDark ? Color.white : Color.black)
    }
    
    var calculatedInvestmentBalanceRowItem: some View {
        GridRow() {
            Text("Investment Balance:")
                .font(myFont)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Blank Cell")
                .foregroundColor(.clear)
            Text("\(getFormattedValue(amount: myCalculatedIB.toString(), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, pctPlaces: 0, amtPlaces: 0))")
                .font(myFont)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .foregroundColor(isDark ? Color.white : Color.black)
    }
    
    var adjustedInvestmentBalanceRowItem: some View {
        GridRow() {
            Text("Investment Balance:")
                .font(myFont)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Blank Cell")
                .foregroundColor(.clear)
            Text("\(getFormattedValue(amount: myAdjustedIB.toString(), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, pctPlaces: 0, amtPlaces: 0))")
                .font(myFont)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .foregroundColor(isDark ? Color.white : Color.black)
    }
    
    var blankRowItem: some View {
        GridRow() {
            Text("Blank Cell")
                .foregroundColor(.clear)
            Text("Blank Cell")
                .foregroundColor(.clear)
            Text("Blank Cell")
                .foregroundColor(.clear)
        }
    }
    
    var actualInvestmentBalanceRowItem: some View {
        GridRow() {
            Text("Investment Balance:")
                .font(myFont)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("Blank Cell")
                .foregroundColor(.clear)
            Text("\(getFormattedValue(amount: myActualIB.toString(), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment, pctPlaces: 0, amtPlaces: 0))")
                .font(myFont)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .foregroundColor(isDark ? Color.white : Color.black)
    }
    
    
    
}
