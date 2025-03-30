import SwiftUI

struct Diary: View {
    @State private var showCamera = false  // Track if camera is open
    @State private var showFoodSelection = false
    @State private var capturedImage: UIImage?
    @State private var foodFragments: [(image: UIImage, name: String, calories: Int)] = []

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
                Button(action: { nextDay() }) {
                    Image(systemName: "arrow.forward")
                        .font(.title)
                        .foregroundStyle(Color.primary.opacity(0.5))
                }
                .padding()
                Spacer()
            }
            MealView(showCamera: $showCamera, foodItems: $foodFragments)  // Pass foodFragments to MealView

        }
        .sheet(isPresented: $showCamera) {
            if !showFoodSelection {
                CameraView(onImageCaptured: { image in
                    capturedImage = image
                    print("Captured Image: \(image)")
                    showFoodSelection = true
                })
            } else {
                if let cimage = capturedImage {
                    let processor = DummyFoodProcessor(frame: cimage)  // capturedImage is the UIImage you captured
                    let regions = processor.detectFoods()
                    FoodSelectionView(rectangles: regions, image: cimage)
                } else {
                    Text("No Image Captured")
                }
            }
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
