import Foundation
import UIKit

// DummyFoodProcessor class that detects food regions in an image
class DummyFoodProcessor {
    
    private let image: UIImage
    
    init(frame: UIImage) {
        self.image = frame
    }
    
    // Asynchronously detects food regions from the image
    func detectFoods(completion: @escaping ([FoodRegion]) -> Void) {
        // Get the frame dimensions
        let frameWidth = Int(image.size.width)
        let frameHeight = Int(image.size.height)
        
        // Generate 3 random regions
        let regions = (0..<3).map { _ in
            createRandomRegion(frameWidth: frameWidth, frameHeight: frameHeight)
        }
        
        // Extract fragments based on the regions
        var foodRegions: [FoodRegion] = []
        
        for rect in regions {
            if let fragment = cropImage(image: image, rect: rect) {
                let foodRegion = FoodRegion(rect: rect, imageFragment: fragment, nutritionInfo: NutritionInfo(name: "Sample Food", calories: 100))
                foodRegions.append(foodRegion)
            }
        }
        
        // Simulate a delay for asynchronous processing
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            DispatchQueue.main.async {
                completion(foodRegions)
            }
        }
    }
    
    // Create random region within the image frame
    private func createRandomRegion(frameWidth: Int, frameHeight: Int) -> CGRect {
        let maxWidth = Int(Double(frameWidth) * 0.3)
        let maxHeight = Int(Double(frameHeight) * 0.3)
        
        let left = Int.random(in: 0..<frameWidth - maxWidth)
        let top = Int.random(in: 0..<frameHeight - maxHeight)
        
        let width = max(50, Int.random(in: 50..<maxWidth))
        let height = max(50, Int.random(in: 50..<maxHeight))
        
        return CGRect(x: left, y: top, width: width, height: height)
    }
    
    // Crop the image based on the provided CGRect
    private func cropImage(image: UIImage, rect: CGRect) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        let x = Int(rect.origin.x)
        let y = Int(rect.origin.y)
        let width = Int(rect.size.width)
        let height = Int(rect.size.height)
        
        let croppedCGImage = cgImage.cropping(to: CGRect(x: x, y: y, width: width, height: height))
        if let croppedCGImage = croppedCGImage {
            return UIImage(cgImage: croppedCGImage)
        }
        return nil
    }
}

// Helper structs
struct FoodRegion {
    let rect: CGRect
    let imageFragment: UIImage
    let nutritionInfo: NutritionInfo
}

struct NutritionInfo {
    let name: String
    let calories: Int
}
