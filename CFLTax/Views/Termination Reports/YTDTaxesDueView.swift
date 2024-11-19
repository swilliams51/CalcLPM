//
//  YTDTaxesDueView.swift
//  CFLTax
//
//  Created by Steven Williams on 9/29/24.
//

import SwiftUI

struct YTDTaxesDueView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var myPeriodicTaxesDue: PeriodicNetTaxesDue = PeriodicNetTaxesDue()
  
    var body: some View {
        VStack {
            ReportHeaderView(name: "YTD Taxes Due", viewAsPct: myViewAsPct, path: $path, isDark: $isDark)
            Form {
                Section(header: Text("\(currentFile)")) {
                    ForEach(myPeriodicTaxesDue.items) { item in
                        HStack {
                            Text("\(item.dueDate.toStringDateShort(yrDigits: 2))")
                            Spacer()
                            Text("\(amountFormatter(amount: item.amount, locale: myLocale))")
                        }
                        .font(myFont)
                    }
                }
                Section(header: Text("Count")) {
                    HStack{
                        Text("Count:")
                        Spacer()
                        Text("\(myPeriodicTaxesDue.items.count)")
                    }
                    .font(myFont)
                }
               
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if myPeriodicTaxesDue.items.count > 0 {
                myPeriodicTaxesDue.items.removeAll()
            }

            myPeriodicTaxesDue.createNetTaxesDue(aInvestment: myInvestment)
        }
    }
    
    private func myViewAsPct() {
        
    }
}

#Preview {
    YTDTaxesDueView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
