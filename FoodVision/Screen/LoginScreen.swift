import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseAuth

struct LoginScreen: View {
    @State private var text = "Welcome to FoodVision!"
    @State private var isVisible = false
    @State private var showSignInButton = false

    var body: some View {
        VStack {
            Spacer()
            LoginHeader(text: $text, isVisible: $isVisible, onTextChanged: handleTextChange)
                .padding(.bottom)

            if showSignInButton {
                GoogleSignInBtn {
                    FireAuth.share.signinWithGoogle(presenting: getRootViewController()) { error in
                        print("ERROR: \(String(describing: error))")
                    }
                }
                .transition(.opacity) // Smooth fade-in
                .animation(.easeInOut(duration: 1.0), value: showSignInButton)
            }
            Spacer()
        }
    }

    private func handleTextChange(newText: String) {
        if newText == "Log right into your account" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    showSignInButton = true
                }
            }
        } else {
            showSignInButton = false
        }
    }
}

#Preview {
    LoginScreen()
}
