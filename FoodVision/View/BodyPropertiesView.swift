import SwiftUI

struct BodyPropertiesView: View {
    @Binding var selectedGender: String?
    @State var height: CGFloat = 178
    @State var weight: CGFloat = 70
    
    var figure: Image {
        Image(systemName: selectedGender == "Male" ? "figure.stand" : "figure.stand.dress")
    }
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        figure
                            .resizable()
                            .frame(width: (weight + 178) * 0.5, height: (height * 3.5) * 0.5) // Set the figure height based on the ruler value
                    }
                    Spacer()
                }
                HStack {
                    Spacer()
                    VerticalRulerSlider(height: $height,
                                        minHeight: .constant(0), maxHeight: .constant(200))
                    .frame(minWidth: 100, maxWidth: 100, maxHeight: 1000)
                }
            }
            
            ZStack {
                VStack {
                    Text("Weight \(Int(weight)) kg")
                        .padding(.top, 50)
                }
                Slider(
                    value: $weight,
                    in: 10...300,
                    step: 1
                )
                .padding(.horizontal, 35)
            }
            
        }
    }
}

struct BodyPropertiesView_Previews: PreviewProvider {
    static var previews: some View {
        BodyPropertiesView(selectedGender: .constant("Male"), height: 178, weight: 70)
    }
}
