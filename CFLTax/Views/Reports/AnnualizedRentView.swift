//
//  AnnualizedRentView.swift
//  CFLTax
//
//  Created by Steven Williams on 1/3/25.
//

import SwiftUI

struct AnnualizedRentView: View {
    @Bindable var myInvestment: Investment
    @Bindable var myAnnualizedRent: AnnualizedRentalCashflows
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var viewAsPct: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(headerType: .report, name: "Uneven Rent Test", viewAsPct: myViewAsPct, goBack: myGoBack, withBackButton: true, withPctButton: true, path: $path, isDark: $isDark)
            Form {
                Section(header: Text("Annualized Rent")) {
                    HStack {
                        Text("Average Annual Rent:")
                        Spacer()
                        Text("\(getFormattedValue(amount: myAnnualizedRent.averageAnnualizedRent.toString(decPlaces: 4), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment))")
                    }.font(myFont)
                    
                    HStack {
                        Text("90% of Annual Rent:")
                        Spacer()
                        Text("\(getFormattedValue(amount: myAnnualizedRent.minAnnualizedRent.toString(decPlaces: 4), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment))")
                    }.font(myFont)
                    
                    HStack {
                        Text("110% of Annual Rent:")
                        Spacer()
                        Text("\(getFormattedValue(amount: myAnnualizedRent.maxAnnualizedRent.toString(decPlaces: 4), viewAsPercentOfCost: viewAsPct, aInvestment: myInvestment))")
                    }.font(myFont)
                    
                }
                Section(header: Text("\(currentFile)")) {
                    ForEach(myAnnualizedRent.items) { item in
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
                        Text("Guideline Passed:")
                        Spacer()
                        Text("\(myAnnualizedRent.runUnevenRentTest())")
                    }.font(myFont)
                }
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if myAnnualizedRent.items.count > 0 {
                myAnnualizedRent.items.removeAll()
            }
            myAnnualizedRent.createTable(aInvestment: myInvestment)
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
    AnnualizedRentView(myInvestment: Investment(), myAnnualizedRent: AnnualizedRentalCashflows(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
