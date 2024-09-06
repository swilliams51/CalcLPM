//
//  FileSaveAsView.swift
//  CFLTax
//
//  Created by Steven Williams on 9/3/24.
//

import SwiftUI

struct FileSaveAsView: View {
    @Bindable var myInvestment: Investment
    @Binding var currentFile: String
    @Binding var path:[Int]
    @Binding var isDark: Bool
    
    @State var editNameStarted: Bool = false
    @State private var fm = LocalFileManager()
    @State private var files: [String] = [String]()
    @State private var fileNameOnEntry: String = ""
    @State private var helpFileSaveAs: Help = saveAsHelp
    @State private var isShowingInvalidNameAlert: Bool = false
    @FocusState private var saveNameIsFocused: Bool
    @State var showPopover1: Bool = false
    private let pasteBoard = UIPasteboard.general
    
    var body: some View {
        Form {
            Section(header: Text("Current File Name")){
                saveAsFileRowItem
            }
            Section(header: Text("Submit Form")){
                textButtonsForSaveAsRow
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
            ToolbarItemGroup(placement: .keyboard){
                DecimalPadButtonsView(cancel: updateForCancel, copy: copyToClipboard, paste: paste, clear: clearAllText, enter: updateForSubmit, isDark: $isDark)
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarTitle("File Save As")
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.files = fm.listFiles(templateMode: false)
        }
    }
    
    var saveAsFileRowItem: some View {
        HStack {
            Text("name:")
                .font(myFont2)
            Image(systemName: "questionmark.circle")
                .foregroundColor(Color.theme.accent)
                .onTapGesture {
                    self.showPopover1.toggle()
                }
            Spacer()
            TextField("file name", text: $currentFile,
                      onEditingChanged: { (editing) in
                if editing == true {
                    editNameStarted = true
                }})
                .font(myFont2)
                .multilineTextAlignment(.trailing)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($saveNameIsFocused)
                .disabled(false)
                .keyboardType(.default)
                .disableAutocorrection(true)
        }
        .alert(isPresented: $isShowingInvalidNameAlert) {
            Alert(title: Text("File Name Error"), message: Text(invalidFileNameMassage), dismissButton: .default(Text("OK")))
        }
        .popover(isPresented: $showPopover1) {
            PopoverView(myHelp: $helpFileSaveAs, isDark: $isDark)
        }
    }
    
    var textButtonsForSaveAsRow: some View {
        HStack{
            Text("Cancel")
                .font(myFont2)
                .foregroundColor(Color.theme.accent)
                .onTapGesture {
                    cancel()
                }
            Spacer()
            Text("Done")
                .font(myFont2)
                .foregroundColor(Color.theme.accent)
                .onTapGesture {
                    done()
                }
        }
    }
}

#Preview {
    FileSaveAsView(myInvestment: Investment(), currentFile: .constant("File Is New"), path: .constant([Int]()), isDark: .constant(false))
}


let invalidFileNameMassage: String = "A valid file name must longer than 2 characters and less than 26. It can include numbers, letters, and underscores, but no special characters."



extension FileSaveAsView {
    func cancel() {
        self.currentFile = self.fileNameOnEntry
        self.path.removeLast()
    }
    
    func done(){
        let strInvestmentData: String = myInvestment.writeInvestment()
        fm.fileSaveAs(strDataFile: strInvestmentData, fileName: currentFile)
    }
}

extension FileSaveAsView {
    func updateForCancel() {
        self.currentFile = self.fileNameOnEntry
        self.path.removeLast()
    }
    
    func copyToClipboard() {
        if self.saveNameIsFocused {
            pasteBoard.string = self.currentFile
        }
    }
    
    func paste() {
        if var string = pasteBoard.string {
            string.removeAll(where: { removeCharacters.contains($0) } )
            if string.isDecimal() {
                if self.saveNameIsFocused {
                    self.currentFile = string
                }
            }
        }
    }
    
    func clearAllText() {
        if self.saveNameIsFocused == true {
            self.currentFile = ""
        }
    }
   
    func updateForSubmit() {
        if self.editNameStarted == true {
            updateForFileName()
            self.path.removeLast()
        }
        self.saveNameIsFocused = false
    }
    
    func updateForFileName() {
        if isNameValid(strIn: currentFile) == false {
            self.currentFile = self.fileNameOnEntry
            self.isShowingInvalidNameAlert = true
        } else {
            let strInvestmentData: String = myInvestment.writeInvestment()
            fm.fileSaveAs(strDataFile: strInvestmentData, fileName: currentFile)
            self.path.removeLast()
        }
       
        self.editNameStarted = false
    }
}
