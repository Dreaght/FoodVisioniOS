import SwiftUI

struct Settings: View {
    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
                .padding()
        }
        .navigationTitle("Settings") // This adds a title in the NavigationStack
    }
}

#Preview {
    Settings()
}
