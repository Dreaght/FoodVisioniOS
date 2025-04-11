import SwiftUI
import Charts

struct NutritionPieChart: View {
    let current: Double
    let min = 0.0
    let max: Double
    let gradient: Gradient
    let nutritionName: String
    let units: String

    var body: some View {
        VStack {
            Gauge(value: current, in: min...max) {
                
            } currentValueLabel: {
                VStack {
                    Text("\(Int(current))")
                        .foregroundColor(.blackInLight)
                        .font(.system(size: 14))
                    Text(units)
                        .foregroundColor(.blackInLight)
                        .font(.system(size: 12))
                }
            }
            .scaleEffect(1.5)
            .gaugeStyle(.accessoryCircular)
            .tint(gradient)
            .frame(width: UIScreen.main.bounds.width / 3)
            Text(nutritionName)
        }
    }
}

#Preview {
    NutritionPieChart(current: 2000, max: 3000, gradient: Gradient(colors: [.customLightBlue, .blue])
, nutritionName: "Calories", units: "kcal")
}
