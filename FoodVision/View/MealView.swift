import SwiftUI

struct MealView: View {
    @Binding var showCamera: Bool
    @Binding var foodItems: DiaryDailyDataPoint  // Pass food items
    var selectedMeal: (String) -> Void
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                MealSectionView(mealName: "Breakfast", foods: $foodItems.breakfast, showCamera: $showCamera) {
                    sm in
                    selectedMeal(sm)
                }
                    .frame(height: proxy.size.height / 3)
                MealSectionView(mealName: "Lunch", foods: $foodItems.lunch, showCamera: $showCamera) {
                    sm in
                    selectedMeal(sm)
                }
                    .frame(height: proxy.size.height / 3)
                MealSectionView(mealName: "Dinner", foods: $foodItems.dinner, showCamera: $showCamera) {
                    sm in
                    selectedMeal(sm)
                }
                    .frame(height: proxy.size.height / 3)
                
            }
        }
    }
}

struct MealSectionView: View {
    let mealName: String
    @Binding public var foods: [MealDataPoint] // Pass food items
    @Binding var showCamera: Bool
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    var onMealSelected: (String) -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Fixed header (Meal title + Add button)
            HStack {
                Text(mealName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.opacity(0.7))
                    .padding(.leading, 20)
                Spacer()
                Button(action: {
                    showCamera = true
                    print("\(mealName): ", foods)
                    onMealSelected(mealName)
                }) {
                    Image(systemName: "plus")
                }
                .foregroundStyle(.opacity(0.9))
                .padding(8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                
            }
            .padding(.horizontal)
            .frame(height: 50)
            .background(Color.customLightGray)  // Fixed height for header
            
            Spacer()
            // Scrollable food list
            VStack {
                if foods.isEmpty {
                    Text("No food items added")
                        .foregroundStyle(Color.gray)
                        .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(foods, id: \.id) { food in
                            FoodItemView(foodImage: food.image ?? UIImage(), foodName: food.foodName, calories: food.calories)
                                .ignoresSafeArea(.all)
                                .frame(maxWidth: .infinity)
                                .listRowInsets(.init(top: 0, leading: 10, bottom: 4, trailing: 10))
                                .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: delete)
                    }
                    .frame(maxWidth: .infinity)
                    .listStyle(.inset)
                }
            }
            .frame(maxWidth: .infinity)
            Spacer()

        }
    }
    
    func delete(at offsets: IndexSet) {
        foods.remove(atOffsets: offsets)
    }
}

struct FoodItemView: View {
    let foodImage: UIImage  // Food image fragment
    let foodName: String    // Food name
    let calories: Int      // Food calories

    var body: some View {
        HStack {
            Image(uiImage: foodImage)  // Use the provided food image
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)  // Adjust size as needed
                .padding(.leading, 10)
            
            VStack(alignment: .leading) {
                Text(foodName)
                    .font(.headline)
                Text("\(calories) kcal")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            .padding(.leading, 10)

            Spacer()
        }
        .padding(.vertical, 8)
        .background(.opacity(0.1))
        .cornerRadius(20)
        .shadow(radius: 1)
    }
}

#Preview {
    @Previewable @State var dia: DiaryDailyDataPoint = DiaryDailyDataPoint.create(date: "2025-03-30")
    @Previewable @State var meal: MealDataPoint = MealDataPoint(image: UIImage(resource: .botpfp), foodName: "Sample food", calories: 100, transFat: 0, saturatedFat: 0, totalFat: 0, protein: 0, sugar: 0, cholesterol: 0, sodium: 0, calcium: 0, iodine: 0, iron: 0, magnesium: 0, potassium: 0, zinc: 0, vitaminA: 0, vitaminC: 0, vitaminD: 0, vitaminE: 0, vitaminK: 0, vitaminB1: 0, vitaminB2: 0, vitaminB3: 0, vitaminB5: 0, vitaminB6: 0, vitaminB7: 0, vitaminB9: 0, vitaminB12: 0)


    Button("Add Meals") {
        dia.addToBreakfast(meal: meal)
        dia.addToLunch(meal: meal)
        dia.addToDinner(meal: meal)
    }
    MealView(showCamera: Binding.constant(false), foodItems: $dia) {
        sm in
        print(sm)
    }
}
