import SwiftUI

struct MealView: View {
    @Binding var showCamera: Bool
    
    @State private var meals: [String: [(name: String, calories: Int)]] = [
        "Breakfast": [("Eggs", 155), ("Toast", 75), ("Orange Juice", 112)],
        "Lunch": [("Salad", 200), ("Grilled Chicken", 335)],
        "Dinner": []
    ]

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                ForEach(["Breakfast", "Lunch", "Dinner"], id: \.self) { meal in
                    MealSectionView(mealName: meal, foods: meals[meal] ?? [], showCamera: $showCamera)
                        .frame(height: proxy.size.height / 3) // 1/3 of available view height
                }
            }
        }
    }
}

struct MealSectionView: View {
    let mealName: String
    @State public var foods: [(name: String, calories: Int)]
    @State private var foodLog:(name: String, calories: Int) = ("", 0)
    @Binding var showCamera: Bool
    
    private func addFood() {
        guard !foodLog.name.isEmpty else {return}
        foods.append(foodLog)
        foodLog = ("", 0)
    }
    
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
                Button (action: { showCamera = true }) {
                    Image(systemName: "plus")
                }
                .foregroundStyle(.opacity(0.9))
                .padding(8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                
            }
            .padding(.horizontal)
            .frame(height: 50)
            .background(Color.customLightGray)// Fixed height for header
            
            Spacer()
            // Scrollable food list
            ScrollView {
                VStack {
                    if foods.isEmpty {
                        Text("No food items added")
                            .foregroundStyle(Color.gray)
                            .padding()
                    } else {
                        ForEach(foods, id: \.name) { food in
                            FoodItemView(foodName: food.name, calories: food.calories)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct FoodItemView: View {
    let foodName: String
    let calories: Int

    var body: some View {
        HStack {
            Image(systemName: "fork.knife") // Default food icon
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundStyle(.gray)
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
    MealView(showCamera: Binding.constant(false))
}
