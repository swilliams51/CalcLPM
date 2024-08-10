//
//  DepreciationView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/9/24.
//

import SwiftUI

struct DepreciationView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
   
    @State var myDepreciation: Depreciation = depreciationEx2
    
    var intLife_MACRS: [Int] = [3, 5, 7, 10, 15, 20]
    var intLife_SL: [Int] = [3,4,5,6,7,8,9,10,11,12,13,14,15]
    var decBonus: [Decimal] = [0.0, 0.5, 1.0]
    
    var body: some View {
        Form {
            Section(header: Text("Inputs")) {
                VStack {
                    depreciationMethod
                    depreciableLife
                    depreciationConvention
                    if myInvestment.depreciation.method == .MACRS {
                        bonusDepreciation
                        investmentTaxCredit
                        basisReduction
                    } else {
                        salvageValue
                    }
                }
            }
            Section(header: Text("Submit Form")) {
                SubmitFormButtonsView(cancelName: "Cancel", doneName: "Done", cancel: myCancel, done: myDone, isDark: $isDark)
            }
        }
        .navigationTitle("Depreciation")
        .onAppear{
            self.myDepreciation = myInvestment.depreciation
           
        }
    }
    var depreciationMethod: some View {
        HStack {
            Text("Method:")
           Picker(selection: $myDepreciation.method, label: Text("")) {
               ForEach(DepreciationType.allTypes, id: \.self) { item in
                   Text(item.toString())

               }
            }
        }
    }

    var depreciableLife: some View {
        HStack {
            Text("Life (in years):")
            Picker(selection: $myDepreciation.life, label: Text("")) {
               ForEach(intLife_MACRS, id: \.self) { item in
                    Text(item.toString())

                }
            }
        }
    }

    var depreciationConvention: some View {
        HStack {
            Text("Convention:")
           Picker(selection: $myDepreciation.convention, label: Text("")) {
                ForEach(ConventionType.allCases, id: \.self) { item in
                   Text(item.toString())

                }
            }
        }
    }

    var bonusDepreciation: some View {
        HStack {
            Text("Bonus:")
           Picker(selection: $myDepreciation.bonusDeprecPercent, label: Text("")) {
                ForEach(decBonus, id: \.self) { item in
                    Text("\(percentFormatter(percent: item.toString(decPlaces: 2), locale: myLocale))")

                }
           }
        }
            .padding(.bottom, 10)
    }


    var investmentTaxCredit: some View {
        HStack {
            Text("ITC:")
            Spacer()
            Text("\(percentFormatter(percent:myDepreciation.investmentTaxCredit.toString(decPlaces: 3), locale: myLocale))")
        }
        .padding(.bottom, 10)
    }

    var basisReduction: some View {
        HStack {
            Text("Basis Reduction:")
            Spacer()
            Text("\(percentFormatter(percent: myDepreciation.basisReduction.toString(decPlaces: 3), locale: myLocale))")
        }
        .padding(.top, 5)
    }

    var salvageValue: some View {
        HStack {
            Text("Salvage Value")
            Spacer()
            Text("\(amountFormatter(amount: myDepreciation.salvageValue, locale: myLocale))")
        }
        .padding(.top,10)
    }
    
    func myCancel() {
        
    }
    
    func myDone() {
        
    }
}

#Preview {
    DepreciationView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false))
}
