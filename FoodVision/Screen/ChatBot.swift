import SwiftUI

struct ChatBot: View {
    var body: some View {
        VStack {
            Text("ChatBot")
                .font(.title)
                .padding()
        }
        .navigationTitle("ChatBot") // This adds a title in the NavigationStack
    }
}

#Preview {
    ChatBot()
}
