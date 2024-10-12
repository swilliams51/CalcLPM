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
    @Binding var currentFile: String
    
    @State var viewAsPctOfCost: Bool = false
    
    //Yields
    @State var myATYield: Decimal = 0.075
    @State var myBTYield: Decimal = 0.075
    @State var myIRRPTCF: Decimal = 0.075
    
    @State var lineHeight: CGFloat = 12
    @State var frameHeight: CGFloat = 12
    
    var body: some View {
        Form {
            Section(header: Text("Yields"), footer: (Text("File Name: \(currentFile)"))) {
                afterTaxYieldItem
                beforeTaxYieldItem
                preTaxIRRItem
                Text("Inherent Profit:")
                Text("Payback (months):")
                Text("Average Life (yrs):")
            }
            Section(header: Text("Additional Results")) {
                cashflowItem
                rentalsItem
                earlyBuyoutItem
            }
            
          
            
        }
        .environment(\.defaultMinListRowHeight, lineHeight)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
            ToolbarItem(placement: .topBarTrailing){
                Button(action: {
                    viewAsPctOfCost.toggle()
                }) {
                    Image(systemName: "command.circle")
                        .tint(viewAsPctOfCost ? Color.red : Color.black)
                }
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationTitle("Summary")
        .navigationBarBackButtonHidden(true)
        .onAppear{
            myInvestment.calculate()
            myInvestment.hasChanged = false
            myATYield = myInvestment.getMISF_AT_Yield()
            myBTYield = myInvestment.getMISF_BT_Yield()
            myIRRPTCF = myInvestment.getIRR_PTCF()
        }
    }
    
}

#Preview {
    SummaryOfResultsView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}

// Yields
extension SummaryOfResultsView {
    var afterTaxYieldItem: some View {
        HStack{
            Text("After-Tax MISF:")
                .font(myFont)
            Spacer()
            Text("\(percentFormatter(percent: myATYield.toString(decPlaces: 5), locale: myLocale, places:3))")
                .font(myFont)
        }.frame(height: frameHeight)
    }
    
    var beforeTaxYieldItem: some View {
        HStack{
            Text("Before-Tax MISF:")
                .font(myFont)
            Spacer()
            Text("\(percentFormatter(percent:myBTYield.toString(decPlaces: 5), locale: myLocale, places: 3))")
                .font(myFont)
        }.frame(height: frameHeight)
    }
    
    
    var preTaxIRRItem: some View {
        HStack{
            Text("IRR PTCF:")
                .font(myFont)
            Spacer()
            Text("\(percentFormatter(percent:myIRRPTCF.toString(decPlaces: 5), locale: myLocale, places: 3))")
                .font(myFont)
        }.frame(height: frameHeight)
    }
}

extension SummaryOfResultsView {
    var cashflowItem: some View {
        HStack {
            Text("Cashflows")
                .font(myFont2)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(36)
        }
    }
    
    var rentalsItem: some View {
        HStack {
            Text("Rentals")
                .font(myFont2)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(31)
        }
    }
    
    var earlyBuyoutItem: some View {
        HStack {
            Text("Early Buyout")
                .font(myFont2)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(32)
        }
    }
}
