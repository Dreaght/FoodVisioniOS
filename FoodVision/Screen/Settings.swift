import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth


struct Settings: View {
    @State private var showPicker: Bool = false // Control visibility of the picker
    @State private var showLogoutOption: Bool = false
    @AppStorage("height") var height = 170
    @AppStorage("currweight") var currweight = 70
    @AppStorage("birthdate") var bday = Date()
    @AppStorage("gender") var gender = "Male"
    @AppStorage("targetweight") var targetweight = 60

    var body: some View {
        VStack {
            Spacer()
            WebImage(url: Auth.auth().currentUser?.photoURL)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipped()
                .cornerRadius(75)
                .overlay(RoundedRectangle(cornerRadius: 75).stroke(Color(.label), lineWidth: 1))
                .shadow(radius: 5)
            Text(Auth.auth().currentUser?.displayName ?? "Stranger")
            Form {
                Section("About Me") {
                    ScrollValuePicker(num: $currweight, minNum: .constant(20), maxNum: .constant(650), numType: .constant("kg"), textf: .constant("Current Weight:"))
                        .onChange(of: currweight, initial: false) {
                            weightChanged(currweight)
                        }
                    ScrollValuePicker(num: $targetweight, minNum: .constant(20), maxNum: .constant(650), numType: .constant("kg"), textf: .constant("Target Weight:"))
                        .onChange(of: currweight, initial: false) {
                            targetweightChanged(targetweight)
                        }
                    ScrollValuePicker(num: $height, minNum: .constant(50), maxNum: .constant(300), numType: .constant("cm"), textf: .constant("Current Height:"))
                        .onChange(of: height, initial: false) {
                            heightChanged(height)
                        }
                    DatePicker(
                        "Birthdate:",
                        selection: $bday,
                        in: ...Date(),
                        displayedComponents: [.date]
                    )
                    .padding(.vertical, 1)
                    .onChange(of: bday, initial: false) {
                        birthdateChanged(bday)
                    }
                }
                .listRowBackground(Color.primary.opacity(0.05)) // 💡 Apply background with opacity

                
                Section("Log Out") {
                    HStack {
                        Text(Auth.auth().currentUser?.email ?? "test@test.com")
                            .disabled(true)
                        Spacer().disabled(true)
                        Button {
                            showLogoutOption.toggle()
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.forward")
                                .rotationEffect(.degrees(180))
                                .font(.system(size: 18, weight: .light))
                                .foregroundStyle(Color(.label))
                        }
                    }
                }
                .listRowBackground(Color.primary.opacity(0.1)) // 💡 Apply background with opacity
            }
        }
        .navigationTitle("Settings") // This adds a title in the NavigationStack
        .actionSheet(isPresented: $showLogoutOption) {
            .init(title: Text("Settings"), message: Text("Are you sure you want to sign out?"), buttons: [
                .destructive(Text("Sign out"), action: {
                    do {
                        UserDefaults.standard.set(Auth.auth().currentUser?.uid ?? "no User id", forKey: "prevUid")
                        try Auth.auth().signOut()
                        UserDefaults.standard.set(false, forKey: "signIn")
                    } catch let signOutError as NSError {
                        print("Error signing out: %@", signOutError.localizedDescription)
                    }
                }),
                .cancel()
            ])
        }
    }
    private func weightChanged(_ newWeight: Int) {
        UserDefaults.standard.set(newWeight, forKey: "currweight")
    }
    private func heightChanged(_ newHeight: Int) {
        UserDefaults.standard.set(newHeight, forKey: "height")
    }
    private func targetweightChanged(_ newWeight: Int) {
        UserDefaults.standard.set(newWeight, forKey: "targetweight")
    }
    private func birthdateChanged(_ newbday: Date) {
        UserDefaults.standard.set(newbday, forKey: "birthdate")
    }
    private func genderChanged(_ newGender: String) {
        UserDefaults.standard.set(newGender, forKey: "gender")
    }
}

#Preview {
    Settings()
}
