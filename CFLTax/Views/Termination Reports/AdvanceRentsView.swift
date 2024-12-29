//
//  AdvanceRentsView.swift
//  CFLTax
//
//  Created by Steven Williams on 9/20/24.
//

import SwiftUI

struct AdvanceRentsView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var myPeriodicAdvanceRents: PeriodicAdvanceRents = PeriodicAdvanceRents()
    @State var viewAsPct: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(headerType: .report, name: "Advance Rents", viewAsPct: myViewAsPct, goBack: myGoBack, withBackButton: true, withPctButton: true, path: $path, isDark: $isDark)
            Form {
                Section(header: Text("\(currentFile)")) {
                    ForEach(myPeriodicAdvanceRents.items) { item in
                        HStack {
                            Text("\(item.dueDate.toStringDateShort())")
                            Spacer()
                            Text("\(getFormattedValue(amount: item.amount, viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment))")
                        }
                        .font(myFont)
                    }
                }
                Section(header: Text("Totals")) {
                    HStack{
                        Text("Count:")
                        Spacer()
                        Text("\(myPeriodicAdvanceRents.items.count)")
                    }
                    .font(myFont)
                }
               
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if myPeriodicAdvanceRents.items.count > 0 {
                myPeriodicAdvanceRents.items.removeAll()
            }
            myPeriodicAdvanceRents.createTable(aInvestment: myInvestment)
        }
    }
    
    func myViewAsPct() {
        self.viewAsPct.toggle()
    }
    
    private func myGoBack() {
        self.path.removeLast()
    }
    
}

#Preview {
    AdvanceRentsView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
