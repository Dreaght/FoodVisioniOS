//
//  NavBar.swift
//  FoodVision
//
//  Created by Tracy Chan on 2025-02-27.
//

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
    init() {
        let image = UIImage.gradientImageWithBounds(
            bounds: CGRect( x: 0, y: 0, width: UIScreen.main.scale, height: 10),
            colors: [
                UIColor.clear.cgColor,
                UIColor.black.withAlphaComponent(0.1).cgColor
            ]
        )

        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemGray6
                
        appearance.backgroundImage = UIImage()
        appearance.shadowImage = image

        UITabBar.appearance().standardAppearance = appearance
    }
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Image(systemName: "house")
                }
            ReportScreen()
                .tabItem {
                    Image(systemName: "list.clipboard")
                }
            ChatBot()
                .tabItem {
                    Image(systemName: "bubble.left.and.text.bubble.right")
                }
            Settings()
                .tabItem {
                    Image(systemName: "gearshape")
                }
        }
        .tint(Color.customLightBlue)
        
    }
}

#Preview {
    NavBar()
}
