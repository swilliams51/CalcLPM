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
    
    @AppStorage("savedDefault") var savedDefaultLease: String = "No_Data"
    @AppStorage("useSaved") var useSavedAsDefault: Bool = false
    
    @State private var useMySavedAsDefault: Bool = false // links to "useSaved
    @State private var saveMyCurrentAsDefault: Bool = false
    @State private var savedDefaultExists: Bool = true
    
    @State private var showPop1: Bool = false
    @State private var defaultHelp1 = defaultNewLeaseHelp
    @State private var showPop2: Bool = false
    @State private var defaultHelp2 = defaultSaveCurrentHelp
    
    @State private var alertTitle: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("Default New Lease")) {
                defaultNewLeaseItem
                saveCurrentAsDefaultItem
                resetFileItem
            }
           Section(header: Text("Mode")) {
                colorSchemeItem
            }
            Section(header: Text("Submit Form")){
                SubmitFormButtonsView(cancelName: "Cancel", doneName: "Done", cancel: myCancel, done: myDone, isFocused: false, isDark: $isDark)
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
            
            self.useMySavedAsDefault = useSavedAsDefault
        }
   
    }
    
    var defaultNewLeaseItem: some View {
        HStack {
            Text(useMySavedAsDefault ? "Use Saved:" : "Use Default:")
                .font(.subheadline)
            Image(systemName: "questionmark.circle")
                .foregroundColor(Color.theme.accent)
                .onTapGesture {
                    self.showPop1 = true
                }
            Spacer()
            Toggle("", isOn: $useMySavedAsDefault)
                .disabled(savedDefaultExists ? false : true )
        }
        .popover(isPresented: $showPop1) {
            PopoverView(myHelp: $defaultHelp1, isDark: $isDark)
        }
    }
    
    var saveCurrentAsDefaultItem: some View {
        HStack {
            Text("Save Current:")
                .font(.subheadline)
            Image(systemName: "questionmark.circle")
                .foregroundColor(Color.theme.accent)
                .onTapGesture {
                    self.showPop2 = true
                }
            Toggle("", isOn: $saveMyCurrentAsDefault)
        }
        .popover(isPresented: $showPop2) {
            PopoverView(myHelp: $defaultHelp2, isDark: $isDark)
        }
    }
    
    var resetFileItem: some View {
        HStack {
            Text("Reset File:")
            Spacer()
            Text("Delete Saved")
                .font(myFont)
                .foregroundColor(.blue)
                .onTapGesture {
                    self.savedDefaultLease = "No_Data"
                }
        }
    }
    
    var colorSchemeItem: some View {
        Toggle(isOn: $isDark) {
            Text(isDark ? "Dark Mode:" : "Light Mode:")
                .font(.subheadline)
        }
    }
}

#Preview {
    PreferencesView(myInvestment: Investment(), isDark: .constant(false), path: .constant([Int]()))
}

extension PreferencesView {
        
    func myCancel() {
        self.path.removeLast()
    }
    
    func myDone() {
        if self.useMySavedAsDefault {
            self.useSavedAsDefault = true
        } else {
            self.useSavedAsDefault = false
        }
        
        if self.saveMyCurrentAsDefault {
            let myFile = myInvestment.writeInvestment()
            self.savedDefaultLease = myFile
        }
    
        self.path.removeLast()
    }
    
}
