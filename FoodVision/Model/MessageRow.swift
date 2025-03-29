import SwiftUI

struct MessageRow: Identifiable {
    let id = UUID()
    
    var isInteractingWithChatGPT: Bool
    
    let sendImage: URL?
    let sendText: String
    
    let responseImage: String
    var responseText: String
    
    var responseError: String?
}
