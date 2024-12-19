//
//  ReportHeaderView.swift
//  CFLTax
//
//  Created by Steven Williams on 11/19/24.
//

import SwiftUI

struct ReportHeaderView: View {
    let name: String
    let viewAsPct:() -> Void
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @State var viewAsPctOfCost: Bool = false
    @State var buttonName: String = "Back"
    @State private var isHome: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(isDark ? 1.0 : 0.05)
                .ignoresSafeArea()
            VStack {
                buttonItems
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
    
    var buttonItems: some View {
        HStack{
            backButtonItem
            Spacer()
            commandButtonItem
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
    
    var commandButtonItem: some View {
        Button(action: {
            viewAsPct()
            viewAsPctOfCost.toggle()
        }) {
            Image(systemName: "command.circle")
                .tint(viewAsPctOfCost ? Color("PercentOff") : Color("PercentOn"))
                .scaleEffect(1.2)
        }
        .padding(.trailing, 20)
    }
    
    var headerItem: some View {
        HStack {
            Text(name)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.bottom, 20)
                .foregroundColor(isDark ? .white : .black)
        }
    }
    
}

#Preview {
    ReportHeaderView(name: "Header", viewAsPct: {}, path: .constant([Int]()), isDark: .constant(false))
}
