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
                    calculatedItem
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
                .font(myFont2)
                .onTapGesture {
                    path.append(1)
                }
            Spacer()
            Image(systemName: "chevron.right")
                .onTapGesture {
                    path.append(1)
                }
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
                .onTapGesture {
                    path.append(2)
                }
            Spacer()
            Image(systemName: "chevron.right")
                .onTapGesture {
                    path.append(2)
                }
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
                .onTapGesture {
                    path.append(3)
                }
            Spacer()
            Image(systemName: "chevron.right")
                .onTapGesture {
                    path.append(3)
                }
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
                .onTapGesture {
                    path.append(4)
                }
            Spacer()
            Image(systemName: "chevron.right")
                .onTapGesture {
                    path.append(4)
                }
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
                .onTapGesture {
                    path.append(5)
                }
            Spacer()
            Image(systemName: "chevron.right")
                .onTapGesture {
                    path.append(5)
                }
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
                .onTapGesture {
                    path.append(6)
                }
            Spacer()
            Image(systemName: "chevron.right")
                .onTapGesture {
                    path.append(6)
                }
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
                .onTapGesture {
                    path.append(7)
                }
            Spacer()
            Image(systemName: "chevron.right")
                .onTapGesture {
                    path.append(7)
                }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(7)
        }
    }
    
    var calculatedItem: some View {
        HStack{
            Text("Net After Tax Cashflows")
                .font(myFont2)
                .onTapGesture {
                    path.append(8)
                }
            Spacer()
            Image(systemName: "chevron.right")
                .onTapGesture {
                    path.append(8)
                }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            
        }
    }
}


#Preview {
    HomeView(myInvestment: Investment())
}
