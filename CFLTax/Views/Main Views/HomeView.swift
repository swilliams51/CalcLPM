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
    
//    @State public var myNetAfterTaxCFs: NetAfterTaxCashflows = NetAfterTaxCashflows()
//    @State public var myATCashflows: Cashflows = Cashflows()
    
    
    var body: some View {
        NavigationStack (path: $path){
            Form {
                Section(header: Text("Parameters")) {
                    Text("Asset")
                        .onTapGesture {
                            path.append(1)
                        }
                    Text("Lease Term")
                        .onTapGesture {
                            path.append(2)
                        }
                    Text("Rent")
                        .onTapGesture {
                            path.append(3)
                        }
                    Text("Depreciation")
                        .onTapGesture {
                            path.append(4)
                        }
                    Text("Tax Assumptions")
                        .onTapGesture {
                            path.append(5)
                        }
                    Text("Fee")
                        .onTapGesture {
                            path.append(6)
                        }
                    Text("Economics")
                        .onTapGesture {
                            path.append(7)
                        }
                    
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
                ViewsManager(myInvestment: myInvestment, path: $path, isDark: $isDark, selectedGroup: $selectedGroup, selectedView: selectedView)
            }
            
        }
    }
}

#Preview {
    HomeView(myInvestment: Investment())
}
