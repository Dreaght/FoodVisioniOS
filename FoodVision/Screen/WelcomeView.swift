import SwiftUI

struct WelcomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedGender: String? = nil
    @State private var userName: String = FireAuth.share.getSavedUserName() // Load saved name
    @State private var opacity: Double = 0 // For fade-in effect
    @State private var moveText: CGFloat = -50 // Start position for "Hi username" text
    @State private var mainUIOpacity: Double = 0 // Opacity for the main UI
    @State private var showComma: Bool = false // Track if comma should be shown
    
    var body: some View {
        VStack {
            // Welcome text with movement and fade-in animation
            Text("Hi \(userName)\(showComma ? "," : "")")
                .font(.largeTitle)
                .fontWeight(.medium)
                .opacity(opacity)
                .offset(y: moveText)
                .onAppear {
                    // Initial fade-in animation for the welcome text
                    withAnimation(.easeIn(duration: 1)) { // Adjusted duration to 1 second
                        opacity = 1
                    }
                    
                    withAnimation(.easeIn(duration: 0)) { // Adjusted duration to 1 second
                        moveText = 350
                    }
                    
                    // Animate the text back to its final position after 2 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.easeOut(duration: 1)) {
                            opacity = 1
                            moveText = -10
                        }
                    }
                    
                    // After 3 seconds, trigger fade-in for the main UI
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation(.easeIn(duration: 1)) {
                            mainUIOpacity = 1
                            showComma = true
                        }
                    }
                }


            // Main UI content, fades in after the animation
            VStack {
                Text("What's your gender?")
                    .font(.title3)

                Spacer()

                GenderSelectionView(selectedGender: $selectedGender)

                Spacer()

                // Continue button with conditional opacity based on gender selection
                ZStack {
                    Text("Continue")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 100)
                        .blendMode(.destinationOut)
                }
                .background(colorScheme == .dark ? Color.white : Color.black)
                .cornerRadius(50)
                .compositingGroup()
                .opacity(selectedGender == nil ? 0.5 : 1)
            }
            .opacity(mainUIOpacity) // Apply fade-in effect for the rest of the UI
        }
    }
}

struct GenderSelectionView: View {
    @Binding var selectedGender: String?

    var body: some View {
        HStack {
            Spacer()
            GenderBox(icon: "figure.stand", label: "Male", isSelected: selectedGender == "Male") {
                selectedGender = "Male"
            }
            Spacer()
            GenderBox(icon: "figure.stand.dress", label: "Female", isSelected: selectedGender == "Female") {
                selectedGender = "Female"
            }
            Spacer()
        }
    }
}

struct GenderBox: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 100))
            Text(label)
                .font(.title)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 30)
        .overlay( // Border instead of filled background
            RoundedRectangle(cornerRadius: 20)
                .stroke(isSelected ? Color.green : Color.gray.opacity(0.5), lineWidth: 4)
        )
        .background(Color.clear) // Remove fill
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    WelcomeView()
}
