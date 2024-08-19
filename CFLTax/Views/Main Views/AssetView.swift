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
                assetNameItem
                lessorCostItem
                fundingDateItem
                residualValueItem
                lesseeGuarantyItem
            }
            Section(header: Text("Submit Form")) {
                SubmitFormButtonsView(cancelName: "Cancel", doneName: "Done", cancel: myCancel, done: myDone, isDark: $isDark)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarTitle("Asset")
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.assetName = self.myInvestment.asset.name
            self.fundingDate = self.myInvestment.asset.fundingDate
            self.lessorCost = self.myInvestment.asset.lessorCost
            self.residualValue = self.myInvestment.asset.residualValue
            self.lesseeGuaranty = self.myInvestment.asset.lesseeGuarantyAmount
        }
    }
    
    var assetNameItem: some View{
        HStack {
            Text("Name:")
                .font(myFont2)
            Spacer()
            Text("\(assetName)")
                .font(myFont2)
                .onTapGesture {
                    //self.component = [0,0]
                    path.append(12)
                }
        }
    }
    
    var fundingDateItem: some View{
        HStack {
            Text("Funding Date:")
                .font(myFont2)
            Spacer()
            DatePicker("", selection: $fundingDate, displayedComponents: [.date])
                .transformEffect(.init(scaleX: 1.0, y: 0.9))
                .environment(\.locale, myLocale)
                .onChange(of: fundingDate) { oldValue, newValue in
                    self.myInvestment.resetForFundingDateChange()
                }
        }
    }
    
    var lessorCostItem: some View{
        HStack {
            Text("Lessor Cost:")
                .font(myFont2)
            Spacer()
            Text("\(amountFormatter(amount: lessorCost, locale: myLocale))")
                .font(myFont2)
                .onTapGesture {
                    //self.component = [0,0]
                    path.append(9)
                }
        }
    }
    
    var residualValueItem: some View{
        HStack {
            Text("Residual:")
                .font(myFont2)
            Spacer()
            Text("\(amountFormatter(amount:residualValue, locale: myLocale))")
                .font(myFont2)
                .onTapGesture {
                    path.append(10)
                }
        }
    }
    
    var lesseeGuarantyItem: some View{
        HStack {
            Text("Lessee Guaranty:")
                .font(myFont2)
            Spacer()
            Text("\(amountFormatter(amount:lesseeGuaranty, locale: myLocale))")
                .font(myFont2)
                .onTapGesture {
                    path.append(11)
                }
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
        self.myInvestment.resetForFundingDateChange()
        path.removeLast()
    }
    
}

#Preview {
    AssetView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false))
}
