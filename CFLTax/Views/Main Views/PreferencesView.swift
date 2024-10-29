//
//  PreferencesView.swift
//  CFLTax
//
//  Created by Steven Williams on 10/28/24.
//

import SwiftUI

struct PreferencesView: View {
    @Bindable var myInvestment: Investment
    @Binding var isDark: Bool
    @Binding var path: [Int]
    @AppStorage("useSaved") var useSavedAsDefault: Bool = false
    @AppStorage("savedDefault") var savedDefaultLease: String = "No_Data"
    
    @State var saveCurrentAsDefault: Bool = false
    @State var savedDefaultExists: Bool = true
    @State var showPopover: Bool = false
    @State var defaultHelp = defaultNewHelp
    @State private var alertTitle: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("Default Lease Parameters")) {
                defaultNewLeaseItem
                saveCurrentAsDefaultItem
            }
           Section(header: Text("Dark Mode")) {
                colorSchemeItem
            }
            Section(header: Text("Submit Form")){
                SubmitFormButtonsView(cancelName: "Cancel", doneName: "Done", cancel: myCancel, done: myDone, isDark: $isDark)
            }
        }
        
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarTitle("Preferences")
        .navigationBarBackButtonHidden(true)
        .onAppear{
            if self.savedDefaultLease == "No_Data" {
                self.savedDefaultExists = false
            }
        }
   
    }
    
    var defaultNewLeaseItem: some View {
        HStack {
            Text(useSavedAsDefault ? "Use Saved:" : "Use Default:")
                .font(.subheadline)
            Image(systemName: "questionmark.circle")
                .foregroundColor(Color.theme.accent)
                .onTapGesture {
                    self.showPopover = true
                }
            Spacer()
            Toggle("", isOn: $useSavedAsDefault)
                .disabled(savedDefaultExists ? false : true )
        }
        .popover(isPresented: $showPopover) {
            PopoverView(myHelp: $defaultHelp, isDark: $isDark)
        }
    }
    
    var saveCurrentAsDefaultItem: some View {
        HStack {
            Text("Save Current:")
                .font(.subheadline)
            Toggle("", isOn: $saveCurrentAsDefault)
        }
    }
    
    var colorSchemeItem: some View {
        Toggle(isOn: $isDark) {
            Text(isDark ? "Dark Mode is on:" : "Light Mode is on:")
                .font(.subheadline)
        }
    }
    
    private func resetCurrentDefaultNew() {
        if isLeaseSavable() {
            self.savedDefaultLease = myInvestment.writeInvestment()
        } else {
            alertTitle = alertDefaultLease
            showAlert.toggle()
        }
    }
    
    func isLeaseSavable () -> Bool {
        if self.myInvestment.rent.interimExists() == true {
            return false
        }
        
        return true
    }
}

#Preview {
    PreferencesView(myInvestment: Investment(), isDark: .constant(false), path: .constant([Int]()))
}

extension PreferencesView {
        
    func myCancel() {
        
    }
    
    func myDone() {
        
    }
    
}
