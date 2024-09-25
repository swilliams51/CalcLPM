//
//  DepreciationView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/9/24.
//

import SwiftUI

struct DepreciationView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    
    @State var myMethod: DepreciationType = .MACRS
    @State var macrsMode: Bool = true
    @State var myLife: Double = 3.0
    @State private var rangeOfYears: ClosedRange<Double> = 3.0...20.0
    @State var myConvention: ConventionType = .halfYear
    @State var myBonus: String = "0.0"
    @State var myITC: String = "0.0"
    @State var myBasisReduction: String = "0.0"
    @State var mySalvageValue: String = "0.0"
    
    var dblLife_MACRS: [Double] = [3, 5, 7, 10, 15, 20]
    var decBonus: [Decimal] = [0.0, 0.5, 1.0]
    
    var body: some View {
        Form {
            Section(header: Text("Inputs").font(myFont2), footer:(Text("FileName: \(currentFile)").font(myFont2))) {
                VStack {
                    depreciableBasisItem
                    depreciationMethod
                    if macrsMode {
                        macrsViewItem
                    } else {
                        straightLineViewItem
                    }
                }
            }
            Section(header: Text("Submit Form")) {
                SubmitFormButtonsView(cancelName: "Cancel", doneName: "Done", cancel: myCancel, done: myDone, isDark: $isDark)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationTitle("Depreciation")
        .navigationBarBackButtonHidden(true)
        .onAppear{
            self.myMethod = myInvestment.depreciation.method
            self.myLife = myInvestment.depreciation.life.toDouble()
            self.myConvention = myInvestment.depreciation.convention
            self.myBonus = myInvestment.depreciation.bonusDeprecPercent.toString(decPlaces: 4)
            self.myITC = myInvestment.depreciation.investmentTaxCredit.toString(decPlaces: 4)
            self.myBasisReduction = myInvestment.depreciation.basisReduction.toString()
            self.mySalvageValue = myInvestment.depreciation.salvageValue
        }
    }
    
    var macrsViewItem: some View {
        VStack {
            depreciableLife
            depreciationConvention
            bonusDepreciation
        }
        
    }
    
    var straightLineViewItem: some View {
        VStack{
            lifeInYearsItem
            depreciationConvention
            salvageValue
        }
    }
    
    var depreciableBasisItem: some View {
        HStack {
            Text("Basis:")
                .font(myFont2)
            Spacer()
            Text("\(amountFormatter(amount: myInvestment.asset.lessorCost, locale: myLocale))")
                .font(myFont2)
        }
    }
    
    var depreciationMethod: some View {
        HStack {
            Text("Method:")
                .font(myFont2)
            Picker(selection: $myMethod, label: Text("")) {
                ForEach(DepreciationType.twoTypes, id: \.self) { item in
                    Text(item.toString())
                }
                .onChange(of: myMethod) { oldValue, newValue in
                    if newValue == .MACRS {
                        macrsMode = true
                    } else {
                        macrsMode = false
                        
                    }
                    myInvestment.depreciation.method = newValue
                    myInvestment.hasChanged = true
                }
            }
        }
    }
    
    var depreciableLife: some View {
        HStack {
            Text("Life (in years):")
                .font(myFont2)
            Picker(selection: $myLife, label: Text("")) {
                ForEach(dblLife_MACRS, id: \.self) { item in
                    Text(item.toString())
                        .font(myFont2)
                }
            }
        }
    }
    
    var depreciationConvention: some View {
        HStack {
            Text("1st Yr Convention:")
                .font(myFont2)
            Picker(selection: $myConvention, label: Text("")) {
                ForEach(ConventionType.allCases, id: \.self) { item in
                    Text(item.toString())
                        .font(myFont2)
                }
            }
        }
        .padding(.bottom, 5)
    }
    
    var bonusDepreciation: some View {
        HStack {
            HStack {
                Text("Bonus:")
                    .font(myFont2)
                Image(systemName:"return")
            }
            Spacer()
            Text("\(percentFormatter(percent: myBonus, locale: myLocale, places: 2))")
                .font(myFont2)
        }
        .contentShape(Rectangle())
        .disabled(macrsMode ? false : true)
        .onTapGesture {
            self.path.append(16)
        }
        .padding(.bottom, 5)
    }
    
    var salvageValue: some View {
        HStack {
            HStack {
                Text("Salvage Value:")
                    .font(myFont2)
                Image(systemName: "return")
            }
            Spacer()
            Text("\(amountFormatter(amount: mySalvageValue, locale: myLocale))")
                .font(myFont2)
        }
        .contentShape(Rectangle())
        .disabled(macrsMode ? true : false)
        .onTapGesture {
            self.path.append(20)
        }
        .padding(.top, 10)
    }
    
    func myCancel() {
        self.path.removeLast()
    }
    
    func myDone() {
        if self.myMethod != self.myInvestment.depreciation.method {
            self.myInvestment.hasChanged = true
            self.myInvestment.depreciation.method = myMethod
        }
        if self.myLife != self.myInvestment.depreciation.life.toDouble() {
            self.myInvestment.hasChanged = true
            self.myInvestment.depreciation.life = myLife.toInteger()
        }
        if self.myConvention != self.myInvestment.depreciation.convention {
            self.myInvestment.hasChanged = true
            self.myInvestment.depreciation.convention = myConvention
        }
        if self.myBonus.toDecimal() != self.myInvestment.depreciation.bonusDeprecPercent {
            self.myInvestment.hasChanged = true
            self.myInvestment.depreciation.bonusDeprecPercent = myBonus.toDecimal()
        }
        if self.myInvestment.depreciation.investmentTaxCredit != myITC.toDecimal() {
            self.myInvestment.hasChanged = true
            self.myInvestment.depreciation.investmentTaxCredit = myITC.toDecimal()
        }
        if self.myBasisReduction.toDecimal() != self.myInvestment.depreciation.basisReduction {
            self.myInvestment.hasChanged = true
            self.myInvestment.depreciation.basisReduction = myBasisReduction.toDecimal()
        }
        if self.mySalvageValue != self.myInvestment.depreciation.salvageValue {
            self.myInvestment.hasChanged = true
            self.myInvestment.depreciation.salvageValue = mySalvageValue
        }
        self.path.removeLast()
    }
}

#Preview {
    DepreciationView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}


extension DepreciationView {
    var investmentTaxCredit: some View {
        HStack {
            Text("ITC:")
            Spacer()
            Text("\(percentFormatter(percent: myITC, locale: myLocale))")
        }
        .padding(.bottom, 10)
    }

    var basisReduction: some View {
        HStack {
            Text("Basis Reduction:")
            Spacer()
            Text("\(percentFormatter(percent: myBasisReduction, locale: myLocale))")
        }
        .padding(.top, 10)
    }
    
    var lifeInYearsItem: some View {
        VStack {
            HStack {
                Text("Life in Years:")
                    .font(myFont2)
                Spacer()
                Text("\(myLife.toString())")
                    .font(myFont2)
            }
            Slider(value: $myLife, in: 3...20, step: 1) {

            }
            .accentColor(ColorTheme().accent)
            .onChange(of: myLife) { oldValue, newValue in
                //self.selectedGroup.noOfPayments = newValue.toInteger()
            }
            HStack {
                Spacer()
                Stepper("", value: $myLife, in: rangeOfYears, step: 1, onEditingChanged: { _ in
                   
                }).labelsHidden()
                .transformEffect(.init(scaleX: 1.0, y: 0.9))
            }
        }
            
    }
   
  
    
    
}
