import SwiftUI


struct GenderSelectionView: View {
    @Binding var selectedGender: String?

    var body: some View {
        HStack {
            Spacer()
            GenderBox(icon: "figure.stand", label: "Male", isSelected: selectedGender == "Male") {
                selectedGender = "Male"
            }
            Spacer()
            GenderBox(icon: "figure.stand.dress", label: "Female", isSelected: selectedGender == "Female") {
                selectedGender = "Female"
            }
            Spacer()
        }
    }
}

struct GenderBox: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 100))
            Text(label)
                .font(.title)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 30)
        .overlay( // Border instead of filled background
            RoundedRectangle(cornerRadius: 20)
                .stroke(isSelected ? Color.green : Color.gray.opacity(0.5), lineWidth: 4)
        )
        .background(Color.clear) // Remove fill
        .onTapGesture {
            onTap()
        }
    }
}
