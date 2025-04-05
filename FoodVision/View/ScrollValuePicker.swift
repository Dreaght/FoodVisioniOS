import SwiftUI

struct ScrollValuePicker: View {
    @Binding var num: Int
    @Binding var minNum: Int
    @Binding var maxNum: Int
    @Binding var numType: String
    @Binding var textf: String
    @State var showPicker: Bool = false

    var body: some View {
        HStack {
            Text("\(textf)")
            Spacer()
            
            if !showPicker {
                Button(action: {
                    showPicker.toggle()
                }) {
                    Text("\(num) \(numType)")
                        .padding(8)
                        .background(Color.customLightGray)
                        .foregroundStyle(Color.blackInLight)
                        .cornerRadius(10)
                }
            } else {
                HStack {
                    Picker("Select Number", selection: $num) {
                        ForEach(minNum...maxNum, id: \.self) { weight in
                            Text("\(weight) \(numType)").tag(weight)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 70)
                    .background(Color.customLightGray)
                    .transition(.move(edge: .top).combined(with: .opacity))

                    Button("Confirm") {
                        showPicker.toggle()
                    }
                }
            }
        }

    }
}

#Preview {
    ScrollValuePicker(num: .constant(50), minNum: .constant(2), maxNum: .constant(650), numType: .constant("kg"), textf: .constant("Current Weight:"))
}
