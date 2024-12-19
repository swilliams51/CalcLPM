//
//  BackButtonView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/9/24.
//

import SwiftUI

struct MenuHeaderView: View {
    let name: String
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
                    .padding(.top, 20)
                headerItem
            }

        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .frame(width: UIScreen.main.bounds.width, height: 75)
        .onAppear {
            if self.path.count == 1 {
                buttonName = "Home"
            }
        }
    }
    
    var backButtonItem: some View {
        HStack {
            Button {
                self.path.removeLast()
            } label: {
                Image(systemName: "chevron.left")
                Text(buttonName)
            }
            .tint(Color("BackButtonColor"))
            .padding(.leading, 20)
            Spacer()
        }
    }
    
    var headerItem: some View {
        HStack {
            Text(name)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 20)
                .foregroundColor(Color("HeaderColor"))
        }
    }
    
}

#Preview {
   
    MenuHeaderView(name: "Header", path: .constant([Int]()), isDark: .constant(false))
}



