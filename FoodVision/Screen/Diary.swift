import SwiftUI

struct Diary: View {
    @State private var showCamera = false  // Track if camera is open
    @State private var showFoodSelection = false
    @State private var capturedImage: UIImage?
    @State private var selectedRegionIndex: Set<Int> = []
    @State private var processor: DummyFoodProcessor?
    @State var diaryPage: DiaryDailyDataPoint = DiaryDailyDataPoint(date: "dummy date")
    @State private var selectedMeal = ""
    
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
            MealView(showCamera: $showCamera, foodItems: $diaryPage)  {
                sm in
                selectedMeal = sm
            }

        }
        .sheet(isPresented: $showCamera, onDismiss: {
            if processor != nil {
                let foods = processor!.cropSelectedFood(seletedIndices: Array(selectedRegionIndex))
                if (selectedMeal == "Breakfast") {
                    diaryPage.breakfast.append(contentsOf: foods)
                } else if (selectedMeal == "Lunch") {
                    diaryPage.lunch.append(contentsOf: foods)
                } else if (selectedMeal == "Dinner") {
                    diaryPage.dinner.append(contentsOf: foods)
                }
            }
            showFoodSelection = false
            showCamera = false
            selectedRegionIndex.removeAll()
            processor = nil
        }) {
            if !showFoodSelection {
                CameraView(onImageCaptured: { image in
                    capturedImage = image
                    print("Captured Image: \(image)")
                    showFoodSelection = true
                    processor = DummyFoodProcessor(frame: image)
                })
            } else {
                if let cimage = capturedImage {
                    let regions = processor!.detectFoods()
                    
                    FoodSelectionView(selectedRectangles: $selectedRegionIndex, rectangles: regions, image: cimage)
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
