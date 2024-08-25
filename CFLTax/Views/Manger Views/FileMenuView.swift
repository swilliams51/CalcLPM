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
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            path.append(28)
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
    FileMenuView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false))
}
