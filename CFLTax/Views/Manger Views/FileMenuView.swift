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
    
    var body: some View {
        Form {
            newFileItem
            openFileItem
            saveFileItem
            saveAsFileItem
            reportsItem
            preferencesItem
            aboutItem
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
                .font(myFont2)
            Spacer()
            Image(systemName: "return")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            self.currentFile = "File is New"
            self.myInvestment.resetToDefault()
            path.removeLast()
        }
    }
    
    var openFileItem: some View {
        HStack {
            Text("Open")
                .font(myFont2)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(27)
        }
    }
    
    var saveFileItem: some View {
        HStack {
            Text("Save")
                .font(myFont2)
            Spacer()
            Image(systemName: "return")
        }
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
                .font(myFont2)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(29)
        }
    }
    
    var reportsItem: some View {
        HStack {
            Text("Reports")
                .font(myFont2)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(30)
        }
    }
    
    var preferencesItem: some View {
        HStack {
            Text("Preferences")
                .font(myFont2)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(31)
        }
    }
    
    var aboutItem: some View {
        HStack {
            Text("About")
                .font(myFont2)
            Spacer()
            Image(systemName: "chevron.right")
        }
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
