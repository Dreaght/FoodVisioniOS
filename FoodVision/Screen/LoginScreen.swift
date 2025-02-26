//
//  LoginScreen.swift
//  FoodVisor
//
//  Created by Tracy Chan on 2025-02-26.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseAuth

struct LoginScreen: View {
    var body: some View {
        VStack {
            Spacer()
            LoginHeader().padding(.bottom)
            
            GoogleSignInBtn {
                FireAuth.share.signinWithGoogle(presenting: getRootViewController()) {error in
                    print("ERROR: \(String(describing: error))" )
                }
            }
            Spacer()
        }
    }
}

#Preview {
    LoginScreen()
}
