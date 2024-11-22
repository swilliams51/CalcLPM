//
//  InvestAmortHeader.swift
//  CFLTax
//
//  Created by Steven Williams on 11/22/24.
//

import SwiftUI

struct InvestAmortHeaderView: View {
    let name: String
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @State var buttonName: String = "Back"
    
    var body: some View {
        ZStack {
            Color.black.opacity(isDark ? 1.0 : 0.05)
                .ignoresSafeArea()
            VStack {
                buttonItems
                headerItem
            }

        }
        .frame(width: UIScreen.main.bounds.width, height: 75)
        .onAppear {
            if self.path.count == 1 {
                buttonName = "Home"
            }
        }
    }
    
    var buttonItems: some View {
        HStack{
            backButtonItem
        }
        .padding(.top, 20)
        .padding(.bottom, 20)
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
                .font(.headline)
                .fontWeight(.bold)
                .padding(.bottom, 20)
                .foregroundColor(Color("HeaderColor"))
        }
    }
    
}

#Preview {
    InvestAmortHeaderView(name: "Header", path: .constant([Int]()), isDark: .constant(false))
}
