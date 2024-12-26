//
//  TerminationValuesView.swift
//  CFLTax
//
//  Created by Steven Williams on 9/20/24.
//

import SwiftUI

struct TerminationValuesView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var myComponentTValues: TerminationValues = TerminationValues()
    @State var myTValues: Cashflows = Cashflows()
    @State var viewAsPctOfCost: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(headerType: .report, name: "Termination Values", viewAsPct: myViewAsPct, goBack: myGoBack, withBackButton: true, withPctButton: true, path: $path, isDark: $isDark)
            Form {
                Section(header: Text("\(currentFile)")) {
                    ForEach(myTValues.items) { item in
                        HStack {
                            Text("\(item.dueDate.toStringDateShort(yrDigits: 2))")
                            Spacer()
                            Text("\(CFLTax.getFormattedValue(amount: item.amount, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
                        }
                        .font(myFont)
                    }
                }
                
                Section(header: Text("Count")) {
                    HStack{
                        Text("Count:")
                        Spacer()
                        Text("\(myTValues.items.count)")
                    }
                    .font(myFont)
                }
               
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if myTValues.items.count > 0 {
                myTValues.items.removeAll()
            }
            myComponentTValues.createTable(aInvestment: myInvestment)
            myTValues = myComponentTValues.createTerminationValues()
        }
    }
    
    private func myViewAsPct() {
        self.viewAsPctOfCost.toggle()
    }
    
    private func myGoBack() {
        self.path.removeLast()
    }
    
    func getFormattedValue (amount: String) -> String {
        if viewAsPctOfCost {
            let decAmount = amount.toDecimal()
            let decCost = myInvestment.getAssetCost(asCashflow: false)
            let decPercent = decAmount / decCost
            let strPercent: String = decPercent.toString(decPlaces: 5)
            
            return percentFormatter(percent: strPercent, locale: myLocale, places: 3)
        } else {
             return amountFormatter(amount: amount, locale: myLocale)
        }
    }
}

#Preview {
    TerminationValuesView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
