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
            ScrollView {
                VStack {
                    if foods.isEmpty {
                        Text("No food items added")
                            .foregroundStyle(Color.gray)
                            .padding()
                    } else {
                        ForEach(foods, id: \.id) { food in
                            FoodItemView(foodImage: food.image, foodName: food.foodName, calories: food.calories)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
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
        .padding(.horizontal, 10)
    }
}

#Preview {
    @Previewable @State var dia = DiaryDailyDataPoint(date: "2025-03-30")

    
    MealView(showCamera: Binding.constant(false), foodItems: $dia) {
        sm in
        print(sm)
    }
}
