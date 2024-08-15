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
    
    var body: some View {
        Form {
            Section(header: Text("Rent")) {
                ForEach(myInvestment.rent.groups) { group in
                    groupDisplayRow(group: group)
                }
            }
            Section(header: Text("Total")){
                totalsSection
            }
        
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
            ToolbarItem(placement: .bottomBar) {
                Menu(content: {
                    structuresMenu
                }, label: {
                    Text("new structure")
                        .foregroundColor(ColorTheme().accent)
                })
            }
            ToolbarItem(placement: .bottomBar) {
                Menu(content: {
                    structuresMenu
                }, label: {
                    Text("new structure")
                        .foregroundColor(ColorTheme().accent)
                })
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationTitle("Rent")
        .navigationBarBackButtonHidden(true)

    }
}

#Preview {
    RentView(myInvestment: Investment(), selectedGroup: .constant(Group()), path: .constant([Int]()), isDark: .constant(false))
}


extension RentView {
    private func addNewGroup (groupIndex: Int, noOfPayments: Int) {
        self.myInvestment.rent.addDuplicateGroup(groupToCopy: myInvestment.rent.groups[groupIndex], numberPayments: noOfPayments)
        self.myInvestment.resetRemainderOfGroups(startGrp: groupIndex + 1)
    }
}


extension RentView {
    @ViewBuilder func groupDisplayRow(group: Group) -> some View {
        HStack {
            VStack {
                HStack{
                    Text(groupToFirstText(aGroup: group))
                        .font(myFont)
                        .onTapGesture {
                            self.selectedGroup = group
                            self.path.append(13)
                        }
                    Spacer()
                }
                HStack {
                    Text(groupToSecondText(aGroup: group))
                        .font(myFont)
                        .onTapGesture {
                            self.selectedGroup = group
                            self.path.append(13)
                        }
                    Spacer()
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
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
            Spacer()
            Text("Net Amount:")
                .font(myFont)
        }
    }
    
    private var totalAmounts: some View {
        HStack {
            let strAmount: String = myInvestment.rent.getTotalAmountOfPayments(aFreq: myInvestment.leaseTerm.paymentFrequency).toString(decPlaces: 2)
            Text("\(myInvestment.rent.getTotalNumberOfPayments())")
                .font(myFont)
            Spacer()
            Text("\(amountFormatter(amount: strAmount, locale: myLocale))")
                .font(myFont)
            
        }
    }
}

extension RentView {
    private var structuresMenu: some View {
        VStack {
//            firstAndLast
//            firstAndLastTwo
//            lowHigh
//            highLow
//            escalation
//            skipPaymentsItem
        }
    }
    
    
    
}

