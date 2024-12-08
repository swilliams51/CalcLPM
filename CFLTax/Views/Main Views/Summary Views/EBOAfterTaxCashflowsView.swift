//
//  EBOAfterTaxCashflowsView.swift
//  CFLTax
//
//  Created by Steven Williams on 10/16/24.
//

import SwiftUI

struct EBOAfterTaxCashflowsView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var myATCashflows: Cashflows = Cashflows()
    @State var viewAsPctOfCost: Bool = false
    
    var body: some View {
        VStack {
            ReportHeaderView(name: "After-Tax Cashflows", viewAsPct: myViewAsPct, path: $path, isDark: $isDark)
            Form {
                Section(header: Text("File Name: \(currentFile)")) {
                    ForEach(myATCashflows.items) { item in
                        HStack {
                            Text("\(item.dueDate.toStringDateShort(yrDigits: 2))")
                            Spacer()
                            Text("\(getFormattedValue(amount: item.amount, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
                        }
                        .font(myFont)
                    }
                }
                Section(header: Text("Totals")) {
                    HStack{
                        Text("\(myATCashflows.items.count)")
                        Spacer()
                        Text("\(getFormattedValue(amount: myATCashflows.getTotal().toString(decPlaces: 4), viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
                    }
                    .font(myFont)
                }
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if myATCashflows.items.count > 0 {
                myATCashflows.items.removeAll()
            }
            myATCashflows = myInvestment.getEBO_ATCashflows(aEBO: myInvestment.earlyBuyout)
        }
    }
    
    private func myViewAsPct() {
        self.viewAsPctOfCost.toggle()
    }
}

#Preview {
    EBOAfterTaxCashflowsView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
