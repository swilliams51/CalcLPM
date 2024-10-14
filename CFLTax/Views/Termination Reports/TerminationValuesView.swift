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
    @State var viewAsPercentOfCost: Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("\(currentFile)")) {
                ForEach(myTValues.items) { item in
                    HStack {
                        Text("\(item.dueDate.toStringDateShort(yrDigits: 2))")
                        Spacer()
                        Text("\(getFormattedValue(amount: item.amount))")
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
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
            ToolbarItem(placement: .topBarTrailing){
                Button(action: {
                    viewAsPercentOfCost.toggle()
                }) {
                    Image(systemName: "command.circle")
                        .tint(viewAsPercentOfCost ? Color.red : Color.black)
                }
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationTitle("Termination Values")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if myTValues.items.count > 0 {
                myTValues.items.removeAll()
            }
            myComponentTValues.createTable(aInvestment: myInvestment)
            myTValues = myComponentTValues.createTerminationValues()
        }
    }
    
    func getFormattedValue (amount: String) -> String {
        if viewAsPercentOfCost {
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
