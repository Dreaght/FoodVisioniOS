import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth


struct Settings: View {
    @State var currWeight = 50
    @State private var showPicker: Bool = false // Control visibility of the picker
    @State private var showLogoutOption: Bool = false
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
                    ScrollValuePicker(num: .constant(50), minNum: .constant(2), maxNum: .constant(650), numType: .constant("kg"), textf: .constant("Current Weight:"))
                    ScrollValuePicker(num: .constant(150), minNum: .constant(100), maxNum: .constant(300), numType: .constant("cm"), textf: .constant("Current Height:"))
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
                    print("Handle sign out")
                }),
                .cancel()
            ])
        }
    }
}

#Preview {
    Settings()
}
