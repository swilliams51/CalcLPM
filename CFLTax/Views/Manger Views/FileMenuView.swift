//
//  FileMenuView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/22/24.
//

import SwiftUI

struct FileMenuView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    @State private var fm = LocalFileManager()
    @State private var isShowingFileNameAlert: Bool = false
    
    @AppStorage("savedDefault") var savedDefaultLease: String = "No_Data"
    @AppStorage("useSaved") var useSavedAsDefault: Bool = false
    
    var body: some View {
        Form {
            Section(footer: Text(" File Name: \(currentFile)").font(myFont)) {
                newFileItem
                openFileItem
                saveFileItem
                saveAsFileItem
                reportsItem
                terminationsItem
                preferencesItem
                aboutItem
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationTitle("File")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
    }
    
    var newFileItem: some View {
        HStack {
            Text("New")
            Spacer()
            Image(systemName: "return")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            if self.useSavedAsDefault {
                self.myInvestment.resetToDefault(useSaved: true, currSaved: savedDefaultLease)
            } else {
                self.myInvestment.resetToDefault()
            }
            self.currentFile = "File is New"
            path.removeLast()
        }
    }
    
    var openFileItem: some View {
        HStack {
            Text("Open")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(27)
        }
    }
    
    var saveFileItem: some View {
        HStack {
            Text("Save")
            Spacer()
            Image(systemName: "return")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            if currentFile == "File is New" {
                self.isShowingFileNameAlert = true
            } else {
                let strInvestmentData: String = myInvestment.writeInvestment()
                fm.fileSaveAs(strDataFile: strInvestmentData, fileName: currentFile)
                self.path.removeLast()
            }
           
        }
        .alert(isPresented: $isShowingFileNameAlert) {
            Alert(title: Text("Invalid File Name Error"), message: Text(invalidFileNameMessage), dismissButton: .default(Text("OK")))
        }
        
    }
    
    var saveAsFileItem: some View {
        HStack {
            Text("Save As")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(29)
        }
    }
    
    var reportsItem: some View {
        HStack {
            Text("Reports")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(30)
        }
    }
    
    var terminationsItem: some View {
        HStack {
            Text("Termination Reports")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(36)
        }
    }
    
    var preferencesItem: some View {
        HStack {
            Text("Preferences")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(31)
        }
    }
    
    var aboutItem: some View {
        HStack {
            Text("About")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(myFont)
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(32)
        }
    }
    
}

#Preview {
    FileMenuView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"))
}


let invalidFileNameMessage: String = "Cannot save the file under name - File is New.  Select File Save As and then rename the file."
