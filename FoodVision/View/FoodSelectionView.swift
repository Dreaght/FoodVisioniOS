import SwiftUI

struct FoodSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showFoodSelection: Bool
    @Binding var selectedRectangles: Set<Int>
    @State private var showAlert = false
    let rectangles: [(Int, Int, Int, Int)]
    let image: UIImage
    
    var imageSize: CGSize {
        let width = UIScreen.main.bounds.width
        let height = image.size.height * width / image.size.width
        return CGSize(width: width, height: height)
    }
    
    var scaledCoords: [(CGFloat, CGFloat, CGFloat, CGFloat)] {
        let ratio = imageSize.height / image.size.height
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
            Color.customDarkGray.ignoresSafeArea()
            
            VStack(spacing: 10) {
                Text("Please select the food you want to log:")
                    .padding()
                    .foregroundStyle(.white)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(10)
                
                Spacer()
                
                HStack {
                    backButton
                    Spacer()
                    submitButton
                }
                .padding(.horizontal, 20)
            }
            .zIndex(1)
            
            ZStack {
                backgroundImage()
                foodSelectionLayer()
            }
            .frame(width: imageSize.width, height: imageSize.height)
            .border(.blue)
            .zIndex(0)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("FoodVision"),
                message: Text("Select at least one food"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private var submitButton: some View {
        Button(action: {
            if selectedRectangles.isEmpty {
                showAlert = true
            } else {
                dismiss()
            }
        }) {
            Text("Submit")
                .font(.system(size: 20))
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .clipShape(Capsule())
        }
    }
    
    private var backButton: some View {
        Button(action: {
            showFoodSelection = false
            selectedRectangles = []
        }) {
            Label("Back", systemImage: "chevron.backward")
                .padding()
                .font(.system(size: 20))
                .foregroundColor(.white)
                .background(Color.gray.opacity(0.6))
                .clipShape(Capsule())
        }
    }
    
    private func backgroundImage() -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(width: imageSize.width, height: imageSize.height)
    }
    
    private func foodSelectionLayer() -> some View {
        ZStack {
            ForEach(0..<rectangles.count, id: \.self) { index in
                rectangleButton(for: index)
            }
        }
        .frame(width: imageSize.width, height: imageSize.height)
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
                .frame(width: rect.2 - rect.0, height: rect.3 - rect.1)
        }
        .position(x: (rect.0 + rect.2) / 2, y: (rect.1 + rect.3) / 2)
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
