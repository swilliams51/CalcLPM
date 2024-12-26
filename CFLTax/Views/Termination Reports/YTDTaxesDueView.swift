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
    @State var viewAsPct: Bool = false
  
    var body: some View {
        VStack (spacing: 0){
            HeaderView(headerType: .report, name: "YTD Taxes Due", viewAsPct: myViewAsPct, goBack: myGoBack, withBackButton: true, withPctButton: true, path: $path, isDark: $isDark)
            Form {
                Section(header: Text("\(currentFile)")) {
                    ForEach(myPeriodicTaxesDue.items) { item in
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
        self.viewAsPct.toggle()
    }
    
    private func myGoBack() {
        self.path.removeLast()
    }
    
}

#Preview {
    YTDTaxesDueView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
