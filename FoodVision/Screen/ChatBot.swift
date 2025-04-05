import SwiftUI
import SwiftData
import SDWebImageSwiftUI
import FirebaseAuth

struct ChatBot: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @StateObject var vm = ViewModel()
    @FocusState private var isTextFieldFocused: Bool
    @State private var isLoading: Bool = true

    var body: some View {
        if isLoading {
            ProgressView("Loading diary from database")
                .navigationTitle("Assistant")
                .onAppear {
                    Task {
                        vm.pages = await populatePages()
                        isLoading = false
                    }
                }
        } else {
            NavigationStack {
                chatListView
                    .navigationTitle("Assistant")
            }
        }
    }

    private func populatePages() async -> [DiaryDailyDataPoint] {
        let calendar = Calendar.current
        let today = Date()
        let startDate = calendar.date(byAdding: .day, value: -6, to: today) ?? today
        let sd = Diary.dateToString(date: startDate)
        let ed = Diary.dateToString(date: today)
        let fetchDescriptor = FetchDescriptor<DiaryDailyDataPoint>(predicate: #Predicate { $0.date >= sd && $0.date <= ed })

        do {
            return try modelContext.fetch(fetchDescriptor)
        } catch {
            print("Error fetching from db: \(error)")
            return []
        }
    }

    var chatListView: some View {
        ScrollViewReader { proxy in
            ZStack {
                

                VStack(spacing: 0) {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(vm.messages) { message in
                                MessageRowView(message: message) { message in
                                    Task { @MainActor in
                                        await vm.retry(message: message)
                                    }
                                }
                            }
                        }
                    }

                    bottomView(img: Auth.auth().currentUser?.photoURL, proxy: proxy)
                    Spacer()
                }
                .onChange(of: vm.messages.last?.responseText, initial: false) {
                    scrollToBottom(proxy: proxy)
                }
                .onTapGesture {
                                        isTextFieldFocused = false
                                    }
            }
            
        }
    }

    func bottomView(img: URL?, proxy: ScrollViewProxy) -> some View {
        HStack(alignment: .bottom, spacing: 8) {
            TextField("Send Message", text: $vm.inputMessage, axis: .vertical)
                .focused($isTextFieldFocused)
                .submitLabel(.send)
                .onSubmit {
                    Task { @MainActor in
                        isTextFieldFocused = false
                        scrollToBottom(proxy: proxy)
                        await vm.sendTapped()
                    }
                }
                .padding(12)
                .background(Color.primary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.primary.opacity(0.05))
                )
                .disabled(vm.isInteractingWithChatGPT)

            Button {
                Task { @MainActor in
                    isTextFieldFocused = false
                    scrollToBottom(proxy: proxy)
                    await vm.sendTapped()
                }
            } label: {
                ZStack {
                    // Background circle
                    Circle()
                        .fill(Color.primary.opacity(0.1))
                        .frame(width: 45, height: 45)

                    // Foreground icon shifted slightly to the left
                    Image(systemName: "paperplane.fill")
                        .rotationEffect(.degrees(45))
                        .foregroundColor(Color.secondary)
                        .offset(x: -2) // Adjust this value as needed
                }
            }
            .disabled(vm.isInteractingWithChatGPT || vm.inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .padding(.bottom, 2)

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
