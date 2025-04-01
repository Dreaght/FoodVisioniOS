import SwiftUI
import SwiftData

struct Diary: View {
    @Query(sort: \DiaryDailyDataPoint.date) var pages: [DiaryDailyDataPoint]
    @State private var showCamera = false  // Track if camera is open
    @State private var showFoodSelection = false
    @State private var capturedImage: UIImage?
    @State private var selectedRegionIndex: Set<Int> = []
    @State private var processor: DummyFoodProcessor?
    @State var diaryPage: DiaryDailyDataPoint = DiaryDailyDataPoint.create(date: dateToString(date: Date()))
    @State private var selectedMeal = ""
    @State private var showDatePicker = false
    @State private var selectedDate = Date()
    @Environment(\.modelContext) var modelContext

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
    private var mealsCount: [Int] { [
        diaryPage.breakfast.count,
        diaryPage.lunch.count,
        diaryPage.dinner.count
    ]
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                previousDayButton
                .padding()
                Spacer()
                diaryPageDate
                Spacer()
                nextDayButton
                .padding()
                Spacer()
            }
            
            MealView(showCamera: $showCamera, foodItems: $diaryPage)  {
                sm in
                selectedMeal = sm
            }
            .onChange(of: mealsCount, initial: false) { old, new  in
                if mealsCount.allSatisfy({ $0 == 0 }) {
                    modelContext.delete(diaryPage)
                    guard let _ = try? modelContext.save() else {
                        print("Should not happen!!! save failed D:")
                        return
                    }
                } else {
                    diaryPage.calculateDailyNutrition()
                }
            }

        }
        .onAppear {
            initializeDiaryPage()
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
                modelContext.insert(diaryPage)
                guard let _ = try? modelContext.save() else {
                    print("Should not happen!!! save failed D:")
                    return
                }
            }
            showFoodSelection = false
            showCamera = false
            selectedRegionIndex.removeAll()
            processor = nil
        }) {
            ZStack {
                Color.customDarkGray
                    .ignoresSafeArea(edges: .all)
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
                        FoodSelectionView(showFoodSelection: $showFoodSelection, selectedRectangles: $selectedRegionIndex, rectangles: regions, image: cimage)
                    } else {
                        Text("No Image Captured")
                    }
                }
            }
        }
    }
    
    private func initializeDiaryPage() {
        if pages.isEmpty {
            diaryPage = DiaryDailyDataPoint.create(date: Diary.dateToString(date: Date()))
        } else if pages.last?.date == Diary.dateToString(date: Date()) {
            diaryPage = pages.last!
        } else {
            diaryPage = DiaryDailyDataPoint.create(date: Diary.dateToString(date: Date()))
        }
    }
    
    private func indexInPages(_ date: String) -> Int? {
        return pages.firstIndex(where: { $0.date == date })
    }
    
    private var previousDayButton: some View {
        Button(action: {
            if diaryPage.date != Diary.dateToString(date: startDate) {
                let yesterday = previousDay()
                if let index = indexInPages(yesterday) {
                    diaryPage = pages[index]
                } else {
                    diaryPage = DiaryDailyDataPoint.create(date: yesterday)
                }
            }
        }) {
            Image(systemName: "arrow.backward")
                .font(.title)
                .foregroundStyle(Color.primary.opacity(0.5))
        }
    }
    
    private var diaryPageDate: some View {
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
                        let sd = Diary.dateToString(date: selectedDate)
                        if let index = indexInPages(sd) {
                            diaryPage = pages[index]
                        } else {
                            diaryPage = DiaryDailyDataPoint.create(date: sd)
                        }
                    }
                    .padding()
                    .background(.customLightBlue)
                    .foregroundColor(.blackInLight)
                    .cornerRadius(8)
                }
                .padding()
            }
    }
    
    private var nextDayButton: some View {
        Button(action: {
            if (diaryPage.date != Diary.dateToString(date: endDate)) {
                let tmr = nextDay()
                if let index = indexInPages(tmr) {
                    diaryPage = pages[index]
                } else {
                    diaryPage = DiaryDailyDataPoint.create(date: tmr)
                }
            }
        }) {
            Image(systemName: "arrow.forward")
                .font(.title)
                .foregroundStyle(Color.primary.opacity(0.5))
        }
    }
    
    func previousDay() -> String {
        print("Previous day tapped")
        guard let date = Diary.stringToDate(date: diaryPage.date) else {
            print("invalid date")
            return "invalid date"
        }
        let calendar = Calendar.current
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: date) {
            // Format yesterday's date back to a string
            let prev = Diary.dateToString(date: yesterday)
            return prev
        }
        return "failed to convert date to string"
    }
    
    func nextDay() -> String {
        print("Next day tapped")
        guard let date = Diary.stringToDate(date: diaryPage.date) else {
            print("invalid date")
            return "invalid date"
        }
        let calendar = Calendar.current
        if let tmr = calendar.date(byAdding: .day, value: 1, to: date) {
            // Format yesterday's date back to a string
            let tomorrow = Diary.dateToString(date: tmr)
            return tomorrow
        }
        return "failed"
    }
    
    static func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Set the desired format
        return dateFormatter.string(from: date)
    }
    
    static func stringToDate(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let d = dateFormatter.date(from: date)
        return d
    }
    
}

#Preview {
    @Previewable @State var diaryEntry = DiaryDailyDataPoint.create(date: "2025-03-30")
    
    Diary()
        .modelContainer(for: DiaryDailyDataPoint.self, inMemory: true)
}
