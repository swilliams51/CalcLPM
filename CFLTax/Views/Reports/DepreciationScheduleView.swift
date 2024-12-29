//
//  DepreciationScheduleView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/21/24.
//

import SwiftUI

struct DepreciationScheduleView: View {
    @Bindable var myInvestment: Investment
    @Bindable var myDepreciationSchedule: DepreciationIncomes
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var viewAsPct: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(headerType: .report, name: "Depreciation Schedule", viewAsPct: myViewAsPct, goBack: myGoBack, withBackButton: true, withPctButton: true, path: $path, isDark: $isDark)
            Form {
                Section(header: Text("\(currentFile)")) {
                    ForEach(myDepreciationSchedule.items) { item in
                        HStack {
                            Text("\(item.dueDate.toStringDateShort())")
                            Spacer()
                            Text("\(getFormattedValue(amount: item.amount, viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment))")
                        }
                        .font(myFont)
                    }
                }
                
                Section(header: Text("Totals")) {
                    HStack {
                        Text("\(myDepreciationSchedule.items.count)")
                        Spacer()
                        Text("\(getFormattedValue(amount: myDepreciationSchedule.getTotal().toString(decPlaces: 4), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment))")
                    }
                    .font(myFont)
                }
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if myDepreciationSchedule.items.count > 0 {
                myDepreciationSchedule.items.removeAll()
            }
            myDepreciationSchedule.createTable(aInvestment: myInvestment)
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
    DepreciationScheduleView(myInvestment: Investment(), myDepreciationSchedule: DepreciationIncomes(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
