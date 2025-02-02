//
//  YTDTaxesPaidView.swift
//  CFLTax
//
//  Created by Steven Williams on 9/18/24.
//

import SwiftUI

struct YTDTaxesPaidView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var myPeriodicTaxesPaid: PeriodicYTDTaxesPaid = PeriodicYTDTaxesPaid()
    @State var viewAsPct: Bool = false
  
    var body: some View {
        VStack (spacing: 0) {
            HeaderView(headerType: .report, name: "YTD Taxes Paid", viewAsPct: myViewAsPct, goBack: myGoBack, withBackButton: true, withPctButton: true, path: $path, isDark: $isDark)
            Form {
                Section(header: Text("\(currentFile)")) {
                    ForEach(myPeriodicTaxesPaid.items) { item in
                        HStack {
                            Text("\(item.dueDate.toStringDateShort())")
                            Spacer()
                            Text("\(getFormattedValue(amount: item.amount, viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment))")
                        }
                        .font(myFont)
                    }
                }
                Section(header: Text("Count")) {
                    HStack{
                        Text("Count:")
                        Spacer()
                        Text("\(myPeriodicTaxesPaid.items.count)")
                    }
                    .font(myFont)
                }
               
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if myPeriodicTaxesPaid.items.count > 0 {
                myPeriodicTaxesPaid.items.removeAll()
            }

            myPeriodicTaxesPaid.createTable(aInvestment: myInvestment)
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
    YTDTaxesPaidView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
