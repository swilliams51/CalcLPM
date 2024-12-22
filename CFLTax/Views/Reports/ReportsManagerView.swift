//
//  ReportsManagerView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/20/24.
//

import SwiftUI

struct ReportsManagerView: View {
    @Bindable var myInvestment: Investment
    @Bindable var myDepreciationSchedule: DepreciationIncomes
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                MenuHeaderView(name: "Reports", path: $path, isDark: $isDark)
                Form{
                    Section(header: Text("Reports"), footer: (Text("File Name: \(currentFile)").font(myFont))) {
                        leaseRentalsItem
                        depreciationScheduleItem
                        feeAmortizationItem
                        taxableIncomeItem
                        taxesPaidItem
                        beforeTaxLeaseCashflowsItem
                        afterTaxLeaseCashflowsItem
                        investmentAmortizationItem
                    }
                    
                }
            }
            if self.isLoading {
                ProgressView()
                    .scaleEffect(3.0)
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear{
            self.isLoading = false
        }
    }
    
    var leaseRentalsItem: some View {
        HStack {
            Text("Schedule of Rents")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(21)
        }
    }
    
    var depreciationScheduleItem: some View {
        HStack {
            Text("Depreciation Schedule")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(22)
        }
    }
    
    var feeAmortizationItem: some View {
        HStack {
            Text("Fee Amortization")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(28)
        }
    }
    
    var taxableIncomeItem: some View {
        HStack {
            Text("Taxable Income")
            Spacer()
            Image(systemName: "chevron.right")
                
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(33)
        }
    }
    
    var taxesPaidItem: some View {
        HStack{
        Text("Taxes Paid")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(34)
        }
    }
    
    var beforeTaxLeaseCashflowsItem: some View {
        HStack {
            Text("Before-Tax Lease Cashflows")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(23)
        }
    }
    
    var afterTaxLeaseCashflowsItem: some View {
        HStack {
            Text("After-Tax Lease Cashflows")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            self.isLoading = true
                Task{
                    await navigate(nextView: 25)
                }
            }
    }
    
    var investmentAmortizationItem: some View {
        HStack {
            Text("Investment Amortization")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            self.isLoading = true
                Task{
                    await navigate(nextView: 35)
                }
            }
        }
    
    private func navigate(nextView: Int) async {
        self.path.append(nextView)
    }

}

#Preview {
    ReportsManagerView(myInvestment: Investment(), myDepreciationSchedule: DepreciationIncomes(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}
