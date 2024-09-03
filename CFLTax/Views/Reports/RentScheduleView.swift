//
//  RentScheduleView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/23/24.
//

import SwiftUI

struct RentScheduleView: View {
    @Bindable var myInvestment: Investment
    @Bindable var myRentalSchedule: RentalCashflows
    @Binding var path: [Int]
    @Binding var isDark: Bool
    
    var body: some View {
        Form {
            Section(header: Text("Rent Schedule")) {
                ForEach(myRentalSchedule.items) { item in
                    HStack {
                        Text("\(item.dueDate.toStringDateShort(yrDigits: 2))")
                        Spacer()
                        Text("\(amountFormatter(amount: item.amount, locale: myLocale))")
                    }
                }
            }
            
            Section(header: Text("Totals")) {
                HStack {
                    Text("\(myRentalSchedule.items.count)")
                    Spacer()
                    Text("\(amountFormatter(amount: myRentalSchedule.getTotal().toString(decPlaces: 4), locale: myLocale))")
                }
            }
           
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationTitle("Rent Schedule")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if myRentalSchedule.items.count > 0 {
                myRentalSchedule.items.removeAll()
            }
            myRentalSchedule.createTable(aRent: myInvestment.rent, aLeaseTerm: myInvestment.leaseTerm, aAsset: myInvestment.asset, eomRule: false)
        }
    }
}

#Preview {
    RentScheduleView(myInvestment: Investment(), myRentalSchedule: RentalCashflows(), path: .constant([Int]()), isDark: .constant(false))
}
