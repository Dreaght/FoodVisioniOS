import SwiftUI

struct LoginHeader: View {
    @Binding var text: String
    @Binding var isVisible: Bool
    var onTextChanged: (String) -> Void

    var body: some View {
        Text(text)
            .font(.title)
            .fontWeight(.medium)
            .opacity(isVisible ? 1.0 : 0.0)
            .padding()
            .onAppear {
                // Initial fade-in
                withAnimation(.easeInOut(duration: 1.0)) {
                    isVisible = true
                }

                // Wait for 3 seconds, then fade out
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        isVisible = false
                    }

                    // After fade-out, change text and fade in again
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        text = "Log right into your account"
                        onTextChanged(text) // Notify LoginScreen
                        withAnimation(.easeInOut(duration: 1.0)) {
                            isVisible = true
                        }
                    }
                }
            }
    }
}

#Preview {
    @Previewable @State var text = "Welcome to FoodVision!"
    @Previewable @State var isVisible = false
    return LoginHeader(text: $text, isVisible: $isVisible, onTextChanged: { _ in })
}
