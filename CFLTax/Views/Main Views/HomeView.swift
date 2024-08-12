//
//  ContentView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import SwiftUI

struct HomeView: View {
    @State public var myInvestment: Investment = Investment()
    @State public var path: [Int] = [Int]()
    @State public var isDark: Bool = false
    @State var selectedGroup: Group = Group()
    @State var  index: Int = 0
    
//    @State public var myNetAfterTaxCFs: NetAfterTaxCashflows = NetAfterTaxCashflows()
//    @State public var myATCashflows: Cashflows = Cashflows()
    
    
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
                    Text("Net After Tax Cashflows")
                        .onTapGesture {
                            path.append(8)
                        }
                }
            }
            .navigationBarTitle("Home")
            .navigationDestination(for: Int.self) { selectedView in
                ViewsManager(myInvestment: myInvestment, path: $path, isDark: $isDark, selectedGroup: $selectedGroup, index: $index, selectedView: selectedView)
            }
            
        }
    }
    
    var assetItem: some View {
        HStack {
            Text("Asset")
                .onTapGesture {
                    path.append(1)
                }
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
    
    var LeaseTermItem: some View {
        HStack {
            Text("Lease Term")
                .onTapGesture {
                    path.append(2)
                }
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
    
    var rentItem: some View {
        HStack {
            Text("Rent")
                .onTapGesture {
                path.append(3)
                }
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
    
    var depreciationItem: some View {
        HStack {
            Text("Depreciation")
                .onTapGesture {
                    path.append(4)
                }
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
    
    var taxAssumptionsItem: some View {
        HStack{
            Text("Tax Assumptions")
                .onTapGesture {
                    path.append(5)
                }
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
    
    var feeItem: some View {
        HStack{
            Text("Fee")
                .onTapGesture {
                    path.append(6)
                }
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
    
    var economicsItem: some View {
        HStack{
            Text("Economics")
                .onTapGesture {
                    path.append(7)
                }
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
    
}

#Preview {
    HomeView(myInvestment: Investment())
}
