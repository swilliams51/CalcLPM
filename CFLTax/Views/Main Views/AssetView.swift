//
//  AssetView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/9/24.
//

import SwiftUI

struct AssetView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    
    @State var assetName: String = ""
    @State var fundingDate: Date = Date()
    @State var lessorCost: String = "1000.00"
    @State var residualValue: String = "1000.00"
    @State var lesseeGuaranty: String =  "200.00"
    
    
    var body: some View {
        Form {
            Section(header: Text("Details")) {
                HStack {
                    Text("Name:")
                    Spacer()
                    TextField("", text: $assetName)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("funding:")
                    Spacer()
                    DatePicker("", selection: $fundingDate, displayedComponents: [.date])
                        .transformEffect(.init(scaleX: 1.0, y: 0.9))
                        .environment(\.locale, myLocale)
                        .onChange(of: fundingDate) { oldValue, newValue in
//                            if self.selfIsNew == false {
//                                self.myLease.resetForFundingDateChange()
//                                self.endingBalance = myLease.getEndingBalance().toString(decPlaces: 3)
//                                //self.myLease.resetLease()
//                            }
                        }

    
                }
                HStack {
                    HStack{
                        Text("Lessor Cost:")
                            .font(myFont)
                        Spacer()
                        Text("\(amountFormatter(amount: lessorCost, locale: myLocale))")
                            .font(myFont)
                            .onTapGesture {
                                //self.component = [0,0]
                                path.append(9)
                            }
                    }
                }
                HStack {
                    Text("Residual:")
                    Spacer()
                    Text("\(residualValue)")
                }
                HStack {
                    Text("Lessee Guaranty:")
                    Spacer()
                    Text("\(lesseeGuaranty)")
                }
            }
            Section(header: Text("Submit Form")) {
                SubmitFormButtonsView(cancelName: "Cancel", doneName: "Done", cancel: myCancel, done: myDone, isDark: $isDark)
            }
        }
        .navigationBarTitle("Asset")
        .onAppear {
            self.assetName = self.myInvestment.asset.name
            self.fundingDate = self.myInvestment.asset.fundingDate
            self.lessorCost = self.myInvestment.asset.lessorCost
            self.residualValue = self.myInvestment.asset.residualValue
            self.lesseeGuaranty = self.myInvestment.asset.lesseeGuarantyAmount
        }
    }
    
    private func myCancel() {
        path.removeLast()
    }
    
    private func myDone() {
        self.myInvestment.asset.name = assetName
        self.myInvestment.asset.fundingDate = fundingDate
        self.myInvestment.asset.lessorCost = lessorCost
        self.myInvestment.asset.residualValue = residualValue
        self.myInvestment.asset.lesseeGuarantyAmount = lesseeGuaranty
        path.removeLast()
    }
    
}

#Preview {
    AssetView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false))
}
