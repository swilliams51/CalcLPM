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
    @State var index: Int = 0
    @State var myDepreciationSchedule: DepreciationIncomes = DepreciationIncomes()
    @State var myRentalSchedule: RentalCashflows = RentalCashflows()
    @State var myTaxableIncomes: AnnualTaxableIncomes = AnnualTaxableIncomes()
    
    @State private var myFeeAmortization: FeeIncomes = FeeIncomes()
    @State private var isShowingYieldErrorAlert: Bool = false
    @State private var currentFile: String = "File is New"
    @State private var maximumEBOAmount: Decimal = 0.0
    @State private var minimumEBOAmount: Decimal = 0.0
    @State private var showPop1: Bool = false
    @State private var showPop2: Bool = false
    @State private var feeHelp = feeHomeHelp
    @State private var eboHelp = eboHomeHelp
    

    var body: some View {
        NavigationStack (path: $path){
            Form {
                Section(header: Text("Parameters"), footer: (Text("File Name: \(currentFile)"))) {
                    assetItem
                    LeaseTermItem
                    rentItem
                    depreciationItem
                    taxAssumptionsItem
                    if self.myInvestment.feeExists {
                        feeItem
                    }
                    if self.myInvestment.earlyBuyoutExists {
                        eboItem
                    }
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
                ViewsManager(myInvestment: myInvestment, myDepreciationSchedule: myDepreciationSchedule, myRentalSchedule: myRentalSchedule, myTaxableIncomes: myTaxableIncomes, myFeeAmortization: myFeeAmortization, path: $path, isDark: $isDark, selectedGroup: $selectedGroup, currentFile: $currentFile, minimumEBOAmount: $minimumEBOAmount, maximumEBOAmount: $maximumEBOAmount, selectedView: selectedView)
            }
            .toolbar{
                ToolbarItem(placement: .bottomBar) {
                    Menu(content: {
                        removeItemsMenu
                    }, label: {
                        Image(systemName: "minus.circle")
                            .foregroundColor(ColorTheme().accent)
                            .imageScale(.large)
                    })
                }
               
                ToolbarItem(placement: .bottomBar) {
                    Menu(content: {
                        addItemsMenu
                    }, label: {
                        Image(systemName: "plus.circle")
                            .foregroundColor(ColorTheme().accent)
                            .imageScale(.large)
                    })
                }
            }
            .onAppear{
                if self.myInvestment.hasChanged && myInvestment.earlyBuyoutExists == true {
                    self.myInvestment.earlyBuyout.amount = "0.00"
                    self.myInvestment.earlyBuyoutExists = false
                }
            }
            .popover(isPresented: $showPop1) {
                PopoverView(myHelp: $feeHelp, isDark: $isDark)
            }
            .popover(isPresented: $showPop2) {
                PopoverView(myHelp: $eboHelp, isDark: $isDark)
            }
            .alert(isPresented: $isShowingYieldErrorAlert) {
                Alert(title: Text("Yield Calculation Error"), message: Text(alertYieldCalculationError), dismissButton: .default(Text("OK")))
            }
            
        }
    }
    
    var assetItem: some View {
        HStack {
            Text("Asset")
                .font(myFont)
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
                .font(myFont)
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
                .font(myFont)

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
                .font(myFont)
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
                .font(myFont)
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
                .font(myFont)
            Image(systemName: "questionmark.circle")
                .font(myFont)
                .foregroundColor(.blue)
                .onTapGesture {
                    self.showPop1 = true
                }
            Spacer()
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(6)
        }
    }
    
    var eboItem: some View {
        HStack{
            Text("Early Buyout")
                .font(myFont)
            Image(systemName: "questionmark.circle")
                .font(myFont)
                .foregroundColor(.blue)
                .onTapGesture {
                    self.showPop2 = true
                }
            Spacer()
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(8)
        }
    }
    
    var economicsItem: some View {
        HStack{
            Text("Economics")
                .font(myFont)
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
                .font(myFont)
            Spacer()
            Image(systemName: "return")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if myInvestment.isSolveForValid() {
                self.path.append(25)
            } else {
                self.isShowingYieldErrorAlert = true
            }
        }
    }
    
    var subMenuItem: some View {
        HStack{
            Text("File Menu")
                .font(myFont)
                .foregroundColor(myInvestment.hasChanged ? .gray : .black)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(myInvestment.hasChanged ? .gray : .black)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(26)
        }
        .disabled(myInvestment.hasChanged ? true : false)
    }
    
}


#Preview {
    HomeView(myInvestment: Investment())
}




extension HomeView {
    var removeItemsMenu: some View {
        VStack {
            if myInvestment.feeExists {
                removeFeeItem
            }
            
            if myInvestment.earlyBuyoutExists {
                removeEBOItem
            }
        }
       
    }
    
    var removeFeeItem: some View {
        Button(action: {
            self.myInvestment.fee.amount = "0.00"
            self.myInvestment.feeExists = false
        }) {
            Label("Remove Fee", systemImage: "folder.badge.minus")
                .font(myFont)
        }
    }
    
    var removeEBOItem: some View {
        Button(action: {
            self.myInvestment.earlyBuyout.amount = "0.00"
            self.myInvestment.earlyBuyoutExists = false
        }) {
            Label("Remove Early Buyout", systemImage: "folder.badge.minus")
                .font(myFont)
        }
    }
    
    var addItemsMenu: some View {
        VStack{
            if myInvestment.feeExists == false {
                addFeeItem
            }
            if myInvestment.earlyBuyoutExists == false {
                addEBOItem
            }
        }
    }
    
    var addFeeItem: some View {
        Button(action: {
            self.myInvestment.setFeeToDefault()
            self.myInvestment.feeExists = true
        }) {
            Label("Add Fee", systemImage: "folder.badge.plus")
                .font(myFont)
        }
    }
    
    var addEBOItem: some View {
        Button(action: {
            self.myInvestment.setEBOToDefault()
            self.myInvestment.earlyBuyoutExists = true
        }) {
            Label("Add EBO", systemImage: "folder.badge.plus")
        }
    }
    
    
}
