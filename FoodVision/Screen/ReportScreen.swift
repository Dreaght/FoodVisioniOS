import SwiftUI

struct ReportScreen: View {
    @State private var startDate = Date()
    @State private var endDate = Date()
    private let calendar = Calendar.current
    
    var body: some View {
        let dateRange: ClosedRange<Date> = {
            let startComponents = DateComponents(year: 2025, month: 2, day: 1)
            let startDate = calendar.date(from: startComponents)!
            let endDate = Date() // Today's date
            return startDate...endDate
        }()
        
        VStack {
            Text("Select the start and end date to generate report for:")
                .font(.subheadline)
                .multilineTextAlignment(.leading)
            Text("Choose up to at most a week")
                .multilineTextAlignment(.leading)
                .padding()
            
            DatePicker("Pick the start date:",
                       selection: $startDate,
                       in: dateRange,
                       displayedComponents: [.date])
            .padding()
            
            let maxEndDate = min(calendar.date(byAdding: .day, value: 6, to: startDate) ?? Date(), Date())
            
            DatePicker("Pick the end date:",
                       selection: $endDate,
                       in: startDate...maxEndDate,
                       displayedComponents: [.date])
            .padding()
            Button(action: {                            generateReport()
            }) {
                Text("Generate Report")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.customLightBlue)
                    .foregroundColor(.customLightGray)
                    .cornerRadius(8)
            }
            .padding()
            Spacer()
        }
        .padding()
        .navigationTitle("Report Generation")
    }
    
    private func generateReport() {
        let sd = Diary.dateToString(date: startDate)
        
        let ed = Diary.dateToString(date: min(calendar.date(byAdding: .day, value: 6, to: startDate) ?? Date(), self.endDate))
        print("Generating report from \(sd) to \(ed)")
    }
}

#Preview {
    ReportScreen()
}
