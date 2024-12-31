//
//  CFLTaxApp.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import SwiftUI
import Firebase

@main
struct CFLTaxApp: App {
    @State private var showLaunchView: Bool = true
    
    init() {
        FirebaseApp.configure()
        print("Firebase App Initialized")
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                HomeView()
                if showLaunchView {
                    SplashScreenView(showLaunchView: $showLaunchView)
                        .transition(.move(edge: .leading))
                }
            }
            
        }
    }
}
