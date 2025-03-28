import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth


struct Settings: View {
    @State private var showPicker: Bool = false // Control visibility of the picker
    @State private var showLogoutOption: Bool = false
    @State private var navigateToWelcome = false
    @AppStorage("height") var height = 170
    @AppStorage("currweight") var currweight = 70
    @AppStorage("birthdate") var bday = Date()
    @AppStorage("gender") var gender = "Male"

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
                    ScrollValuePicker(num: $height, minNum: .constant(50), maxNum: .constant(300), numType: .constant("cm"), textf: .constant("Current Height:"))
                        .onChange(of: height, initial: false) {
                            heightChanged(height)
                        }
                    DatePicker(
                        "Birthdate:",
                        selection: $bday,
                        displayedComponents: [.date]
                    )
                    .onChange(of: bday, initial: false) {
                        birthdateChanged(bday)
                    }
                    .padding(.trailing, 55)
                    .padding(.vertical, 10)
                    HStack {
                        Text("Gender:")
                        Picker("Your Gender", selection: $gender) {
                                    Text("Male").tag("Male")
                                    Text("Female").tag("Female")
                                }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: gender, initial: false) {
                            genderChanged(gender)
                        }
                        .padding()
                    }
                }
                
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
            }
        }
        .navigationTitle("Settings") // This adds a title in the NavigationStack
        .actionSheet(isPresented: $showLogoutOption) {
            .init(title: Text("Settings"), message: Text("Are you sure you want to sign out?"), buttons: [
                .destructive(Text("Sign out"), action: {
                    do {
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
