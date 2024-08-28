//
//  ContentView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import SwiftUI

struct HomeView: View {
    @State public var myInvestment: Investment = Investment(aFile: sampleFile)
    @State public var path: [Int] = [Int]()
    @State public var isDark: Bool = false
    @State var selectedGroup: Group = Group()
    @State var  index: Int = 0
    @State var myDepreciationSchedule: DepreciationIncomes = DepreciationIncomes()
    @State var myRentalSchedule: RentalCashflows = RentalCashflows()

    
    var body: some View {
        NavigationStack (path: $path){
            Form {
                Section(header: Text("Parameters")) {
                    assetItem
                    LeaseTermItem
                    rentItem
                    depreciationItem
                    taxAssumptionsItem
                    feeItem
                    economicsItem
                }
                Section(header: Text("Results")) {
                    calculatedItem
                    subMenuItem
                }
            }
            .environment(\.colorScheme, isDark ? .dark : .light)
            .navigationBarTitle("Home")
            .navigationDestination(for: Int.self) { selectedView in
                ViewsManager(myInvestment: myInvestment, myDepreciationSchedule: myDepreciationSchedule, myRentalSchedule: myRentalSchedule, path: $path, isDark: $isDark, selectedGroup: $selectedGroup, selectedView: selectedView)
            }
        }
    }
    
        
    var assetItem: some View {
        HStack {
            Text("Asset")
                .font(myFont2)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(1)
        }
    }
    
    var LeaseTermItem: some View {
        HStack {
            Text("Lease Term")
                .font(myFont2)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(2)
        }
    }
    
    var rentItem: some View {
        HStack {
            Text("Rent")
                .font(myFont2)

            Spacer()
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(3)
        }
    }
    
    var depreciationItem: some View {
        HStack {
            Text("Depreciation")
                .font(myFont2)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(4)
        }
    }
    
    var taxAssumptionsItem: some View {
        HStack{
            Text("Tax Assumptions")
                .font(myFont2)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(5)
        }
    }
    
    var feeItem: some View {
        HStack{
            Text("Fee")
                .font(myFont2)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(6)
        }
    }
    
    var economicsItem: some View {
        HStack{
            Text("Economics")
                .font(myFont2)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(7)
        }
    }
    
    var calculatedItem: some View {
        HStack{
            Text("Calculate")
                .font(myFont2)
            Spacer()
            Image(systemName: "return")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(25)
        }
    }
    
    var subMenuItem: some View {
        HStack{
            Text("File Menu")
                .font(myFont2)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(26)
        }
    }
    
}


#Preview {
    HomeView(myInvestment: Investment())
}

