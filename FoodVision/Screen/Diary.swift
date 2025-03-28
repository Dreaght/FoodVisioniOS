import SwiftUI

struct Diary: View {
    @State private var showCamera = false  // Track if camera is open

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { previousDay() }) {
                    Image(systemName: "arrow.backward")
                        .font(.title)
                        .foregroundStyle(Color.primary.opacity(0.5))
                }
                .padding()
                Spacer()
                Text("Today")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button(action: { previousDay() }) {
                    Image(systemName: "arrow.forward")
                        .font(.title)
                        .foregroundStyle(Color.primary.opacity(0.5))
                }
                .padding()
                Spacer()
            }
            MealView(showCamera: $showCamera)
        }
        .sheet(isPresented: $showCamera) {
            CameraView()
        }
        
    }
    
    func previousDay() {
        print("Previous day tapped")
    }
    
    func nextDay() {
        print("Next day tapped")
    }
}

#Preview {
    Diary()
}




