import SwiftUI

extension Color {
    static let customLightBlue = Color(red: 158/255, green: 240/255, blue: 229/255)
}

extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

struct NavBar: View {
    @Environment(\.colorScheme) var colorScheme

    init() {
        updateAppearance(for: UITraitCollection.current.userInterfaceStyle)
    }

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
        .tint(Color.customLightBlue)
        .onAppear {
            updateAppearance(for: colorScheme == .dark ? .dark : .light)
        }
    }

    private func updateAppearance(for style: UIUserInterfaceStyle) {
        let shadowColor: UIColor = style == .dark ? .white : .black
        let image = UIImage.gradientImageWithBounds(
            bounds: CGRect(x: 0, y: 0, width: UIScreen.main.scale, height: 10),
            colors: [
                UIColor.clear.cgColor,
                shadowColor.withAlphaComponent(0.1).cgColor
            ]
        )

        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundImage = UIImage()
        appearance.shadowImage = image

        UITabBar.appearance().standardAppearance = appearance
    }
}

#Preview {
    NavBar()
}
