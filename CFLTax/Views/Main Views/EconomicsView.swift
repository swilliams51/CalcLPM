//
//  EconomicsView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/10/24.
//

import SwiftUI

struct EconomicsView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    
    var body: some View {
        Form{
            Section(header: Text("Economics")){
                HStack{
                    Text("Yield Method:")
                    Spacer()
                    Text("\(myInvestment.economics.yieldMethod.toString())")
                }
                HStack{
                    Text("Yield Target:")
                    Spacer()
                    Text("\(myInvestment.economics.yieldTarget)%")
                }
                HStack{
                    Text("Solve For:")
                    Spacer()
                    Text("\(myInvestment.economics.solveFor)")
                }
                
                HStack{
                    Text("Day Count Method:")
                    Spacer()
                    Text("\(myInvestment.economics.dayCountMethod.toString())")
                }
            }
            Section(header: Text("Submit Form")){
                SubmitFormButtonsView(cancelName: "Cancel", doneName: "Done", cancel: myCancel, done: myDone, isDark: $isDark)            }
            
        }
        .navigationTitle("Economics")
    }
    
    func myCancel(){
        path.removeLast()
    }
    func myDone(){
        path.removeLast()
    }
}

#Preview {
    EconomicsView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false))
}
