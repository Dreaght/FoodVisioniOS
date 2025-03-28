import Foundation
import FirebaseAuth
import GoogleSignIn
import Firebase

struct FireAuth {
    static let share = FireAuth()
    
    private init() {}

    func signinWithGoogle(presenting: UIViewController,
                          completion: @escaping (Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign-In configuration
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start sign-in flow
        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { result, error in
            guard error == nil else {
                completion(error)
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else { return }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { result, error in
                guard error == nil else {
                    completion(error)
                    return
                }
                
                print("SIGN IN")
                
                // Save sign-in state
                UserDefaults.standard.set(true, forKey: "signIn")

                // Save user's display name
                if let userName = user.profile?.givenName {
                    UserDefaults.standard.set(userName, forKey: "userName")
                }

                completion(nil)
            }
        }
    }

    // Retrieve saved username
    func getSavedUserName() -> String {
        return UserDefaults.standard.string(forKey: "userName") ?? "Stranger"
    }
}
