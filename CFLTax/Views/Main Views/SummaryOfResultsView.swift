//
//  SummaryOfResultsView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/20/24.
//

import SwiftUI

struct SummaryOfResultsView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    
    @State var myATYield: Decimal = 0.075
    @State var myBTYield: Decimal = 0.075
    @State var myIRRPTCF: Decimal = 0.075
    
    var body: some View {
        Form {
            Section(header: Text("Profitablity")) {
                afterTaxYieldItem
                beforeTaxYieldItem
                preTaxIRRItem
            }
            Section(header: Text("Cashflow")) {
                HStack{
                    
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationTitle("Summary")
        .navigationBarBackButtonHidden(true)
        .onAppear{
            myInvestment.calculate()
            myATYield = myInvestment.getMISF_AT_Yield()
            myBTYield = myInvestment.getMISF_BT_Yield()
            myIRRPTCF = myInvestment.getIRR_PTCF()
        }
        
    }

    var afterTaxYieldItem: some View {
        HStack{
            Text("A/T MISF:")
            Spacer()
            Text("\(percentFormatter(percent: myATYield.toString(decPlaces: 5), locale: myLocale, places:3))")
        }
    }
    
    var beforeTaxYieldItem: some View {
        HStack{
            Text("B/T MISF:")
            Spacer()
            Text("\(percentFormatter(percent:myBTYield.toString(decPlaces: 5), locale: myLocale, places: 3))")
        }
    }
    
    var preTaxIRRItem: some View {
        HStack{
            Text("IRR PTCF:")
            Spacer()
            Text("\(percentFormatter(percent:myIRRPTCF.toString(decPlaces: 5), locale: myLocale, places: 3))")
        }
    }
    
}

#Preview {
    SummaryOfResultsView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false))
}
