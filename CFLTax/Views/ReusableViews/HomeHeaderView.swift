//
//  HomeHeaderView.swift
//  CFLTax
//
//  Created by Steven Williams on 11/18/24.
//

import SwiftUI

struct HomeHeaderView: View {
    @Binding var isDark: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(isDark ? 1.0 : 0.05)
                .ignoresSafeArea()
            VStack {
                backButtonItem
                    .padding(.top, 20)
                Text("Home")
                    .font(.largeTitle).fontWeight(.bold)
                    .foregroundStyle(Color("HeaderColor"))
                    .padding()
            }
           
            
        }
        .frame(height: 75)
    }
    
    var backButtonItem: some View {
        HStack {
            Button {
                print("")
            } label: {
                Image(systemName: "chevron.left")
                Text("Back")
            }
            .foregroundColor(.clear)
            .padding(.leading, 15)
            Spacer()
        }
    }
}

#Preview {
    HomeHeaderView(isDark: .constant(false))
}
