//
//  EconomicsView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/10/24.
//

import SwiftUI

struct EconomicsView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    
    @State var myYieldMethod: YieldMethod = .MISF_BT
    @State var myYieldTarget: String = "0.05"
    @State var mySolveFor: SolveForOption = .yield
    @State var myDiscountRate: String = "0.06"
    @State var myDayCountMethod: DayCountMethod = .actualThreeSixty
    
    var body: some View {
        Form{
            Section(header: Text("Economics")){
                yieldMethodItem
                yieldTargetItem
                solveForItem
                discountRateItem
                dayCountMethodItem
            }
            Section(header: Text("Submit Form")){
                SubmitFormButtonsView(cancelName: "Cancel", doneName: "Done", cancel: myCancel, done: myDone, isDark: $isDark)            }
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationTitle("Economics")
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.myYieldMethod = self.myInvestment.economics.yieldMethod
            self.myYieldTarget = self.myInvestment.economics.yieldTarget
            self.mySolveFor = self.myInvestment.economics.solveFor
            self.myDiscountRate = self.myInvestment.economics.discountRateForRent
            self.myDayCountMethod = self.myInvestment.economics.dayCountMethod
        }
    }
    
    var yieldMethodItem: some View {
        HStack{
            Text("Yield Method:")
            Picker(selection: $myYieldMethod, label: Text("")) {
                ForEach(YieldMethod.allTypes, id: \.self) { item in
                    Text(item.toString())
                }
            }
        }
    }
    
    var yieldTargetItem: some View {
        HStack {
            Text("Yield Target:")
                .font(myFont2)
                .onTapGesture {
                    self.path.append(17)
                }
            Spacer()
            Text("\(percentFormatter(percent:myYieldTarget, locale: myLocale, places: 2))")
                .font(myFont2)
                .onTapGesture {
                    self.path.append(17)
                }
        }
    }
    
    var solveForItem: some View {
        HStack{
            Text("Solve For:")
            Picker(selection: $mySolveFor, label: Text("")) {
                ForEach(SolveForOption.allCases, id: \.self) { item in
                    Text(item.toString())
                }
            }
        }
    }
    
    var discountRateItem: some View {
        HStack {
            Text("Discount Rate:")
                .font(myFont2)
                .onTapGesture {
                    self.path.append(18)
                }
            Spacer()
            Text("\(percentFormatter(percent:myDiscountRate, locale: myLocale, places: 2))")
                .font(myFont2)
                .onTapGesture {
                    self.path.append(18)
                }
        }
    }
    
    var dayCountMethodItem: some View {
        HStack{
            Text("Day Count Method:")
            Picker(selection: $myDayCountMethod, label: Text("")) {
                ForEach(DayCountMethod.allTypes, id: \.self) { item in
                    Text(item.toString())
                }
            }
        }
    }
    
    
    func myCancel(){
        path.removeLast()
    }
    func myDone(){
        self.myInvestment.economics.yieldMethod = myYieldMethod
        self.myInvestment.economics.yieldTarget = myYieldTarget
        self.myInvestment.economics.solveFor = mySolveFor
        self.myInvestment.economics.discountRateForRent = myDiscountRate
        self.myInvestment.economics.dayCountMethod = myDayCountMethod
        path.removeLast()
    }
}

#Preview {
    EconomicsView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false))
}
