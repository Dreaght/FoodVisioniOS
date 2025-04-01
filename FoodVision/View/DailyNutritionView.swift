import SwiftUI

struct DailyNutritionView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                NutritionPieChart()
                NutritionPieChart()
                NutritionPieChart()
                NutritionPieChart()
                NutritionPieChart()
                NutritionPieChart()
                NutritionPieChart()
                NutritionPieChart()
                NutritionPieChart()
            }
        }
    }
}

#Preview {
    DailyNutritionView()
}
