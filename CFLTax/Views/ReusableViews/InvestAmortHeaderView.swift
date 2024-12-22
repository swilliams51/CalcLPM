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
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var isLandscape: Bool { verticalSizeClass == .compact }
    
    var body: some View {
        ZStack {
            Color.black.opacity(isDark ? 1.0 : 0.05)
                .ignoresSafeArea()
            VStack {
                buttonItems
                headerItem
            }

        }
        .frame(width: getWidth(), height: getHeight())
        .onAppear {
            if self.path.count == 1 {
                buttonName = "Home"
            }
        }
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
