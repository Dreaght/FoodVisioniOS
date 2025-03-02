//
//  ContentView.swift
//  FoodVisor
//
//  Created by Nikita Efimov on 2/16/25.
//

import SwiftUI

@main
struct FoodVision: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("signIn") var isSignIn = false
    
    var body: some Scene {
        WindowGroup {
            if !isSignIn {
                LoginScreen()
            } else {
                WelcomeView()
            }
        }
    }
}
