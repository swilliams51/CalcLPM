//
//  NetAfterTaxCashflowsView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/19/24.
//

import SwiftUI

struct NetAfterTaxCashflowsView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var viewAsPct: Bool = false
    
    var body: some View {
        VStack {
            ReportHeaderView(name: "Net A/T Cashflows", viewAsPct: myViewAsPct, path: $path, isDark: $isDark)
            Form {
                Section(header: Text("\(currentFile)")) {
                    ForEach(myInvestment.afterTaxCashflows.items) { item in
                        HStack {
                            Text("\(item.dueDate.toStringDateShort(yrDigits: 2))")
                            Spacer()
                            Text("\(getFormattedValue(amount: item.amount, viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment))")
                        }
                        .font(myFont)
                    }
                }
                Section(header: Text("Totals")) {
                    HStack {
                        Text("\(myInvestment.afterTaxCashflows.count())")
                        Spacer()
                        Text("\(getFormattedValue(amount: myInvestment.afterTaxCashflows.getTotal().toString(decPlaces: 2), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment))")
                    }
                    .font(myFont)
                }
                
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.myInvestment.calculate()
        }
    }
    
    private func myViewAsPct() {
        self.viewAsPct.toggle()
    }
            
}



#Preview {
    NetAfterTaxCashflowsView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
