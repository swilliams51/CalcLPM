//
//  RentSummaryView.swift
//  CFLTax
//
//  Created by Steven Williams on 10/10/24.
//

import SwiftUI

struct RentSummaryView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State private var viewAsPctOfCost: Bool = false
    @State var implicitRate: String = "0.00"
    @State var presentValue1: String = "0.00"
    @State var presentValue2: String = "0.00"
    @State var discountRate: String = "0.00"
    
    @State var lineHeight: CGFloat = 12
    @State var frameHeight: CGFloat = 12
    
    var body: some View {
        Form {
            implicitRateItem
            presentValueItem
            presentValue2Item
        }
    }
}

#Preview {
    RentSummaryView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}

extension RentSummaryView {
    var implicitRateItem: some View {
        HStack{
            Text("Implicit Rate:")
                .font(myFont)
            Spacer()
            Text("\(percentFormatter(percent: implicitRate, locale: myLocale, places: 3))")
                .font(myFont)
        }.frame(height: frameHeight)
    }
    
    var presentValueItem: some View {
            HStack{
                Text("PV1 @ \(getDiscountRateText()):")
                    .font(myFont)
                Spacer()
                Text("\(getFormattedValue(amount: presentValue1, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
                    .font(myFont)
            }.frame(height: frameHeight)
    }
    
    var presentValue2Item: some View {
        HStack{
            Text("PV2 @ \(getDiscountRateText()):")
                .font(myFont)
            Spacer()
            Text("\(getFormattedValue(amount: presentValue2, viewAsPercentOfCost: viewAsPctOfCost, aInvestment: myInvestment))")
                .font(myFont)
        }.frame(height: frameHeight)
    }
    
    func getDiscountRateText() -> String {
        let strDiscountRate: String = percentFormatter(percent: discountRate, locale: myLocale, places: 3)
        return strDiscountRate
    }
}
