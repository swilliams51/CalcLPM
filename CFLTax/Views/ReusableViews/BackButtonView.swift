//
//  BackButtonView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/9/24.
//

import SwiftUI

struct BackButtonView: View {
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @State var buttonName: String = "Back"
    
    var body: some View {
        Button {
            goBack()
        } label: {
            HStack {
                Image(systemName: "chevron.left")
                Text(buttonName)
            }
        }
        .tint(Color.theme.accent)
        .onAppear{
            if path.count == 1 {
                buttonName = "Home"
            }
        }
    }
    
    private func goBack() {
        self.path.removeLast()
    }
}

#Preview {
    BackButtonView(path: .constant([Int]()), isDark: .constant(false))
}
