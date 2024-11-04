//
//  SubmitFormButtonsView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/9/24.
//

import SwiftUI

struct SubmitFormButtonsView: View {
    let cancelName: String
    let doneName: String
    let cancel: () -> Void
    let done: () -> Void
    var isFocused: Bool
    @Binding var isDark: Bool
    
    var body: some View {
            HStack{
                FormCancelButton(name: cancelName, cancel: cancel, isFocused: isFocused, isDark: $isDark)
                Spacer()
                FormSubmitButton(name: doneName, done: done, isFocused: isFocused, isDark: $isDark)
            }
    }
}



struct FormCancelButton: View {
    let name: String
    let cancel: () -> Void
    var isFocused: Bool = false
    @Binding var isDark: Bool
    
    var body: some View {
        Text (name)
            .font(myFont)
            .foregroundColor(Color.theme.accent)
            .onTapGesture {
                if isFocused == false {
                    cancel()
                }
            }
    }
}

struct FormSubmitButton: View {
    let name: String
    let done: () -> Void
    var isFocused: Bool = false
    @Binding var isDark: Bool
    
    var body: some View {
        Text(name)
            .font(myFont)
            .foregroundColor(Color.theme.accent)
            .onTapGesture {
               if isFocused == false {
                   done()
                }
            }
    }
    
}
    
    

#Preview {
    SubmitFormButtonsView(cancelName: "Delete", doneName: "Submit", cancel: {}, done: {}, isFocused: false, isDark: .constant(false))
}
