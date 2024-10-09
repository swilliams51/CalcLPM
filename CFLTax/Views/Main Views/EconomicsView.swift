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
    @Binding var currentFile: String
    
    @State var myEconomics: Economics = Economics()

    var body: some View {
        Form{
            Section(header: Text("Parameters").font(myFont2), footer: (Text("FileName: \(currentFile)").font(myFont2))){
                yieldMethodItem
                yieldTargetItem
                solveForItem
                discountRateItem
                dayCountMethodItem
            }
            Section(header: Text("Submit Form")){
                SubmitFormButtonsView(cancelName: "Cancel", doneName: "Done", cancel: myCancel, done: myDone, isDark: $isDark)
            }
            
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
            self.myEconomics = myInvestment.economics
        }
    }
}

#Preview {
    EconomicsView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}


extension EconomicsView {
    var yieldMethodItem: some View {
        HStack{
            Text("Yield Method:")
            Picker(selection: $myEconomics.yieldMethod, label: Text("")) {
                ForEach(YieldMethod.allTypes, id: \.self) { item in
                    Text(item.toString())
                }
            }
        }
    }
    var solveForItem: some View {
        HStack{
            Text("Solve For:")
            Picker(selection: $myEconomics.solveFor, label: Text("")) {
                ForEach(SolveForOption.allCases, id: \.self) { item in
                    Text(item.toString())
                }
            }
        }
    }
    
    var dayCountMethodItem: some View {
        HStack{
            Text("Day Count Method:")
            Picker(selection: $myEconomics.dayCountMethod, label: Text("")) {
                ForEach(DayCountMethod.allTypes, id: \.self) { item in
                    Text(item.toString())
                }
            }
        }
    }
}

extension EconomicsView {
    var yieldTargetItem: some View {
        HStack {
            Text("Yield Target:")
                .font(myFont2)
                .onTapGesture {
                    self.path.append(17)
                }
            Spacer()
            Text("\(percentFormatter(percent:myEconomics.yieldTarget, locale: myLocale, places: 3))")
                .font(myFont2)
                .onTapGesture {
                    self.path.append(17)
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
            Text("\(percentFormatter(percent:myEconomics.discountRateForRent, locale: myLocale, places: 3))")
                .font(myFont2)
                .onTapGesture {
                    self.path.append(18)
                }
        }
    }
}

extension EconomicsView {
    func myCancel(){
        path.removeLast()
    }
    func myDone() {
        if self.myInvestment.economics.isEqual(to: myEconomics) == false{
            self.myInvestment.hasChanged = true
            self.myInvestment.economics = myEconomics
        }
        path.removeLast()
    }
}
