import SwiftUI

struct DailyNutritionView: View {
    @ObservedObject var page: DiaryDailyDataPoint
    @AppStorage("sex") var sex: String = "Male"
    @AppStorage("currweight") var currweight = 60
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                let male = isMale()
                NutritionPieChart(current: Double(page.calories), max: male ? 2500 : 2000,
                                  gradient: Gradient(colors: [.customLightGray, .yellow]),
                                  nutritionName: "Calories", units: "kcal")
                NutritionPieChart(current: page.protein, max: Double(currweight) * 0.8,
                                  gradient: Gradient(colors: [.customLightGray, .blue]),
                                  nutritionName: "Protein", units: "g")
                NutritionPieChart(current: page.sugar, max: male ? 36 : 25,
                                  gradient: Gradient(colors: [.customLightGray, .teal]),
                                  nutritionName: "Sugar", units: "g")
                NutritionPieChart(current: page.totalFat, max: 78,
                                  gradient: Gradient(colors: [.customLightGray, .green]),
                                  nutritionName: "Total Fat", units: "g")
                NutritionPieChart(current: page.saturatedFat, max: 13,
                                  gradient: Gradient(colors: [.customLightGray, .mint]),
                                  nutritionName: "Saturated Fat", units: "g")
                NutritionPieChart(current: page.transFat, max: 2.2,
                                  gradient: Gradient(colors: [.customLightGray, .cyan]),
                                  nutritionName: "Trans Fat", units: "g")
                NutritionPieChart(current: page.cholesterol, max: 300,
                                  gradient: Gradient(colors: [.customLightGray, .brown]),
                                  nutritionName: "Cholesterol", units: "mg")
                NutritionPieChart(current: Double(page.sodium), max: 1500,
                                  gradient: Gradient(colors: [.customLightGray, .purple]),
                                  nutritionName: "Sodium", units: "mg")
                NutritionPieChart(current: Double(page.calcium), max: 1000,
                                  gradient: Gradient(colors: [.customLightGray, .red]),
                                  nutritionName: "Calcium", units: "mg")
                NutritionPieChart(current: Double(page.iodine), max: 150,
                                  gradient: Gradient(colors: [.customLightGray, .orange]),
                                  nutritionName: "Iodine", units: "mcg")
                NutritionPieChart(current: Double(page.iron), max: male ? 8 : 18,
                                  gradient: Gradient(colors: [.customLightGray, .yellow]),
                                  nutritionName: "Iron", units: "mg")
                NutritionPieChart(current: Double(page.magnesium), max: male ? 400 : 310,
                                  gradient: Gradient(colors: [.customLightGray, .pink]),
                                  nutritionName: "Magnesium", units: "mg")
                NutritionPieChart(current: Double(page.potassium), max: male ? 3400 : 2600,
                                  gradient: Gradient(colors: [.customLightGray, .indigo]),
                                  nutritionName: "Potassium", units: "mg")
                NutritionPieChart(current: Double(page.zinc), max: male ? 11 : 8,
                                  gradient: Gradient(colors: [.customLightGray, .purple]),
                                  nutritionName: "Zinc", units: "mg")
                NutritionPieChart(current: Double(page.vitaminA), max: male ? 900 : 700,
                                  gradient: Gradient(colors: [.customLightGray, .customLightBlue]),
                                  nutritionName: "Vitamin A", units: "mcg")
                NutritionPieChart(current: Double(page.vitaminC), max: male ? 90 : 75,
                                  gradient: Gradient(colors: [.customLightGray, .customLightBlue]),
                                  nutritionName: "Vitamin C", units: "mg")
                NutritionPieChart(current: Double(page.vitaminD), max: 600,
                                  gradient: Gradient(colors: [.customLightGray, .customLightBlue]),
                                  nutritionName: "Vitamin D", units: "IU")
                NutritionPieChart(current: Double(page.vitaminE), max: 15,
                                  gradient: Gradient(colors: [.customLightGray, .customLightBlue]),
                                  nutritionName: "Vitamin E", units: "mg")
                NutritionPieChart(current: Double(page.vitaminK), max: male ? 120 : 90,
                                  gradient: Gradient(colors: [.customLightGray, .customLightBlue]),
                                  nutritionName: "Vitamin K", units: "mg")
                NutritionPieChart(current: Double(page.vitaminB1), max: male ? 1.2 : 1.1,
                                  gradient: Gradient(colors: [.customLightGray, .customLightBlue]),
                                  nutritionName: "Vitamin B1", units: "mg")
                NutritionPieChart(current: Double(page.vitaminB2), max: male ? 1.3 : 1.1,
                                  gradient: Gradient(colors: [.customLightGray, .customLightBlue]),
                                  nutritionName: "Vitamin B2", units: "mg")
                NutritionPieChart(current: Double(page.vitaminB3), max: male ? 16 : 14,
                                  gradient: Gradient(colors: [.customLightGray, .customLightBlue]),
                                  nutritionName: "Vitamin B3", units: "mg")
                NutritionPieChart(current: Double(page.vitaminB5), max: 5,
                                  gradient: Gradient(colors: [.customLightGray, .customLightBlue]),
                                  nutritionName: "Vitamin B5", units: "mg")
                NutritionPieChart(current: Double(page.vitaminB6), max: 1.3,
                                  gradient: Gradient(colors: [.customLightGray, .customLightBlue]),
                                  nutritionName: "Vitamin B6", units: "mg")
                NutritionPieChart(current: Double(page.vitaminB7), max: 30,
                                  gradient: Gradient(colors: [.customLightGray, .customLightBlue]),
                                  nutritionName: "Vitamin B7", units: "mcg")
                NutritionPieChart(current: Double(page.vitaminB9), max: 400,
                                  gradient: Gradient(colors: [.customLightGray, .customLightBlue]),
                                  nutritionName: "Vitamin B9", units: "mcg")
                NutritionPieChart(current: Double(page.vitaminB12), max: 2.4,
                                  gradient: Gradient(colors: [.customLightGray, .customLightBlue]),
                                  nutritionName: "Vitamin B12", units: "mcg")
                
            }
            .padding(.top, 25)
            .padding(.bottom, 5)
        }
    }
    
    private func isMale() -> Bool {
        return sex == "Male"
    }
}

#Preview {
    @Previewable @State var dia: DiaryDailyDataPoint = DiaryDailyDataPoint.create(date: "2025-03-30")
    @Previewable @State var meal: MealDataPoint = MealDataPoint(image: UIImage(resource: .botpfp), foodName: "Sample food", calories: 600, transFat: 1, saturatedFat: 2, totalFat: 3, protein: 4, sugar: 5, cholesterol: 6, sodium: 7, calcium: 8, iodine: 9, iron: 10, magnesium: 11, potassium: 12, zinc: 13, vitaminA: 14, vitaminC: 15, vitaminD: 16, vitaminE: 17, vitaminK: 18, vitaminB1: 19, vitaminB2: 20, vitaminB3: 21, vitaminB5: 22, vitaminB6: 23, vitaminB7: 24, vitaminB9: 25, vitaminB12: 26)


    Button("Add Meals") {
        dia.addToBreakfast(meal: meal)
        dia.addToLunch(meal: meal)
        dia.addToDinner(meal: meal)
        dia.calculateDailyNutrition()
    }
    DailyNutritionView(page: dia)
}
