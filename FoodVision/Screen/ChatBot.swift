import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth

struct ChatBot: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject var vm = ViewModel(api: "backend API")
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationStack() {
            chatListView
                .navigationTitle("Assistant")
        }
    }
    
    var chatListView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(vm.messages) {
                            message in
                            MessageRowView(message: message) {
                                message in Task {
                                    @MainActor in await vm.retry(message: message)
                                }
                            }
                        }
                    }
                }
                Divider()
                bottomView(img: Auth.auth().currentUser?.photoURL, proxy: proxy)
                Spacer()
            }
            .onChange(of: vm.messages.last?.responseText, initial: false) {
                scrollToBottom(proxy: proxy)
            }
        }
        .background(colorScheme == .light ? .white : Color(red:52/255, green: 53/255, blue:65/255, opacity: 0.5))
    }
    
    func bottomView(img: URL?, proxy: ScrollViewProxy) -> some View {
        HStack(alignment: .top, spacing: 8) {
            if let url = img {
                WebImage(url: url)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .cornerRadius(75)
                    .overlay(RoundedRectangle(cornerRadius: 75).stroke(Color(.label), lineWidth: 1))
                    .shadow(radius: 5)
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .cornerRadius(75)
                    .overlay(RoundedRectangle(cornerRadius: 75).stroke(Color(.label), lineWidth: 1))
                    .shadow(radius: 5)
            }
            
            TextField("Send Message", text: $vm.inputMessage, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .focused($isTextFieldFocused)
                .disabled(vm.isInteractingWithChatGPT)
            
            if (vm.isInteractingWithChatGPT) {
                DotLoadingView().frame(width: 60, height: 30)
            } else {
                Button {
                    Task {
                        @MainActor in
                        isTextFieldFocused = false
                        scrollToBottom(proxy: proxy)
                        await vm.sendTapped()
                    }
                    
                } label: {
                    Image(systemName: "paperplane.circle.fill")
                        .rotationEffect(.degrees(45))
                        .font(.system(size: 30))
                }
                .disabled(vm.inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = vm.messages.last?.id else { return }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
}

#Preview {
    ChatBot()
}
