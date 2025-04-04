import SwiftUI
import FirebaseAuth
import SwiftData

struct Diary: View {
    @Query(sort: \DiaryDailyDataPoint.date) var pages: [DiaryDailyDataPoint]
    @State private var showCamera = false
    @State private var showFoodSelection = false
    @State private var capturedImage: UIImage?
    @State private var selectedRegionIndex: Set<Int> = []
    @State private var processor: DummyFoodProcessor?
    @State var diaryPage: DiaryDailyDataPoint = DiaryDailyDataPoint.create(date: dateToString(date: Date()))
    @State private var selectedMeal = ""
    @State private var showDatePicker = false
    @State private var selectedDate = Date()
    @Environment(\.modelContext) var modelContext
    @State private var restartNavBar = false


    private var startDate: Date {
        let calendar = Calendar.current
        return calendar.date(from: DateComponents(year: 2025, month: 2, day: 1))!
    }

    private var endDate: Date {
        return Date()
    }

    private var mealsCount: [Int] { [
        diaryPage.breakfast.count,
        diaryPage.lunch.count,
        diaryPage.dinner.count
    ] }

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

            MealView(showCamera: $showCamera, foodItems: $diaryPage) {
                sm in
                selectedMeal = sm
            }
            .onChange(of: mealsCount, initial: false) { old, new in
                if mealsCount.allSatisfy({ $0 == 0 }) {
                    modelContext.delete(diaryPage)
                    // Create a new page if diaryPage is deleted
                    let newPage = DiaryDailyDataPoint.create(date: Diary.dateToString(date: Date()))
                    diaryPage = newPage
                    modelContext.insert(newPage)
                    guard let _ = try? modelContext.save() else {
                        print("Save failed!")
                        return
                    }
                } else {
                    diaryPage.calculateDailyNutrition()
                }
            }

        }
        .onAppear {
            checkAndResetUserData()
            initializeDiaryPage()
        }
        .sheet(isPresented: $showCamera, onDismiss: {
            if processor != nil {
                let foods = processor!.cropSelectedFood(seletedIndices: Array(selectedRegionIndex))
                if selectedMeal == "Breakfast" {
                    diaryPage.breakfast.append(contentsOf: foods)
                } else if selectedMeal == "Lunch" {
                    diaryPage.lunch.append(contentsOf: foods)
                } else if selectedMeal == "Dinner" {
                    diaryPage.dinner.append(contentsOf: foods)
                }
                modelContext.insert(diaryPage)
                guard let _ = try? modelContext.save() else {
                    print("Save failed!")
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
                        let img = image.fixOrientation()
                        capturedImage = img
                        showFoodSelection = true
                        processor = DummyFoodProcessor(frame: img)
                    })
                } else {
                    if let cimage = capturedImage?.fixOrientation() {
                        let regions = processor!.detectFoods()
                        FoodSelectionView(showFoodSelection: $showFoodSelection, selectedRectangles: $selectedRegionIndex, rectangles: regions, image: cimage)
                    } else {
                        Text("No Image Captured")
                    }
                }
            }
        }
    }

    private func checkAndResetUserData() {
        let currentUserID = Auth.auth().currentUser?.uid
        let storedUserID = UserDefaults.standard.string(forKey: "previousUserID")

        if currentUserID != storedUserID {
            if !pages.isEmpty {
                for page in pages {
                    modelContext.delete(page)
                }
                // After deleting, create and insert a new page
                let newPage = DiaryDailyDataPoint.create(date: Diary.dateToString(date: Date()))
                modelContext.insert(newPage)
                diaryPage = newPage
                do {
                    try modelContext.save()
                } catch {
                    print("Failed to delete previous data or insert new page: \(error)")
                    return
                }
            }
            UserDefaults.standard.set(currentUserID, forKey: "previousUserID")

            // Reset the diaryPage to avoid using a destroyed instance
            diaryPage = DiaryDailyDataPoint.create(date: Diary.dateToString(date: Date()))
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
                        showDatePicker = false
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
            if diaryPage.date != Diary.dateToString(date: endDate) {
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
        guard let date = Diary.stringToDate(date: diaryPage.date) else {
            print("invalid date")
            return "invalid date"
        }
        let calendar = Calendar.current
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: date) {
            return Diary.dateToString(date: yesterday)
        }
        return "failed to convert date to string"
    }

    func nextDay() -> String {
        guard let date = Diary.stringToDate(date: diaryPage.date) else {
            print("invalid date")
            return "invalid date"
        }
        let calendar = Calendar.current
        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: date) {
            return Diary.dateToString(date: tomorrow)
        }
        return "failed"
    }

    static func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }

    static func stringToDate(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: date)
    }
}


#Preview {
    @Previewable @State var diaryEntry = DiaryDailyDataPoint.create(date: "2025-03-30")
    
    Diary()
        .modelContainer(for: DiaryDailyDataPoint.self, inMemory: true)
}
