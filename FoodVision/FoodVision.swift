import SwiftUI
import FirebaseAuth

@main
struct FoodVision: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("signIn") var isSignIn = false
    @State private var isLoading = true

    var body: some Scene {
        WindowGroup {
            Group {
                if isLoading {
                    ProgressView()
                        .onAppear {
                            Task {
                                isSignIn = await verifyAccountExists()
                                isLoading = false // Update loading state after verification
                            }
                        }
                } else {
                    if !isSignIn {
                        LoginScreen()
                    } else {
                        NavBar()
                    }
                }
            }
        }
    }

    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
    
    private func verifyAccountExists() async -> Bool {
        if let currentUser = Auth.auth().currentUser {
            do {
                // Attempt to get a fresh token
                let token = try await currentUser.getIDToken(forcingRefresh: true)
                print("Token: \(token)") // Log the token if necessary
                return true
            } catch {
                print("Error getting token: \(error.localizedDescription)")
                do {
                    try Auth.auth().signOut()
                } catch {
                    print("Signout failed.")
                }
                return false
            }
        } else {
            return false
        }
    }
}
