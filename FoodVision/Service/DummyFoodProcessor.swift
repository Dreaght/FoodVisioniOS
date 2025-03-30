import Foundation
import UIKit

// DummyFoodProcessor class that detects food regions in an image
class DummyFoodProcessor {
    
    private let image: UIImage
    private var foodRegions: [(Int, Int, Int, Int)] = []
    init(frame: UIImage) {
        self.image = frame
    }
    
    // Asynchronously detects food regions from the image
    func detectFoods() -> [(Int, Int, Int, Int)] {
        // Get the frame dimensions
        let frameWidth = UIScreen.main.bounds.width
        let frameHeight = 400
        
        // Generate 3 random regions
        foodRegions = (0..<3).map { _ in
            createRandomRegion(frameWidth: Int(frameWidth), frameHeight: frameHeight)
        }
        
        return foodRegions
    }
    
    func cropSelectedFood(seletedIndices: [Int]) -> [FoodRegion] {
        // Extract fragments based on the regions
        var result: [FoodRegion] = []
        
        for index in seletedIndices {
            let region = foodRegions[index]
            let rect = CGRect(x: CGFloat((region.0 + region.2) / 2), y: CGFloat((region.1 + region.3) / 2),
                                          width: CGFloat((region.2 - region.0)), height: CGFloat((region.3 - region.1)))
            if let fragment = cropImage(image: image, rect: rect) {
                let foodRegion = FoodRegion(rect: rect, imageFragment: fragment, nutritionInfo: NutritionInfo(name: "Sample Food", calories: 100))
                result.append(foodRegion)
            }
        }
        return result
    }
    
    // Create random region within the image frame
    private func createRandomRegion(frameWidth: Int, frameHeight: Int) -> (Int, Int, Int, Int) {
        let maxWidth = Int(Double(frameWidth) * 0.3)
        let maxHeight = Int(Double(frameHeight) * 0.3)
        
        // Ensure maxWidth and maxHeight are at least 50 to prevent issues
        let constrainedMaxWidth = max(50, maxWidth)
        let constrainedMaxHeight = max(50, maxHeight)
        
        let x1 = Int.random(in: 0..<(frameWidth - constrainedMaxWidth))
        let y1 = Int.random(in: 0..<(frameHeight - constrainedMaxHeight))
        
        let width = max(50, Int.random(in: 50...constrainedMaxWidth))
        let height = max(50, Int.random(in: 50...constrainedMaxHeight))
        
        let x2 = x1 + width // Bottom-right x-coordinate
        let y2 = y1 + height // Bottom-right y-coordinate
        
        return (x1, y1, x2, y2) // Return the tuple with x1, y1, x2, y2
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
