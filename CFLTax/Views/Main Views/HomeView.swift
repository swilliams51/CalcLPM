//
//  ContentView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import SwiftUI

struct HomeView: View {
    @State public var myInvestment: Investment = Investment(aFile: sampleFile, resetDates: true)
    @State public var path: [Int] = [Int]()
    @State public var isDark: Bool = false
    @State var selectedGroup: Group = Group()
    @State var index: Int = 0
    @State var myDepreciationSchedule: DepreciationIncomes = DepreciationIncomes()
    @State var myRentalSchedule: RentalCashflows = RentalCashflows()
    @State var myTaxableIncomes: AnnualTaxableIncomes = AnnualTaxableIncomes()
    @State var isLoading: Bool = false
    @State private var myFeeAmortization: FeeIncomes = FeeIncomes()
    @State private var isShowingCalculationErrorAlert: Bool = false
    @State private var currentFile: String = "File is New"
    @State private var maximumEBOAmount: Decimal = 0.0
    @State private var minimumEBOAmount: Decimal = 0.0
    @State private var showPop1: Bool = false
    @State private var showPop2: Bool = false
    @State private var feeHelp = feeHomeHelp
    @State private var eboHelp = eboHomeHelp
    @AppStorage("darkMode") var darkMode: Bool = false

    var body: some View {
        NavigationStack (path: $path){
            ZStack {
                VStack {
                    HomeHeaderView(isDark: $isDark)
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
                }
                if isLoading {
                    ProgressView()
                        .scaleEffect(3)
                }
            }
            
            
            .environment(\.colorScheme, isDark ? .dark : .light)
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
                self.isLoading = false
                if self.myInvestment.hasChanged && myInvestment.earlyBuyoutExists == true {
                    self.myInvestment.earlyBuyout.amount = "0.00"
                    self.myInvestment.earlyBuyoutExists = false
                }
                if self.darkMode == true {
                    isDark = true
                }
            }
            .popover(isPresented: $showPop1) {
                PopoverView(myHelp: $feeHelp, isDark: $isDark)
            }
            .popover(isPresented: $showPop2) {
                PopoverView(myHelp: $eboHelp, isDark: $isDark)
            }
            .alert(isPresented: $isShowingCalculationErrorAlert) {
                Alert(title: Text("Calculation Error"), message: Text(alertCalculationError), dismissButton: .default(Text("OK")))
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
            Text("Calculate: \(myInvestment.economics.solveFor.toString())")
                .font(myFont)
            Spacer()
            Image(systemName: "return")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            self.isLoading = true
            Task {
                await calculate()
            }
        }
    }
    
    var subMenuItem: some View {
        HStack{
            Text("File Menu")
                .font(myFont)
                .foregroundColor(investmentHasChanged() ? Color("InvestChangedTrue") : Color("InvestChangedFalse"))
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(investmentHasChanged() ? Color("InvestChangedTrue") : Color("InvestChangedFalse"))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(26)
        }
        .disabled(investmentHasChanged() ? true : false)
    }
    
    private func calculate() async {
        if myInvestment.isSolveForValid() {
            myInvestment.hasChanged = false
            if myInvestment.feeExists {
                myInvestment.fee.hasChanged = false
            }
            if myInvestment.earlyBuyoutExists {
                myInvestment.earlyBuyout.hasChanged = false
            }
            self.path.append(25)
        } else {
            self.isShowingCalculationErrorAlert = true
            self.isLoading = false
        }
    }
    
    private func investmentHasChanged() -> Bool {
        if myInvestment.hasChanged {
            return true
        }
        if myInvestment.fee.hasChanged {
            return true
        }
        if myInvestment.earlyBuyout.hasChanged {
            return true
        }
        
        return false
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
