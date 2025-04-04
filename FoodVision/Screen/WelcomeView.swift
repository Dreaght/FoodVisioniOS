import SwiftUI
import FirebaseAuth

struct WelcomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var subtitle: String = "What's your gender?"
    @State private var selectedGender: String? = nil
    @State private var birthDate: Date = Date()
    @State private var height: CGFloat = 178
    @State private var weight: CGFloat = 70
    @State private var userName: String = FireAuth.share.getSavedUserName() // Load saved name
    @State private var opacity: Double = 0 // For fade-in effect
    @State private var moveText: CGFloat = -50 // Start position for "Hi username" text
    @State private var mainUIOpacity: Double = 0 // Opacity for the main UI
    @State private var showComma: Bool = false // Track if comma should be shown
    @State private var showMainApp: Bool = false // Track if NavBar should be shown
    @State private var showBodyPropertionsView: Bool = false
    @State private var disableGenderSelection: Bool = false
    @State private var showBirthDatePicker: Bool = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            // Fade-out animation for all UI elements when showMainApp is true
            if !showMainApp {
                VStack {
                    // "Hi" text with fade-out effect along with the rest of the UI
                    Text("Hi \(userName)\(showComma ? "," : "")")
                        .font(.largeTitle)
                        .fontWeight(.medium)
                        .opacity(showMainApp ? 0 : opacity)  // Control opacity based on showMainApp
                        .offset(y: moveText)
                        .onAppear {
                            // Initial fade-in animation for the welcome text
                            withAnimation(.easeIn(duration: 1)) {
                                opacity = 1
                            }

                            withAnimation(.easeIn(duration: 0)) {
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
                        Text(subtitle)
                            .font(.title3)

                        Spacer()

                        VStack {
                            if !showBodyPropertionsView {
                                if (disableGenderSelection == false) {
                                    GenderSelectionView(selectedGender: $selectedGender)
                                        .disabled(disableGenderSelection)
                                        .opacity(disableGenderSelection == true ? 0.5 : 1)
                                } else {
                                    HStack {
                                        Spacer()
                                        BodyPropertiesPreview(selectedGender: $selectedGender,
                                                  height: $height, weight: $weight)
                                        Spacer()
                                        Spacer()
                                    }
                                    
                                }
                                
                                if (showBirthDatePicker == true) {
                                    BirthDatePickerView(birthDate: $birthDate)
                                        .onAppear {
                                        withAnimation(.easeInOut(duration: 1.0)) {
                                            mainUIOpacity = 1  // Fade-in effect when the view appears
                                        }
                                    }
                                }
                            } else {
                                BodyPropertiesView(
                                    selectedGender: $selectedGender,
                                    height: $height, weight: $weight
                                )
                                .opacity(mainUIOpacity)  // Ensure the view fades in
                                .transition(.opacity)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1.0)) {
                                        mainUIOpacity = 1  // Fade-in effect when the view appears
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 50)

                        Spacer()

                        // Continue button with conditional opacity based on gender selection
                        Button(action: {
                            if (showBirthDatePicker == true) {
                                doShowMainApp()
                            } else if selectedGender != nil && !showBodyPropertionsView {
                                subtitle = "Choose your height and weight"
                                showBodyPropertionsView = true
                                disableGenderSelection = true
                                mainUIOpacity = 0
                            }
                             else if selectedGender != nil && showBodyPropertionsView
                                        && showBirthDatePicker == false {
                                showBodyPropertionsView = false
                                showBirthDatePicker = true
                                subtitle = "Select your birth date"
                                mainUIOpacity = 0
                            }
                            
                        }) {
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
                        .opacity(selectedGender == nil ? 0.5 : 1) // Disable the button if no gender is selected
                        .disabled(selectedGender == nil) // Disable the button completely if no gender is selected
                    }
                    .opacity(mainUIOpacity) // Apply fade-in effect for the rest of the UI
                }
            }

            // Show NavBar after all UI has faded out
            if showMainApp {
                NavBar() // When showMainApp is true, replace WelcomeView with NavBar
            }
        }
        
    }
    
    func doShowMainApp() {
        withAnimation(.easeOut(duration: 1)) {
            // Fade out the UI before switching to the NavBar
            mainUIOpacity = 0
            opacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Trigger the transition to the main app
            showMainApp = true
            UserDefaults.standard.set(height, forKey: "height")
            UserDefaults.standard.set(weight, forKey: "currweight")
            UserDefaults.standard.set(birthDate, forKey: "birthdate")
            UserDefaults.standard.set(String(selectedGender ?? "Male"), forKey: "gender")
            let currUid = Auth.auth().currentUser?.uid
            UserDefaults.standard.set(String(currUid!), forKey: "prevUid")
        }
    }
}

#Preview {
    WelcomeView()
}
