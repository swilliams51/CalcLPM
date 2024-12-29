//
//  PreTaxLeaseCashflowsView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/20/24.
//

import SwiftUI

struct PreTaxLeaseCashflowsView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var viewAsPct: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(headerType: .report, name: "B/T Cashflows", viewAsPct: myViewAsPct, goBack: myGoBack, withBackButton: true, withPctButton: true, path: $path, isDark: $isDark)
            Form{
                Section(header: Text("\(currentFile)")) {
                    ForEach(myInvestment.beforeTaxCashflows.items) { item in
                        HStack {
                            Text("\(item.dueDate.toStringDateShort())")
                            Spacer()
                            Text("\(getFormattedValue(amount: item.amount, viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment))")
                        }
                        .font(myFont)
                    }
                }
                Section(header: Text("Results")) {
                    HStack {
                        Text("\(myInvestment.beforeTaxCashflows.count())")
                        Spacer()
                        Text("\(getFormattedValue(amount: myInvestment.beforeTaxCashflows.getTotal().toString(decPlaces: 2), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment))")
                    }
                    .font(myFont)
                }
                    
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            myInvestment.setBeforeTaxCashflows()
        }
    }
    
    private func myViewAsPct() {
        self.viewAsPct.toggle()
    }
    
    private func myGoBack() {
        self.path.removeLast()
    }
    
}


#Preview {
    PreTaxLeaseCashflowsView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
