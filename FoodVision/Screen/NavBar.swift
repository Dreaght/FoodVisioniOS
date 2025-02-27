import SwiftUI

struct NavBar: View {
    var body: some View {
        TabView {
            NavigationStack {
                Diary()
            }
            .tabItem {
                Label("Diary", systemImage: "house")
            }

            NavigationStack {
                ReportScreen()
            }
            .tabItem {
                Label("Reports", systemImage: "list.clipboard")
            }

            NavigationStack {
                ChatBot()
            }
            .tabItem {
                Label("Chat", systemImage: "bubble.left.and.text.bubble.right")
            }

            NavigationStack {
                Settings()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
        }
    }
}

#Preview {
    NavBar()
}
