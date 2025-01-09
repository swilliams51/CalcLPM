//
//  CFLTaxApp.swift
//  CFLTax
//
//  Created by Steven Williams on 8/8/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct CFLTaxApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State private var showLaunchView: Bool = true
    
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
