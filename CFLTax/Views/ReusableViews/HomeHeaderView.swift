//
//  HomeHeaderView.swift
//  CFLTax
//
//  Created by Steven Williams on 11/18/24.
//

import SwiftUI

struct HomeHeaderView: View {
    @Binding var isDark: Bool
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var isLandscape: Bool { verticalSizeClass == .compact }
    
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
        .frame(width: getWidth(), height: getHeight())
        .environment(\.colorScheme, isDark ? .dark : .light)
    }
    
    private func getWidth() -> CGFloat {
        if isLandscape {
            return UIScreen.main.bounds.height * 2.0
        } else {
            return UIScreen.main.bounds.width
        }
    }
    
    func getHeight() -> CGFloat {
        if isLandscape {
            return UIScreen.main.bounds.width * 0.10
        } else {
            //return 75
           return UIScreen.main.bounds.height * 0.08
        }
    }

}

#Preview {
    HomeHeaderView(isDark: .constant(false))
}
