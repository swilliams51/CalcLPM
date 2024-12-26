//
//  HeaderView.swift
//  CFLTax
//
//  Created by Steven Williams on 12/24/24.
//

import SwiftUI

struct HeaderView: View {
    let headerType: HeaderViewType
    let name: String
    let viewAsPct:() -> Void
    let goBack:() -> Void
    let withBackButton: Bool
    let withPctButton: Bool
    @Binding var path: [Int]
    @Binding var isDark: Bool
    
    @State var viewAsPctOfCost: Bool = false
    @State var buttonName: String = "Back"
    @State private var isHome: Bool = false
    
    @State var nameFont: Font = .largeTitle
    @State var nameWeight: Font.Weight = .bold
   
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var isLandscape: Bool { verticalSizeClass == .compact }
    
    var body: some View {
        ZStack {
            Color.black.opacity(isDark ? 1.0 : 0.05)
                .ignoresSafeArea()
            VStack {
                if headerType == .home {
                    homeViewItem
                } else if headerType == .menu {
                    menuViewItem
                } else {
                    reportViewItem
                }
                
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .frame(width: getWidth(), height: getHeight())
        .onAppear{
            if self.path.count == 1 {
                self.buttonName = "Home"
            }
            setFontDetails()
        }
        
    }
    
    var homeViewItem: some View {
        HStack{
            Spacer()
            headerItem
            Spacer()
        }
    }
    
    var menuViewItem: some View {
        VStack {
            HStack{
                backButtonItem
                Spacer()
                Text("filler")
                    .foregroundStyle(.clear)
                    .padding(.trailing, 20)
            }
            HStack{
                headerItem
                    .padding(.top, 20)
            }
        }
       
    }
    
    var reportViewItem: some View {
        VStack {
            HStack {
                backButtonItem
                Spacer()
                commandButtonItem
            }
            HStack {
                headerItem
                    .padding(.top, 20)
            }
        }
        
    }
    
    
    private func setFontDetails() {
        switch headerType {
        case .home:
            break
        case .menu:
            nameFont = .title
            nameWeight = .bold
        case .report:
            nameFont = .title2
            nameWeight = .bold
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
            return UIScreen.main.bounds.width * 0.15
        } else {
            //return 75
           return UIScreen.main.bounds.height * 0.15
        }
    }
    
    var backButtonItem: some View {
        HStack {
            Button {
                goBack()
            } label: {
                Image(systemName: "chevron.left")
                Text(buttonName)
            }
            .tint(Color("BackButtonColor"))
            .padding(.leading, 20)
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
                .font(nameFont)
                .fontWeight(nameWeight)
                .foregroundColor(isDark ? .white : .black)
        }
    }
    
}


#Preview {
    HeaderView(headerType: .report, name: "Home", viewAsPct: {}, goBack: {}, withBackButton: true, withPctButton: true, path: .constant([Int]()), isDark: .constant(false))
}
