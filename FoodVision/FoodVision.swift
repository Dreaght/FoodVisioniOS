import SwiftUI
import FirebaseAuth

@main
struct FoodVision: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("signIn") var isSignedIn = false
    @State private var isLoading = true
    @State private var isAccountExist = false
    @AppStorage("prevUid") var prevUid = "no uid"
    @Environment(\.modelContext) var modelContext
    @State private var isDoneWelcome = false
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
                        if isAccountExist || getUID() == prevUid {
                            if getUID() == prevUid {
                                NavBar()
                            } else{
                                if !isDoneWelcome {
                                    WelcomeView(isDoneWelcome: $isDoneWelcome)
                                        .modelContainer(for: DiaryDailyDataPoint.self)
                                } else {
                                    NavBar()
                                }
                            }
                        } else {
                            if !isDoneWelcome {
                                WelcomeView(isDoneWelcome: $isDoneWelcome)
                                    .modelContainer(for: DiaryDailyDataPoint.self)
                            } else {
                                NavBar()
                            }
                        }
                    } else {
                        LoginScreen()
                            .onAppear {
                                isDoneWelcome = false
                            }
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
            prevUid = currentUser.uid
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
}
