import SwiftUI

struct Diary: View {
    @State private var showCamera = false  // Track if camera is open
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
            CameraView(onImageCaptured: { image in
                capturedImage = image
                print("Captured Image: \(image)")
                
                let processor = DummyFoodProcessor(frame: capturedImage!)  // capturedImage is the UIImage you captured
                processor.detectFoods { foodRegions in
                    // Map food regions to the cropped image fragments
                    let fragments = foodRegions.map { region in
                        (image: region.imageFragment, name: region.nutritionInfo.name, calories: region.nutritionInfo.calories)
                    }
                    foodFragments = fragments  // Update the foodFragments array
                    print(foodFragments)
                }
            })
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
