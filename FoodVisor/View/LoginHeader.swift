//
//  LoginHeader.swift
//  FoodVisor
//
//  Created by Tracy Chan on 2025-02-26.
//

import SwiftUI

struct LoginHeader: View {
    var body: some View {
        VStack {
            Text("Welcome to FoodVision!")
                .font(.largeTitle)
                .fontWeight(.medium)
                .padding()
            
            Text("You can sign in to access your existing account.")
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    LoginHeader()
}
