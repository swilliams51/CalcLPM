//
//  EBOPreTaxCashflowsView.swift
//  CFLTax
//
//  Created by Steven Williams on 10/16/24.
//

import SwiftUI

struct EBOBeforeTaxCashflowsView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    @State var myBTCashflows: Cashflows = Cashflows()
    @State var viewAsPctOfCost: Bool = false
    
    var body: some View {
        VStack (spacing:0) {
            HeaderView(headerType: .report, name: "EBO B/T Cashflows", viewAsPct: myViewAsPct, goBack: myGoBack, withBackButton: true, withPctButton: true, path: $path, isDark: $isDark)
            Form {
                Section(header: Text("File Name: \(currentFile)")) {
                    ForEach(myBTCashflows.items) { item in
                        HStack {
                            Text("\(item.dueDate.toStringDateShort())")
                            Spacer()
                            Text("\(getFormattedValue(amount: item.amount, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
                        }
                        .font(myFont)
                    }
                }
                Section(header: Text("Totals")) {
                    HStack{
                        Text("\(myBTCashflows.items.count)")
                        Spacer()
                        Text("\(getFormattedValue(amount: myBTCashflows.getTotal().toString(decPlaces: 4), viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
                    }
                    .font(myFont)
                }
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if myBTCashflows.items.count > 0 {
                myBTCashflows.items.removeAll()
            }
            myBTCashflows = myInvestment.getEBO_BTCashflows(aEBO: myInvestment.earlyBuyout)
        }
    }
    
    private func myViewAsPct() {
        self.viewAsPctOfCost.toggle()
    }
    
    private func myGoBack() {
        self.path.removeLast()
    }
}

#Preview {
    EBOBeforeTaxCashflowsView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
