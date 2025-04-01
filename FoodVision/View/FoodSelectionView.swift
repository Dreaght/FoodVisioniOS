import SwiftUI

struct FoodSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showFoodSelection: Bool
    @Binding var selectedRectangles: Set<Int>
    @State private var showAlert = false
    let rectangles: [(Int, Int, Int, Int)]
    let image: UIImage
    let HEIGHT: CGFloat = 400
    var scaledHeight: CGFloat {
        return image.size.height * UIScreen.main.bounds.width / image.size.width
    }
    
    var scaledCoords: [(CGFloat, CGFloat, CGFloat, CGFloat)] {
        let ratio = scaledHeight > HEIGHT ? HEIGHT / image.size.height : UIScreen.main.bounds.width / image.size.width
        return rectangles.map { (x1, y1, x2, y2) in
            let scaledX1 = CGFloat(x1) * ratio
            let scaledY1 = CGFloat(y1) * ratio
            let scaledX2 = CGFloat(x2) * ratio
            let scaledY2 = CGFloat(y2) * ratio
            return (scaledX1, scaledY1, scaledX2, scaledY2)
        }
    }
    
    var body: some View {
        ZStack {
            Color.customDarkGray
                .ignoresSafeArea(.all)
            VStack {
                Spacer()
                Text("Please select the food you want to log:")
                    .padding()
                    .foregroundStyle(.white)
                ZStack {
                    backgroundImage(height: scaledHeight)
                    ForEach(0..<rectangles.count, id: \.self) { index in
                        rectangleButton(for: index)
                    }
                }
                .frame(width: scaledHeight > HEIGHT ? image.size.width * HEIGHT / image.size.height: UIScreen.main.bounds.width, height: scaledHeight > HEIGHT ? HEIGHT : scaledHeight)
                .border(.blue)
                Spacer()
                
                
                HStack{
                    backButton
                    Spacer()
                    submitButton
                }
                
            }
        }
    }
    
    private var submitButton: some View {
        Button(action: {
            if (selectedRectangles.count > 0) {
                dismiss()
            } else {
                showAlert = true
            }
        }) {
            Text("Submit")
                .scaledToFit()
                .font(.system(size: 20))
                .foregroundColor(.white)
        }
        .frame(width: 100, height: 100)
        .clipShape(Circle())
        .padding(.trailing, 20)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("FoodVision"),
                message: Text("Select at least one food"),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private var backButton: some View {
        Button(action: {
            // Action for chevron button
            showFoodSelection = false
            selectedRectangles = []
        }) {
            Label("Back", systemImage: "chevron.backward")
                .padding()
                .font(.system(size: 20))
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding(.leading, 20)
    }

    private func backgroundImage(height: CGFloat) -> some View {
        if height > HEIGHT {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(height: HEIGHT)
        } else {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
        }
    }
    
    private func rectangleButton(for index: Int) -> some View {
        let rect = scaledCoords[index]
        
        return Button(action: {
            toggleSelection(for: index)
        }) {
            Rectangle()
                .fill(Color.clear)
                .overlay(
                    Rectangle()
                        .stroke(selectedRectangles.contains(index) ? Color.green : Color.red, lineWidth: 2)
                )
                .frame(width: CGFloat(rect.2 - rect.0), height: CGFloat(rect.3 - rect.1))
        }
        .position(x: CGFloat((rect.0 + rect.2) / 2),
                  y: CGFloat((rect.1 + rect.3) / 2) )
    }
    
    private func toggleSelection(for index: Int) {
        if selectedRectangles.contains(index) {
            selectedRectangles.remove(index)
        } else {
            selectedRectangles.insert(index)
        }
    }
}

#Preview {
    @Previewable @State var sr: Set<Int> = []
    let buttonPositions: [(Int, Int, Int, Int)] = [
        (50, 50, 100, 100),
        (150, 150, 200, 200),
        (125, 125, 150, 150),
        (300, 175, 330, 190),
        (200, 220, 270, 230)
    ]
    if let img = UIImage(named: "testBurger") {
        FoodSelectionView(showFoodSelection: Binding.constant(true), selectedRectangles: $sr, rectangles: buttonPositions, image: img)
    } else {
        Text("No image found")
    }
}
