//
//  RentSummaryView.swift
//  CFLTax
//
//  Created by Steven Williams on 10/10/24.
//

import SwiftUI

struct RentSummaryView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State private var viewAsPctOfCost: Bool = false
    @State var implicitRate: String = "0.00"
    @State var presentValue: String = "0.00"
    @State var maxGuaranty: String = "0.00"
    @State var presentValue1: String = "0.00"
    @State var presentValue2: String = "0.00"
    @State var discountRate: String = "0.00"
    @State var eboAllInRate: String = "0.00"
    @State private var amounts: [String] = [String]()
    
    @State private var showPop: Bool = false
    @State private var payHelp = implicitRateHelp
    @State private var showPop1: Bool = false
    @State private var payHelp1 = pvOneHelp
    @State private var showPop2: Bool = false
    @State private var payHelp2 = pvTwoHelp
    @State private var showPop3: Bool = false
    @State private var payHelp3 = pvImplicitHelp
    @State private var showPop4: Bool = false
    @State private var payHelp4 = maxGuarantyHelp
    
    //@State var lineHeight: CGFloat = 12
    @State var frameHeight: CGFloat = 12
    
    var body: some View {
        VStack(spacing: 0){
            HeaderView(headerType: .report, name: "Rent Summary", viewAsPct: myViewAsPct, goBack: myGoBack, withBackButton: true, withPctButton: true, path: $path, isDark: $isDark)
            Form {
                Section(header: Text("Accounting"), footer: Text("File Name: \(currentFile)")) {
                    implicitRateItem
                    pvAtImplicitRateItem
                    maxLesseeGuarantyItem
                }
                
                Section(header: Text("Present Values")) {
                    presentValueItem
                    presentValue2Item
                }
                
                Section(header: Text("Lease Rate Factors")) {
                    ForEach(Array(amounts.enumerated()), id: \.offset) { index, item in
                        leaseRateFactorRow(amount: item, index: index)
                    }
                }
                
                if myInvestment.earlyBuyoutExists{
                    Section(header: Text("Early Buyout")) {
                        eboAllInRateItem
                    }
                }
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.implicitRate = myInvestment.getImplicitRate().toString(decPlaces: 6)
            self.discountRate = myInvestment.economics.discountRateForRent
            self.maxGuaranty = myInvestment.getMaxLesseeGuaranty().toString(decPlaces: 6)
            self.presentValue = myInvestment.getPVOfObligations(aDiscountRate: implicitRate.toDecimal()).toString(decPlaces: 6)
            self.presentValue1 = myInvestment.getPVOfRents().toString(decPlaces: 8)
            self.presentValue2 = myInvestment.getPVOfObligations(aDiscountRate: discountRate.toDecimal()).toString(decPlaces: 8)
            
            if myInvestment.earlyBuyoutExists{
                self.eboAllInRate = myInvestment.getEBOAllInRate(aEBO: self.myInvestment.earlyBuyout).toString(decPlaces: 6)
            }
           
            for x in 0..<myInvestment.rent.groups.count {
                let strAmount: String = myInvestment.rent.groups[x].amount
                self.amounts.append(strAmount)
            }
        }
        .popover(isPresented: $showPop) {
            PopoverView(myHelp: $payHelp, isDark: $isDark)
        }
        .popover(isPresented: $showPop1) {
            PopoverView(myHelp: $payHelp1, isDark: $isDark)
        }
        .popover(isPresented: $showPop2) {
            PopoverView(myHelp: $payHelp2, isDark: $isDark)
        }
        .popover(isPresented: $showPop3 ) {
            PopoverView(myHelp: $payHelp3, isDark: $isDark)
        }
        .popover(isPresented: $showPop4 ) {
            PopoverView(myHelp: $payHelp4, isDark: $isDark)
        }
        
    }
    
    @ViewBuilder func leaseRateFactorRow(amount: String, index: Int) -> some View {
        HStack{
            Text("LRF\(index + 1):")
            Spacer()
            Text("\(getFormattedValue(amount: getAmount(amount: amount, index: index), viewAsPercentOfCost: true, aInvestment: myInvestment, pctPlaces: 6))")
        }
        .font(myFont)
    }
    
    private func myViewAsPct() {
        self.viewAsPctOfCost.toggle()
    }
    
    private func myGoBack() {
        self.path.removeLast()
    }
    
    private func getAmount(amount: String, index: Int) -> String {
        var strAmount = amount
        
        if myInvestment.rent.groups[index].isInterim {
            if myInvestment.rent.groups[index].paymentType == .dailyEquivNext {
                strAmount = getDailyRentForNext(aRent: myInvestment.rent, aFreq: myInvestment.leaseTerm.paymentFrequency, aDayCountMethod: myInvestment.economics.dayCountMethod).toString(decPlaces: 8)
            } else if myInvestment.rent.groups[index].paymentType == .dailyEquivAll{
                strAmount = getDailyRentForAll(aRent: myInvestment.rent, aFreq: myInvestment.leaseTerm.paymentFrequency, aDayCountMethod: myInvestment.economics.dayCountMethod).toString(decPlaces: 8)
            }
        }
        
        return strAmount
    }
}

#Preview {
    RentSummaryView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}

extension RentSummaryView {
    var implicitRateItem: some View {
        HStack{
            Text("Implicit Rate:")
                .font(myFont)
            Image(systemName: "questionmark.circle")
                .foregroundColor(Color.theme.accent)
                .onTapGesture {
                    self.showPop = true
                }
            Spacer()
            Text("\(percentFormatter(percent: implicitRate, locale: myLocale, places: 3))")
                .font(myFont)
        }
    }
    
    var pvAtImplicitRateItem: some View {
        HStack{
            Text("PV @ Implicit Rate:")
                    .font(myFont)
            Image(systemName: "questionmark.circle")
                .foregroundColor(Color.theme.accent)
                .onTapGesture {
                    self.showPop3 = true
                }
            Spacer()
            Text("\(getFormattedValue(amount: presentValue, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
                .font(myFont)
        }
    }
    
    var maxLesseeGuarantyItem: some View {
        HStack{
            Text("Max Lessee Gty:")
                    .font(myFont)
            Image(systemName: "questionmark.circle")
                .foregroundColor(Color.theme.accent)
                .onTapGesture {
                    self.showPop4 = true
                }
            Spacer()
            Text("\(getFormattedValue(amount: maxGuaranty, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
                .font(myFont)
        }
    }
    
    var presentValueItem: some View {
            HStack{
                Text("PV1 @ \(getDiscountRateText()):")
                    .font(myFont)
                Image(systemName: "questionmark.circle")
                    .foregroundColor(Color.theme.accent)
                    .onTapGesture {
                        self.showPop1 = true
                    }
                Spacer()
                Text("\(getFormattedValue(amount: presentValue1, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
                    .font(myFont)
            }
    }
    
    var presentValue2Item: some View {
        HStack{
            Text("PV2 @ \(getDiscountRateText()):")
                .font(myFont)
            Image(systemName: "questionmark.circle")
                .foregroundColor(Color.theme.accent)
                .onTapGesture {
                    self.showPop2 = true
                }
            Spacer()
            Text("\(getFormattedValue(amount: presentValue2, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
                .font(myFont)
        }
    }
    
    var eboAllInRateItem: some View {
        HStack{
            Text("All-In Rate:")
                .font(myFont)
            Spacer()
            Text("\(percentFormatter(percent: eboAllInRate, locale: myLocale, places: 3))")
                .font(myFont)
        }
    }
    
    func getDiscountRateText() -> String {
        let strDiscountRate: String = percentFormatter(percent: discountRate, locale: myLocale, places: 3)
        return strDiscountRate
    }
}
