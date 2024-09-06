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
    @Binding var isDark: Bool
    
    var body: some View {
            HStack{
                FormCancelButton(name: cancelName, cancel: cancel, isDark: $isDark)
                Spacer()
                FormSubmitButton(name: doneName, done: done, isDark: $isDark)
            }
    }
}



struct FormCancelButton: View {
    let name: String
    let cancel: () -> Void
    @Binding var isDark: Bool
    
    var body: some View {
        Text (name)
            .foregroundColor(Color.theme.accent)
            .onTapGesture {
                cancel()
            }
    }
}

struct FormSubmitButton: View {
    let name: String
    let done: () -> Void
    @Binding var isDark: Bool
    
    var body: some View {
        Text(name)
            .foregroundColor(Color.theme.accent)
            .onTapGesture {
                done()
            }
    }
    
}
    
    

#Preview {
    SubmitFormButtonsView(cancelName: "Delete", doneName: "Submit", cancel: {}, done: {}, isDark: .constant(false))
}
