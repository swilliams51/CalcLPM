//
//  AboutView.swift
//  CFLTax
//
//  Created by Steven Williams on 10/29/24.
//

import SwiftUI

struct AboutView: View {
    @Bindable var myInvestment: Investment
    @Binding var isDark: Bool
    @Binding var path: [Int]
    
    @ScaledMetric var scale: CGFloat = 1
    var body: some View {
        Form{
            thankYouItem
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(path: $path, isDark: $isDark)
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarTitle("About")
        .navigationBarBackButtonHidden(true)
        .onAppear{
            
        }
    }
    
    var thankYouItem: some View {
        HStack{
            Spacer()
            Text("Thank you for downloading Leasey!")
                .font(.subheadline)
            Spacer()
    
        }
    }
    
    var logoItem: some View {
            VStack{
                HStack {
                    Spacer()
                    Image("cfleaseLogo")
                        .resizable()
                        .frame(width: scale * 100, height: scale * 100 , alignment: .center)
                        .padding()
                    Spacer()
                }
                HStack{
                    Text(getVersion())
                        .font(.footnote)
                }
            }
    }
    
    var companyDetailsItem: some View {
        VStack{
            HStack {
                Spacer()
                Text("CF Software Solutions, LLC")
                    .font(.subheadline)
                .padding()
                Spacer()
            }
            Link("Training Videos", destination: URL(string: "https:/www.cfsoftwaresolutions.com")!)
                .font(.subheadline)
        }
    }
    
    var sendSuggestionsItem: some View {
        VStack {
            Text("Questions or comments")
                .font(.subheadline)
                .padding()
            Text("info@cfsoftwaresolutions.com")
            
        }
    }
    
    private func getVersion() -> String {
        var myVersion: String = "V."
        let myDictionary = Bundle.main.infoDictionary
        let version = myDictionary?["CFBundleShortVersionString"] as? String
        myVersion = myVersion + version!
        
        return myVersion
    }
}

#Preview {
    AboutView(myInvestment: Investment(), isDark: .constant(false), path: .constant([Int]()))
}
