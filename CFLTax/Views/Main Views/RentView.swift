//
//  RentView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/10/24.
//

import SwiftUI

struct RentView: View {
    @Bindable var myInvestment: Investment
    @Binding var selectedGroup: Group
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    
    @State var noOfPayments: Int = 0
    @State var totalRent: String = "0.00"
    @State var interimExists: Bool = false
    
    var body: some View {
        VStack {
            MenuHeaderView(name: "Rent", path: $path, isDark: $isDark)
            Form {
                Section(header: Text("Rent").font(myFont), footer: (Text("File Name: \(currentFile)").font(myFont))) {
                    ForEach(myInvestment.rent.groups) { group in
                        groupDisplayRow(group: group)
                    }
                }
                Section(header: Text("Total")){
                    totalsSection
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Menu(content: {
                    structuresMenu
                }, label: {
                    Image(systemName: "plus.circle")
                        .foregroundColor(ColorTheme().accent)
                        .imageScale(.large)
                })
            }
            ToolbarItem(placement: .bottomBar) {
                Menu(content: {
                    addNewMenu
                }, label: {
                    Image(systemName: "plus.circle")
                        .foregroundColor(ColorTheme().accent)
                        .imageScale(.large)
                })
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear{
            self.noOfPayments = myInvestment.rent.getTotalNumberOfPayments()
            self.totalRent = myInvestment.rent.getTotalAmountOfPayments(aFreq: myInvestment.leaseTerm.paymentFrequency).toString(decPlaces: 2)
            if myInvestment.rent.interimExists() {
                self.interimExists = true
            }
        }
    }
}

#Preview {
    RentView(myInvestment: Investment(), selectedGroup: .constant(Group()), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}


extension RentView {
    private func addNewGroup () {
        let idx = myInvestment.rent.groups.count - 1
        let maxNoPayments = myInvestment.rent.getNumberOfPaymentsForNewGroup(aGroup: myInvestment.rent.groups[idx], aFrequency: myInvestment.leaseTerm.paymentFrequency, eomRule: myInvestment.leaseTerm.endOfMonthRule, referDate: myInvestment.leaseTerm.baseCommenceDate)
        if maxNoPayments > 0 {
            var newGroup = myInvestment.rent.groups[idx].copyGroup()
            newGroup.noOfPayments = maxNoPayments
            self.myInvestment.rent.addGroup(groupToAdd: newGroup)
            self.myInvestment.resetFirstGroup(isInterim: interimExists)
        } else {
            print("alert")
        }
    }
}

extension RentView {
    @ViewBuilder func groupDisplayRow(group: Group) -> some View {
        HStack {
            VStack {
                HStack{
                    Text(groupToFirstText(aGroup: group))
                        .font(myFont)
                        .frame(width: 270, height: 20, alignment: .leading)
                        .onTapGesture {
                            self.selectedGroup = group
                            self.path.append(13)
                        }
                    Spacer()
                }
                HStack {
                    Text(groupToSecondText(aGroup: group))
                        .font(myFont)
                        .frame(width: 270, height: 20, alignment: .leading)
                        .onTapGesture {
                            self.selectedGroup = group
                            self.path.append(13)
                        }
                    Spacer()
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .frame(width: 20, height: 24, alignment: .trailing)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            self.selectedGroup = group
            self.path.append(13)
        }
    }
    
    func groupToFirstText(aGroup: Group) -> String {
        var strAmount: String = "Calculated"
        if aGroup.amount != "CALCULATED" {
            strAmount = amountFormatter(amount: aGroup.amount, locale: myLocale)
        }
        
        var strLocked: String = "Locked"
        if aGroup.locked == false {
            strLocked = "Unlocked"
        }
       
        let strOne: String = "\(aGroup.noOfPayments) @ " + strAmount + "  \(aGroup.paymentType.toString()) " + " " + strLocked
        
        return strOne
    }
    
    func groupToSecondText (aGroup: Group) -> String {
        var strTiming: String = "Equals"
        if aGroup.timing == .advance {
            strTiming = "Advance"
        } else if aGroup.timing == .arrears {
            strTiming = "Arrears"
        }
        
        let strStart: String = "\(dateFormatter(dateIn: aGroup.startDate, locale: myLocale))"
        let strEnd: String = "\(dateFormatter(dateIn: aGroup.endDate, locale: myLocale))"
        let strDate: String = strStart + " to " + strEnd
        
        
        let strTwo: String =   strDate + " " + strTiming
        return strTwo
    }
    
}


extension RentView {
    private var totalsSection: some View {
        VStack {
            totalsHeader
            totalAmounts
        }
    }

    private var totalsHeader: some View {
        HStack {
            Text("Number:")
                .font(myFont)
                .frame(width: 100, height: 20, alignment: .leading)
            Spacer()
            Text("Net Amount:")
                .font(myFont)
                .frame(width: 120, height: 20, alignment: .trailing)
        }
    }
    
    private var totalAmounts: some View {
        HStack {
          
            Text("\(myInvestment.rent.getTotalNumberOfPayments())")
                .font(myFont)
                .frame(width: 100, height: 20, alignment: .leading)
            Spacer()
            Text("\(amountFormatter(amount: myInvestment.rent.getTotalAmountOfPayments(aFreq: myInvestment.leaseTerm.paymentFrequency).toString(), locale: myLocale))")
                .font(myFont)
                .frame(width: 120, height: 20, alignment: .trailing)
        }
    }
}

extension RentView {
    private var addNewMenu: some View {
        VStack {
           addNewMenuItem
        }
    }
    
    private var addNewMenuItem: some View {
        Button(action: {
            addNewGroup()
        }) {
            Label("Add New Group", systemImage: "arrowshape.turn.up.backward")
                .font(myFont)
        }
    }
}


extension RentView {
    private var structuresMenu: some View {
        VStack {
            firstAndLast
            firstAndLastTwo
            lowHigh
            highLow
//            escalation
//            skipPaymentsItem
        }
    }
    
   
    private var firstAndLast: some View {
        Button(action: {
            if self.myInvestment.rent.structureCanBeApplied(freq: myInvestment.leaseTerm.paymentFrequency) == false {
//                alertTitle = alertForStructureWarning()
//                showAlert.toggle()
            } else {
                self.myInvestment.rent.firstAndLast(freq: myInvestment.leaseTerm.paymentFrequency, baseCommence: myInvestment.leaseTerm.baseCommenceDate, EOMRule: myInvestment.leaseTerm.endOfMonthRule)
                //solveForRate()
            }
        }) {
            Label("1stAndLast", systemImage: "arrowshape.turn.up.backward")
                .font(myFont)
        }
    }
    
    private var firstAndLastTwo: some View {
        Button(action: {
            if self.myInvestment.rent.structureCanBeApplied(freq: myInvestment.leaseTerm.paymentFrequency) == false {
//                alertTitle = alertForStructureWarning()
//                showAlert.toggle()
            } else {
                self.myInvestment.rent.firstAndLastTwo(freq: myInvestment.leaseTerm.paymentFrequency, baseCommence: myInvestment.leaseTerm.baseCommenceDate, EOMRule: myInvestment.leaseTerm.endOfMonthRule)
             
            }
        }) {
            Label("1stAndLastTwo", systemImage: "arrowshape.turn.up.backward.2")
                .font(myFont)
        }
    }
    
    private var lowHigh: some View {
        Button(action: {
            if self.myInvestment.rent.structureCanBeApplied(freq: myInvestment.leaseTerm.paymentFrequency) == false {
//                alertTitle = alertForStructureWarning()
//                showAlert.toggle()
            } else {
                self.myInvestment.rent.unevenPayments(lowHigh: true, freq: myInvestment.leaseTerm.paymentFrequency, baseCommence: myInvestment.leaseTerm.baseCommenceDate, EOMRule: myInvestment.leaseTerm.endOfMonthRule)
                self.totalRent = myInvestment.rent.getTotalAmountOfPayments(aFreq: myInvestment.leaseTerm.paymentFrequency).toString(decPlaces: 4)

            }
        }) {
            Label("Low-High", systemImage: "arrow.up.right")
                .font(myFont)
        }
    }
    
    private var highLow: some View {
        Button(action: {
            if self.myInvestment.rent.structureCanBeApplied(freq: myInvestment.leaseTerm.paymentFrequency) == false  {
                
            } else {
                self.myInvestment.rent.unevenPayments(lowHigh: false, freq: myInvestment.leaseTerm.paymentFrequency, baseCommence: myInvestment.leaseTerm.baseCommenceDate, EOMRule: myInvestment.leaseTerm.endOfMonthRule)
               
            }
        }) {
            Label("High-Low", systemImage: "arrow.down.right")
                .font(myFont)
        }
    }
    
    
}

