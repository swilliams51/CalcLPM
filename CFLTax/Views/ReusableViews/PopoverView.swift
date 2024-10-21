//
//  PopoverView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/9/24.
//

import SwiftUI

struct PopoverView: View {
    @Binding var myHelp: Help
    @Binding var isDark: Bool
    
    var body: some View {
        VStack {
            helpLead
            helpTitle
            helpContent
        }
        .frame(width: 300, height: 500)
        .background(Color.theme.popOver)
        .cornerRadius(25.0)
        .environment(\.colorScheme, isDark ? .dark : .light)
    }
    
    var helpLead: some View {
        Text("Help")
            .font(Font.system(.title))
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .padding(.bottom, 5)
    }
    
    var helpTitle: some View {
        Text(myHelp.title)
            .font(Font.system(.title2))
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .padding(.bottom, 10)
    }
    
    var helpContent: some View {
        Text(myHelp.instruction)
            .font(.body)
            .multilineTextAlignment(.center)
            .padding()
    }
}

struct PopoverDecimalPadView: View {
    @Binding var isDark: Bool
    
    var body: some View {
        VStack {
            Text("Help")
                .font(Font.system(.title))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
            Text(decimalPadHelp.title)
                .font(Font.system(.title2))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            
            Text(decimalPadHelp.instruction)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(width: 300, height: 500)
        .background(.blue)
        .cornerRadius(25.0)
        .environment(\.colorScheme, isDark ? .dark : .light)
    }
    
}

struct PopoverView_Previews: PreviewProvider {
    
    static var previews: some View {
        PopoverView(myHelp: .constant(Help(title: "Title", instruction: "Instructions are presented here...")), isDark: .constant(false))
    }
}
