//
//  ArrearsRentsView.swift
//  CFLTax
//
//  Created by Steven Williams on 10/6/24.
//

import SwiftUI

struct ArrearsRentsView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var myPeriodicArrearsRents: PeriodicArrearsRents = PeriodicArrearsRents()
    @State var viewAsPct: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(headerType: .report, name: "Arrears Rents", viewAsPct: myViewAsPct, goBack: myGoBack, withBackButton: true, withPctButton: true, path: $path, isDark: $isDark)
            Form {
                Section(header: Text("\(currentFile)")) {
                    ForEach(myPeriodicArrearsRents.items) { item in
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
                        Text("\(myPeriodicArrearsRents.items.count)")
                    }
                    .font(myFont)
                }
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if myPeriodicArrearsRents.items.count > 0 {
                myPeriodicArrearsRents.items.removeAll()
            }
            myPeriodicArrearsRents.createTable(aInvestment: myInvestment)
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
    ArrearsRentsView(myInvestment: Investment(), path: .constant(([Int]())), isDark: .constant(false), currentFile: .constant("File is New"))
}
