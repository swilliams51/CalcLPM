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
                Spacer()
                Text("Home")
                    .font(.largeTitle).fontWeight(.bold)
                    .foregroundStyle(Color("HeaderColor"))
                    .padding(.top, 30)
                    .padding(.bottom, 20)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: 75)
        .environment(\.colorScheme, isDark ? .dark : .light)
    }

}

#Preview {
    HomeHeaderView(isDark: .constant(false))
}
