import Foundation
import SwiftData
import FirebaseAuth
import SwiftUI

class ViewModel: ObservableObject {
    @Published var isInteractingWithChatGPT = false
    @Published var messages: [MessageRow] = []
    @Published var inputMessage: String = ""
    @Published var pages: [DiaryDailyDataPoint] = []
    
    init() {
        
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
        let gptResponse = ""
        var messageRow: MessageRow = MessageRow(
            isInteractingWithChatGPT: true,
            sendImage: Auth.auth().currentUser?.photoURL,
            sendText: text,
            responseImage: "botpfp",
            responseText: gptResponse,
            responseError: nil
        )
        self.messages.append(messageRow)
        
        do {
            let message = await chat(text: text)
            
            messageRow.responseText = message
            self.messages[self.messages.count - 1] = messageRow
        }
        
        messageRow.isInteractingWithChatGPT = false
        self.messages[self.messages.count - 1] = messageRow
        isInteractingWithChatGPT = false
    }
    

    func chat(text: String) async -> String {
        
        let api = API()
        
        do {
            // If there are pages, call the API to get the chat message
            let responseMessage = try await api.chat(pages, text)
            return responseMessage
            
        } catch {
            print("Error generating chat: \(error)")
            return "An error occurred while generating the chat"
        }
    }

}
