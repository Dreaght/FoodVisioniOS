import SwiftUI

struct Diary: View {
    @State private var showCamera = false  // Track if camera is open
    @State private var showFoodSelection = false
    @State private var capturedImage: UIImage?
    @State private var selectedRegionIndex: Set<Int> = []
    @State private var processor: DummyFoodProcessor?
    @Binding var diaryPage: DiaryDailyDataPoint
    @State private var selectedMeal = ""
    @State private var showDatePicker = false
    @State private var selectedDate = Date()
    
    // Define the date range
    private var startDate: Date {
        // February 1, 2025
        let calendar = Calendar.current
        return calendar.date(from: DateComponents(year: 2025, month: 2, day: 1))!
    }
        
    private var endDate: Date {
        // Today's date
        return Date()
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    let yesterday = previousDay()
                    diaryPage = DiaryDailyDataPoint.create(date: yesterday)
                }) {
                    Image(systemName: "arrow.backward")
                        .font(.title)
                        .foregroundStyle(Color.primary.opacity(0.5))
                }
                .padding()
                Spacer()
                Text(diaryPage.date)
                    .font(.title)
                    .fontWeight(.bold)
                    .onTapGesture {
                        showDatePicker = true
                    }
                    .sheet(isPresented: $showDatePicker, onDismiss: {
                        showDatePicker = false
                    }) {
                        VStack {
                            Text("Select a date")
                                .font(.title.bold())
                                .padding()
                            DatePicker("Select a date", selection: $selectedDate, in: startDate...endDate, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding()

                            Button("Done") {
                                showDatePicker = false // Dismiss the sheet
                                diaryPage = DiaryDailyDataPoint.create(date: dateToString(date: selectedDate))
                            }
                            .padding()
                            .background(.customLightBlue)
                            .foregroundColor(.blackInLight)
                            .cornerRadius(8)
                        }
                        .padding()
                    }
                Spacer()
                Button(action: {
                    if (diaryPage.date != dateToString(date: Date())) {
                        let tmr = nextDay()
                        diaryPage = DiaryDailyDataPoint.create(date: tmr)
                    }
                }) {
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
    
    func previousDay() -> String {
        print("Previous day tapped")
        guard let date = stringToDate(date: diaryPage.date) else {
            print("invalid date")
            return "invalid date"
        }
        let calendar = Calendar.current
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: date) {
            // Format yesterday's date back to a string
            let prev = dateToString(date: yesterday)
            return prev
        }
        return "failed to convert date to string"
    }
    
    func nextDay() -> String {
        print("Next day tapped")
        guard let date = stringToDate(date: diaryPage.date) else {
            print("invalid date")
            return "invalid date"
        }
        let calendar = Calendar.current
        if let tmr = calendar.date(byAdding: .day, value: 1, to: date) {
            // Format yesterday's date back to a string
            let tomorrow = dateToString(date: tmr)
            return tomorrow
        }
        return "failed"
    }


}

#Preview {
    @Previewable @State var diaryEntry = DiaryDailyDataPoint.create(date: "2025-03-30")
    
    Diary(diaryPage: $diaryEntry)
}
