//
//  BackButtonView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/9/24.
//

import SwiftUI

struct CustomHeaderView: View {
    let name: String
    let isReport: Bool
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @State var buttonName: String = "Back"
    @State private var isHome: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(isDark ? 1.0 : 0.05)
                .ignoresSafeArea()
            VStack {
                backButtonItem
                headerItem
                Spacer()
            }

        }
        .frame(height: 75)
        .onAppear{
            if name == "Home" {
                isHome = true
            }
            if path.count == 1 {
                buttonName = "Home"
            }
        }
    }
    
    var backButtonItem: some View {
        HStack {
            Button {
                if isHome == false {
                    self.path.removeLast()
                }
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                    Text(buttonName)
                }
                .tint(Color("BackButtonColor"))
            }
            .padding()
            Spacer()
        }
    }
    
    var headerItem: some View {
        HStack {
            Text(name)
                .font(isReport ? .headline : .title)
                .fontWeight(.bold)
                .padding(.bottom, 10)
                .foregroundColor(Color("HeaderColor"))
        }
    }
    
}

#Preview {
   
    CustomHeaderView(name: "Header", isReport: false , path: .constant([Int]()), isDark: .constant(false))
}



