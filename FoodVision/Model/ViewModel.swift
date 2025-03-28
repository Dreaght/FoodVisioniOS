import Foundation
import FirebaseAuth
import SwiftUI

class ViewModel: ObservableObject {
    @Published var isInteractingWithChatGPT = false
    @Published var messages: [MessageRow] = []
    @Published var inputMessage: String = ""
    
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
            // TODO: get response from backend
            messageRow.responseText = streamText
            self.messages[self.messages.count - 1] = messageRow
        } catch {
            messageRow.responseError = error.localizedDescription
        }
        
        messageRow.isInteractingWithChatGPT = false
        self.messages[self.messages.count - 1] = messageRow
        isInteractingWithChatGPT = false
    }
}
