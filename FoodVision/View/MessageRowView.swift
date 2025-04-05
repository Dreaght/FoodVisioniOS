import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct MessageRowView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    let message: MessageRow
    let retryCallBack: (MessageRow) -> Void
    
    var body: some View {
        VStack(spacing: 8) {  // Reduced spacing for smaller height
            messageRow(text: message.sendText, image: message.sendImage, bgColor: colorScheme == .light ? .white : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 0.5))
            
            let temp: String? = message.responseText
            if let text = temp {
                messageRow(text: text, bgColor: colorScheme == .light ? .gray.opacity(0.1) : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 1), responseError: message.responseError, showDotLoading: message.isInteractingWithChatGPT, image2: message.responseImage)
                    .padding(.bottom, 8)
            }
        }
    }
    
    func messageRow(text: String, image: URL? = nil, bgColor: Color, responseError: String? = nil, showDotLoading: Bool = false, image2: String? = nil) -> some View {
        HStack(alignment: .center, spacing: 12) {  // Reduced spacing for compact look
            if (image != nil) {
                WebImage(url: image)
                .resizable()
                .frame(width: 40, height: 40)  // Smaller image size
                .clipShape(Circle())  // Ensure it's round
                .overlay(Circle().stroke(Color(.label), lineWidth: 1))
                .shadow(radius: 5)
            } else if (image2 != nil) {
                let img: String = image2 ?? "person.crop.circle"
                Image(img)
                    .resizable()
                    .frame(width: 40, height: 40)  // Smaller image size
                    .clipShape(Circle())  // Ensure it's round
                    .overlay(Circle().stroke(Color(.label), lineWidth: 1))
                    .shadow(radius: 5)
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 40, height: 40)  // Smaller image size
                    .clipShape(Circle())  // Ensure it's round
                    .overlay(Circle().stroke(Color(.label), lineWidth: 1))
                    .shadow(radius: 5)
            }
            
            VStack(alignment: .leading, spacing: 4) {  // Reduced spacing for compactness
                if (!text.isEmpty) {
                    Text(text)
                        .multilineTextAlignment(.leading)
                        .textSelection(.enabled)
                }
                
                if let error = responseError {
                    Text("Error: \(error)")
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.leading)
                    
                    Button("Regenerate response") {
                        retryCallBack(message)
                    }
                    .padding(.top, 4)
                }
                
                if showDotLoading {
                    DotLoadingView()
                        .frame(width: 60, height: 30)
                }
                
            }
            .padding(.vertical, 10)  // Smaller vertical padding
            .padding(.horizontal, 20)
            .frame(minHeight: 40)  // Set minimum height for the message text area
            .background(bgColor)
            .cornerRadius(16)  // Rounded background
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
}

#Preview {
    let message = MessageRow(
        isInteractingWithChatGPT: true,
        sendImage: Auth.auth().currentUser?.photoURL,
        sendText: "Question from user?",
        responseImage: "botpfp",
        responseText: "Response from bot"
    )
    let message2 = MessageRow(
        isInteractingWithChatGPT: false,
        sendImage: Auth.auth().currentUser?.photoURL,
        sendText: "Question from user?",
        responseImage: "botpfp",
        responseText: "",
        responseError: "Chatgpt is down"
    )
    NavigationStack {
        ScrollView {
            MessageRowView(message: message, retryCallBack: { message in
            })
            .frame(width: 400)
            .previewLayout(.sizeThatFits)
            MessageRowView(message: message2, retryCallBack: { message in
            })
            .frame(width: 400)
            .previewLayout(.sizeThatFits)
        }
    }
}
