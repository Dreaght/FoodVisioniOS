//
//  LoginScreen.swift
//  FoodVisor
//
//  Created by Tracy Chan on 2025-02-26.
//

import SwiftUI

struct LoginScreen: View {
    var body: some View {
        VStack {
            Spacer()
            LoginHeader().padding(.bottom)
            
            GoogleSignInBtn {
                // TODO: - Call the sign method here
            }
            Spacer()
        }
    }
}

#Preview {
    LoginScreen()
}
