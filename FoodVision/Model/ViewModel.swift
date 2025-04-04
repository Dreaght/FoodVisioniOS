import Foundation
import SwiftData
import FirebaseAuth
import SwiftUI

class ViewModel: ObservableObject {
    @Published var isInteractingWithChatGPT = false
    @Published var messages: [MessageRow] = []
    @Published var inputMessage: String = ""
    private let calendar = Calendar.current
    @Environment(\.modelContext) private var modelContext


    
    private var api: String = "backend api"
    
    init(api: String) {
        self.api = api
    }
    
    @MainActor
    func sendTapped() async {
        let text = inputMessage
        inputMessage = ""
        await send(text: text)
    }
    
    @MainActor
    func retry(message: MessageRow) async {
        guard let index = messages.firstIndex(where: { $0.id == message.id }) else {
            return
        }
        self.messages.remove(at: index)
        await send(text: message.sendText)
    }
    
    @MainActor
    private func send(text: String) async {
        isInteractingWithChatGPT = true
        var streamText = "dummy text"
        var messageRow: MessageRow = MessageRow(
            isInteractingWithChatGPT: true,
            sendImage: Auth.auth().currentUser?.photoURL,
            sendText: text,
            responseImage: "botpfp",
            responseText: streamText,
            responseError: nil
        )
        self.messages.append(messageRow)
        
        do {
            let message = await chat()
            
            messageRow.responseText = streamText
            self.messages[self.messages.count - 1] = messageRow
        }
        
        messageRow.isInteractingWithChatGPT = false
        self.messages[self.messages.count - 1] = messageRow
        isInteractingWithChatGPT = false
    }
    
    func chat() async -> String {
        // Get today's date
        let today = Date()
        
        // Calculate the start date (7 days ago from today)
        let startDate = calendar.date(byAdding: .day, value: -6, to: today) ?? today
        
        // Format the start and end dates as strings
        let sd = await Diary.dateToString(date: startDate)
        let ed = await Diary.dateToString(date: today)
        
        let api = API()
        
        do {
            // Fetch data points from the last 7 days
            let fetchDescriptor = FetchDescriptor<DiaryDailyDataPoint>(predicate: #Predicate { $0.date >= sd && $0.date <= ed })
            let pages = try modelContext.fetch(fetchDescriptor)
            
            // If there are pages, call the API to get the chat message
            if !pages.isEmpty {
                let responseMessage = try await api.chat(pages)
                return responseMessage
            } else {
                return "No data found for the past week"
            }
            
        } catch {
            print("Error generating chat: \(error)")
            return "An error occurred while generating the chat"
        }
    }

}
