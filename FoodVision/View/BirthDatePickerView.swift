import SwiftUI

struct BirthDatePickerView: View {
    @Binding var birthDate: Date

    var body: some View {
        VStack {
            DatePicker(
                "|",
                selection: $birthDate,
                in: ...Date(), // Restrict future dates
                displayedComponents: [.date]
            )
            .datePickerStyle(WheelDatePickerStyle())
            .padding()

            Text("Selected date: \(formattedDate(birthDate))")
                .padding()
        }
        .padding()
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

