import SwiftUI
import SwiftData
import FirebaseAuth

@main
struct FoodVision: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("signIn") var isSignedIn = false
    @State private var isLoading = true
    @State private var isAccountExist = false
    @AppStorage("prevUid") var prevUid = "no uid"
    @Environment(\.modelContext) var modelContext
    var body: some Scene {
        WindowGroup {
            Group {
                if isLoading {
                    ProgressView()
                        .onAppear {
                            Task {
                                isAccountExist = await verifyAccountExists()
                                isLoading = false // Update loading state after verification
                            }
                        }
                } else {
                    if isSignedIn {
                        NavBar()
                        
                    } else {
                        LoginScreen()
                    }
                }
            }
        }
    }

    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
    
    private func getPrevUid() -> String {
        return Auth.auth().currentUser?.uid ?? "no uid 2"
    }
    
    private func getUID() -> String {
        let currUid = Auth.auth().currentUser?.uid
        print("currUID:", currUid ?? "no uid")
        print("prevUID:", prevUid)
        return currUid ?? "no uid"
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
                    UserDefaults.standard.set(false, forKey: "signIn")
                    try Auth.auth().signOut()
                } catch {
                    print("Signout failed. ???")
                }
                return false
            }
        } else {
            return false
        }
    }

    // This method will reset your entire database by clearing all data.
    // Function to reset or reinitialize the SwiftData model container
    



}
