import SwiftUI
import _SwiftData_SwiftUI

struct ReportScreen: View {
    @State private var startDate = Date()
    @State private var endDate = Date()
    private let calendar = Calendar.current
    @State private var isGeneratingReport = false
    @State private var isReportGenerated = false
    @State private var reportImage: UIImage? = nil
    @State private var isNoDaysSelected = false
    @Environment(\.modelContext) private var modelContext

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
            Button(action: {
                isGeneratingReport = true
                Task {
                    await generateReport()
                }
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
        .overlay(
            Group{
                if isGeneratingReport {
                    LoadingView()
                }
            }
        )
        .alert(isPresented: $isNoDaysSelected) {
            Alert(
                title: Text("FoodVision"),
                message: Text("Select at least one day with food logged"),
                dismissButton: .default(Text("OK")) {
                    isNoDaysSelected = false
                }
            )
        }
        .sheet(isPresented: $isReportGenerated, onDismiss: {
            isReportGenerated = false
        }) {
            if let reportImage = reportImage {
                Image(uiImage: reportImage)
                    .resizable()
                    .scaledToFit()
                    .padding()
                Button(action: {
                    Task {
                        
                    }
                }) {
                    Text("Download")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.customLightBlue)
                        .foregroundColor(.customLightGray)
                        .cornerRadius(8)
                }
                .padding()
            } else {
                Image("testBurger")
            }
        }
    }
    
    private func generateReport() async {
        let sd = Diary.dateToString(date: startDate)
        let ed = Diary.dateToString(date: min(calendar.date(byAdding: .day, value: 6, to: startDate) ?? Date(), self.endDate))
        
        print("Generating report from \(sd) to \(ed)")
        let api = API()
    
        do {
            let fetchDescriptor = FetchDescriptor<DiaryDailyDataPoint>(predicate: #Predicate { $0.date >= sd && $0.date <= ed })
            let pages = try modelContext.fetch(fetchDescriptor)
            if !pages.isEmpty {
                reportImage = try await api.report(pages)
            } else {
                isReportGenerated = false
                isGeneratingReport = false
                isNoDaysSelected = true
                return
            }
            
        } catch {
            print("Error generating report: \(error)")
        }
        isReportGenerated = true
        isGeneratingReport = false
    }
}

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5) // Background color with transparency
            
            VStack {
                ProgressView() // Loading spinner
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2) // Scale the spinner
                
                Text("Generating Report...")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding(.top, 20)
            }
            .padding(40)
            .background(Color.gray.opacity(0.8))
            .cornerRadius(12)
            .shadow(radius: 10)
        }
        .edgesIgnoringSafeArea(.all) // Cover the whole screen
    }
}

#Preview {
    ReportScreen()
}
