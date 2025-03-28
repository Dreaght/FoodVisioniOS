import SwiftUI

struct MealView: View {
    @Binding var showCamera: Bool
    @Binding var foodItems: [(image: UIImage, name: String, calories: Int)]  // Pass food items
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                ForEach(["Breakfast", "Lunch", "Dinner"], id: \.self) { meal in
                    MealSectionView(mealName: meal, foods: $foodItems, showCamera: $showCamera)
                        .frame(height: proxy.size.height / 3)  // Adjust height for each section
                }
            }
        }
    }
}

struct MealSectionView: View {
    let mealName: String
    @Binding public var foods: [(image: UIImage, name: String, calories: Int)]  // Pass food items
    @Binding var showCamera: Bool
    
    private func addFood() {
        // Add food logic if needed
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
                Button(action: {
                    showCamera = true
                    print("FOODS: ", foods)
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
                        ForEach(foods, id: \.name) { food in
                            FoodItemView(foodImage: food.image, foodName: food.name, calories: food.calories)
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
    MealView(showCamera: Binding.constant(false), foodItems: Binding.constant([]))
}
