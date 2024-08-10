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
        .navigationTitle("Rent")

    }
}

#Preview {
    RentView(myInvestment: Investment(), selectedGroup: .constant(Group()), path: .constant([Int]()), isDark: .constant(false))
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
                            self.path.append(2)
                        }
                    Spacer()
                }
                HStack {
                    Text(groupToSecondText(aGroup: group))
                        .font(myFont)
                        .onTapGesture {
                            self.selectedGroup = group
                            self.path.append(2)
                        }
                    Spacer()
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
    
    func groupToFirstText(aGroup: Group) -> String {
        var strAmount: String = "Calculated"
        if aGroup.amount != "CALCULATED" {
            strAmount = amountFormatter(amount: aGroup.amount, locale: myLocale)
        }
       
        let strOne: String = "\(aGroup.noOfPayments) @ " + strAmount + " \(aGroup.paymentType.toString()) "
        
        return strOne
    }
    
    func groupToSecondText (aGroup: Group) -> String {
        var strTiming: String = "Equals"
        if aGroup.timing == .advance {
            strTiming = "Advance"
        } else if aGroup.timing == .arrears {
            strTiming = "Arrears"
        }
        
        var strLocked: String = "Locked"
        if aGroup.locked == false {
            strLocked = "Unlocked"
        }
        
        let strStart: String = "\(dateFormatter(dateIn: aGroup.startDate, locale: myLocale))"
        let strEnd: String = "\(dateFormatter(dateIn: aGroup.endDate, locale: myLocale))"
        let strDate: String = strStart + " to " + strEnd
        
        
        let strTwo: String =   strDate + " " + strTiming + " " + strLocked
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
            Spacer()
            Text("\(amountFormatter(amount: strAmount, locale: myLocale))")
            
        }
    }
}

