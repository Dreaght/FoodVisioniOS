import SwiftUI

struct FoodSelectionView: View {
    @State private var selectedRectangles: Set<Int> = []
    let rectangles: [(Int, Int, Int, Int)]
    let image: UIImage

    var body: some View {
        VStack {
            Spacer()
            ZStack {
                backgroundImage(img: image)
                ForEach(0..<rectangles.count, id: \.self) { index in
                    rectangleButton(for: index)
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: 400)
            
            Button(action: {
                print("submit button tapped")
                print(selectedRectangles)
            }) {
                Label {
                    
                } icon: {
                    Image(systemName: selectedRectangles.count > 0 ? "checkmark.circle" : "xmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.blackInLight)
                }
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .padding()
            Spacer()
        }
    }
    
    private func backgroundImage(img: UIImage) -> some View {
        Group {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        }
    }
    
    private func rectangleButton(for index: Int) -> some View {
        let rect = rectangles[index]
        
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
    let buttonPositions: [(Int, Int, Int, Int)] = [
        (50, 50, 100, 100),
        (150, 150, 200, 200),
        (125, 125, 150, 150),
        (300, 300, 330, 380),
        (200, 300, 270, 330)
    ]
    if let img = UIImage(named: "botpfp") {
        FoodSelectionView(rectangles: buttonPositions, image: img)
    } else {
        Text("No image found")
    }
}
