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
                .font(.title)
                .fontWeight(.medium)
                .padding()
            Text("Sign-in Options:")
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    LoginHeader()
}
