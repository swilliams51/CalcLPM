//
//  TerminationViewsManager.swift
//  CFLTax
//
//  Created by Steven Williams on 9/18/24.
//

import SwiftUI

struct TerminationViewsManager: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    
    var body: some View {
        VStack {
            CustomHeaderView(name: "Reports", isReport: false, path: $path, isDark: $isDark)
            Form{
                Section(header: Text("Reports"), footer: (Text("FileName: \(currentFile)"))) {
                    investmentBalanceItem
                    depreciationBalancesItem
                    yearToDateIncomeItem
                    yearToDateTaxesPaidItem
                    yearToDateTaxesDueItem
                    advanceRentsItem
                    arrearsRentsItem
                    terminationValuesItem
                    terminationValuesProofItem
                }
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
    }
    var investmentBalanceItem: some View {
        HStack {
            Text("Investment Balances")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(37)
        }
    }
    
    var depreciationBalancesItem: some View {
        HStack {
            Text("Depreciation Balances")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(38)
        }
    }
    
    var yearToDateIncomeItem: some View {
        HStack {
            Text("YTD Income")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(39)
        }
    }
    
    var yearToDateTaxesPaidItem: some View {
        HStack {
            Text("YTD Taxes Paid")
            Spacer()
            Image(systemName: "chevron.right")
                
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(40)
        }
    }
    
    var yearToDateTaxesDueItem: some View {
        HStack {
            Text("YTD Taxes Due")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(43)
        }
    }
    
    var advanceRentsItem: some View {
        HStack{
        Text("Advance Rents")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(41)
        }
    }
    
    var arrearsRentsItem: some View {
        HStack{
        Text("Arrears Rents")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(45)
        }
    }
    
    var terminationValuesItem: some View {
        HStack{
        Text("Termination Values")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(42)
        }
    }
    
    var terminationValuesProofItem: some View {
        HStack{
            Text("Termination Values Proof")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(44)
        }
    }
    
}

#Preview {
    TerminationViewsManager(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
