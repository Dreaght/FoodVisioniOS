import SwiftUI
import Charts

struct NutritionPieChart: View {
    @State private var current  = 3.0

    let min = 0.0
    let max = 10.0
    let gradient = Gradient(colors: [.blue, .blackInLight])

    var body: some View {
            Gauge(value: current, in: min...max) {
            } currentValueLabel: {
                Text("\(Int(current))")
                    .foregroundColor(.blue)
            }
            .gaugeStyle(.accessoryCircular)
            .tint(gradient)
    }
}

#Preview {
    NutritionPieChart()
}
