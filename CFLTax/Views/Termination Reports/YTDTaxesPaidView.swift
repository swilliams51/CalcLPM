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
        VStack {
            ReportHeaderView(name: "YTD Taxes Paid", viewAsPct: myViewAsPct, path: $path, isDark: $isDark)
            Form {
                Section(header: Text("\(currentFile)")) {
                    ForEach(myPeriodicTaxesPaid.items) { item in
                        HStack {
                            Text("\(item.dueDate.toStringDateShort(yrDigits: 2))")
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
}

#Preview {
    YTDTaxesPaidView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
