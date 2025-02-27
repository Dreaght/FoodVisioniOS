import SwiftUI

struct Home: View {
    var body: some View {
        VStack {
            Text("Home")
                .font(.title)
                .padding()
        }
        .navigationTitle("Home") // This adds a title in the NavigationStack
    }
}

#Preview {
    Home()
}
