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
    
    @State var viewAsPctOfCost: Bool = false
    
    //Yields
    @State var myATYield: Decimal = 0.075
    @State var myBTYield: Decimal = 0.075
    @State var myIRRofPTCF: Decimal = 0.075
    @State var myNetProfit: String = "0.00"
    @State var myPayback: Int = 0
    @State var myAverageLife: Decimal = 2.0
    
    
    @State var lineHeight: CGFloat = 12
    @State var frameHeight: CGFloat = 12
    
    var body: some View {
        VStack {
            ReportHeaderView(name: "Results", viewAsPct: myViewAsPct, path: $path, isDark: $isDark)
            Form {
                Section(header: Text("Profitability"), footer: (Text("File Name: \(currentFile)"))) {
                    afterTaxYieldItem
                    beforeTaxYieldItem
                    preTaxIRRItem
                    inherentProfitItem
                    simplePaybackItem
                    averageLifeItem
                }
                
                Section(header: Text("Additional Results")) {
                    cashflowItem
                    rentalsItem
                    earlyBuyoutItem
                }
            }
        }
        
        .environment(\.defaultMinListRowHeight, lineHeight)
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear{
            self.myInvestment.calculate()
            self.myInvestment.hasChanged = false
            self.myATYield = myInvestment.getMISF_AT_Yield()
            self.myBTYield = myInvestment.getMISF_BT_Yield()
            self.myIRRofPTCF = myInvestment.getIRR_PTCF()
            self.myNetProfit = myInvestment.getAfterTaxCash()
            self.myPayback = myInvestment.getSimplePayback()
            self.myAverageLife = myInvestment.getAverageLife()
        }
    }
    
    private func myViewAsPct() {
        self.viewAsPctOfCost.toggle()
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
        }
        .frame(width: UIScreen.main.bounds.width * 0.8, height: frameHeight)
    }
    
    var beforeTaxYieldItem: some View {
        HStack{
            Text("Before-Tax MISF:")
                .font(myFont)
            Spacer()
            Text("\(percentFormatter(percent:myBTYield.toString(decPlaces: 5), locale: myLocale, places: 3))")
                .font(myFont)
        }
        .frame(width: UIScreen.main.bounds.width * 0.8, height: frameHeight)
    }
    
    
    var preTaxIRRItem: some View {
        HStack{
            Text("IRR PTCF:")
                .font(myFont)
            Spacer()
            Text("\(percentFormatter(percent:myIRRofPTCF.toString(decPlaces: 5), locale: myLocale, places: 3))")
                .font(myFont)
        }
        .frame(width: UIScreen.main.bounds.width * 0.8, height: frameHeight)
    }
}

//Statistics
extension SummaryOfResultsView {
    var inherentProfitItem: some View {
        HStack {
            Text("Inherent Profit:")
            Spacer()
            Text("\(getFormattedValue(amount: myNetProfit, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
        }.font(myFont)
        
    }
    
    var simplePaybackItem: some View {
        HStack {
            Text("Payback (mons):")
            Spacer()
            Text("\(myPayback)")
        }.font(myFont)
    }
    
    var averageLifeItem: some View {
        HStack {
            Text("Average Life (yrs):")
            Spacer()
            Text("\(amountFormatter(amount:myAverageLife.toString(decPlaces: 2), locale: myLocale))")
        }.font(myFont)
    }
    
}


//Additional Results
extension SummaryOfResultsView {
    var cashflowItem: some View {
        HStack {
            Text("Cashflows")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(14)
        }
    }
    
    var rentalsItem: some View {
        HStack {
            Text("Rentals")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(15)
        }
    }
    
    var earlyBuyoutItem: some View {
        HStack {
            Text("Early Buyout")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .foregroundColor(myInvestment.earlyBuyoutExists ? .black : .gray)
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            if myInvestment.earlyBuyoutExists {
                path.append(16)
            }
           
        }
    }
}
