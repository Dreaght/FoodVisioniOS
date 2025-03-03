import SwiftUI

struct HeightWeightPickerView: View {
    @State private var height: Double = 170
    @State private var weight: Double = 70
    
    var body: some View {
        VStack(spacing: 20) {
            
            VStack {
                Text("Height - \(Int(height))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Slider(
                    value: $height,
                    in: 50...250,
                    step: 1
                )
                .accentColor(.primary)
                .rotationEffect(.degrees(-90))
            }
            
            VStack {
                Text("Weight - \(Int(weight))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Slider(
                    value: $weight,
                    in: 10...300,
                    step: 1
                )
                .accentColor(.primary)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)).shadow(radius: 5))
        .padding()
    }
}

struct HeightWeightPickerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HeightWeightPickerView()
                .preferredColorScheme(.light)
            HeightWeightPickerView()
                .preferredColorScheme(.dark)
        }
    }
}
