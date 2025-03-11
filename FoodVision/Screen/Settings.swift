import SwiftUI

struct Settings: View {
    @State var currWeight = 50
    @State private var showPicker: Bool = false // Control visibility of the picker
    var body: some View {
        VStack {
            Form {
                Section("About Me") {
                    ScrollValuePicker(num: .constant(50), minNum: .constant(2), maxNum: .constant(650), numType: .constant("kg"), textf: .constant("Current Weight:"))
                    ScrollValuePicker(num: .constant(150), minNum: .constant(100), maxNum: .constant(300), numType: .constant("cm"), textf: .constant("Current Height:"))
                }
            }
        }
        .navigationTitle("Settings") // This adds a title in the NavigationStack
    }
}

#Preview {
    Settings()
}
