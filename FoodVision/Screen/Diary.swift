import SwiftUI

struct Diary: View {
    @State private var showCamera = false  // Track if camera is open

    var body: some View {
        VStack {
            Text("Diary")
                .font(.title)
                .padding()
            
            Button("Open Camera") {
                showCamera = true
            }
        }
        .navigationTitle("Diary")
        .sheet(isPresented: $showCamera) {
            CameraView()
        }
    }
}

#Preview {
    Diary()
}
