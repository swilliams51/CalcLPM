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
    @State var myFeeAmortization: FeeIncomes = FeeIncomes()
    @State var isShowingYieldErrorAlert: Bool = false
    @State var currentFile: String = "File is New"
    @State var maximumEBOAmount: Decimal = 0.0
    @State var minimumEBOAmount: Decimal = 0.0

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
            self.path.append(25)
            
        }
        .alert(isPresented: $isShowingYieldErrorAlert) {
            Alert(title: Text("Yield Calculation Error"), message: Text(yieldCalcMessage), dismissButton: .default(Text("OK")))
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


let yieldCalcMessage = "The current inputs will produce a negative yield. Consequently, the yield calculation is terminated. The sum of the Rents and the Residual Value must be greater than the Lessor Cost."

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
            Label("Remove Fee", systemImage: "arrowshape.turn.up.backward")
                .font(myFont)
        }
    }
    
    var removeEBOItem: some View {
        Button(action: {
            self.myInvestment.earlyBuyout.amount = "0.00"
            self.myInvestment.earlyBuyoutExists = false
        }) {
            Label("Remove Early Buyout", systemImage: "arrowshape.turn.up.backward")
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
            Label("Add Fee", systemImage: "arrowshape.turn.up.backward")
                .font(myFont)
        }
    }
    
    var addEBOItem: some View {
        Button(action: {
            self.myInvestment.setEBOToDefault()
            self.myInvestment.earlyBuyoutExists = true
        }) {
            Label("Add EBO", systemImage: "arrowshape.turn.up.backward")
        }
    }
    
    
}
