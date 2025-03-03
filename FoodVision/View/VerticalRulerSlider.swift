import SwiftUI

struct VerticalRulerSlider: View {
    @Binding var height: CGFloat // Make height a binding so that it reflects the value from the parent view
    @Binding var minHeight: CGFloat
    @Binding var maxHeight: CGFloat
    
    var body: some View {
        VStack {
            Text("\(Int(height)) cm")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
            
            GeometryReader { geometry in
                let rulerHeight = geometry.size.height
                let step = rulerHeight / (maxHeight - minHeight)
                
                ZStack(alignment: .leading) {
                    Color.black
                        .frame(width: 50)
                        .cornerRadius(8)
                    
                    VStack(spacing: 0) {
                        ForEach((Int(minHeight)...Int(maxHeight)).reversed(), id: \.self) { i in
                            HStack {
                                if i % 10 == 0 {
                                    Text("\(i)")
                                        .foregroundColor(.white)
                                        .frame(width: 35, alignment: .trailing)
                                    Rectangle()
                                        .frame(width: 15, height: 2)
                                        .foregroundColor(.white)
                                } else if i % 5 == 0 {
                                    Rectangle()
                                        .frame(width: 10, height: 2)
                                        .foregroundColor(.white)
                                } else {
                                    Rectangle()
                                        .frame(width: 5, height: 1)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                            }
                            .frame(height: step)
                        }
                    }
                    
                    // Slider Stick
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.white)
                        .frame(width: 40, height: 10)
                        .position(x: 25, y: (maxHeight - height) * step)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newHeight = max(50, min(maxHeight, maxHeight - (value.location.y / step)))
                                    height = newHeight
                                }
                        )
                }
            }
            .frame(width: 80)
        }
    }
}

struct VerticalRulerSlider_Previews: PreviewProvider {
    static var previews: some View {
        VerticalRulerSlider(height: .constant(178),
                            minHeight: .constant(50), maxHeight: .constant(250))
    }
}
