import SwiftUI

struct Diary: View {
    var body: some View {
        VStack {
            Text("Diary")
                .font(.title)
                .padding()
        }
        .navigationTitle("Diary") // This adds a title in the NavigationStack
    }
}

#Preview {
    Diary()
}
