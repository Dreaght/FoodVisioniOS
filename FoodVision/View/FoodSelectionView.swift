import SwiftUI

struct FoodSelectionView: View {
    @Environment(\.dismiss) var dismiss  // Allows closing the sheet
    @Binding var selectedRectangles: Set<Int>
    @State private var showAlert = false
    let rectangles: [(Int, Int, Int, Int)]
    let image: UIImage

    var body: some View {
        VStack {
            Spacer()
            Text("Please select the food you want to log:")
                .padding()
            ZStack {
                backgroundImage(img: image)
                ForEach(0..<rectangles.count, id: \.self) { index in
                    rectangleButton(for: index)
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: 400)
            Spacer()
            
            
            HStack{
                backButton
                Spacer()
                submitButton
            }
            
        }
    }
    
    private var submitButton: some View {
        Button(action: {
            if (selectedRectangles.count > 0) {
                print("submit button tapped")
                print(selectedRectangles)
                dismiss()
            } else {
                showAlert = true
            }
        }) {
            Text("Submit")
                .scaledToFit()
                .font(.system(size: 20))
                .foregroundColor(.blackInLight)
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
            print("Back button tapped")
        }) {
            Label("Back", systemImage: "chevron.backward")
                .padding()
                .font(.system(size: 20))
                .foregroundColor(.blackInLight)
                .cornerRadius(8)
        }
        .padding(.leading, 20)
    }
    
    private func backgroundImage(img: UIImage) -> some View {
        Group {
            Image(uiImage: image)
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: 400)
                .aspectRatio(contentMode: .fill)
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
    @Previewable @State var sr: Set<Int> = []
    let buttonPositions: [(Int, Int, Int, Int)] = [
        (50, 50, 100, 100),
        (150, 150, 200, 200),
        (125, 125, 150, 150),
        (300, 300, 330, 380),
        (200, 300, 270, 330)
    ]
    if let img = UIImage(named: "botpfp") {
        FoodSelectionView(selectedRectangles: $sr, rectangles: buttonPositions, image: img)
    } else {
        Text("No image found")
    }
}
