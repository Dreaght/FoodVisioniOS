import Foundation
import UIKit

// DummyFoodProcessor class that detects food regions in an image
class DummyFoodProcessor {
    private let image: UIImage
    private var foodRegions: [(Int, Int, Int, Int)] = []
    private var foodInfos: [MealDataPoint] = []
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
        
        foodInfos = (0..<3).map { _ in
            createRandomFoods()
        }

        return foodRegions
    }
    
    func cropSelectedFood(seletedIndices: [Int]) -> [MealDataPoint] {
        // Extract fragments based on the regions
        var result: [MealDataPoint] = []
        
        for index in seletedIndices {
            let region = foodRegions[index]
            let rect = CGRect(x: CGFloat((region.0 + region.2) / 2), y: CGFloat((region.1 + region.3) / 2),
                                          width: CGFloat((region.2 - region.0)), height: CGFloat((region.3 - region.1)))
            if let fragment = cropImage(image: image, rect: rect) {
                foodInfos[index].image = fragment
                let foodRegion = foodInfos[index]
                result.append(foodRegion)
            }
        }
        return result
    }
    
    // Create random foods
    private func createRandomFoods() -> MealDataPoint {
        let meal = MealDataPoint(
            image: image,
            foodName: "Random Food",
            calories: Int.random(in: 50...600), // Random calories between 50 and 600
            transFat: Double.random(in: 0...5), // Random trans fat between 0 and 5 grams
            saturatedFat: Double.random(in: 0...20), // Random saturated fat between 0 and 20 grams
            totalFat: Double.random(in: 0...50), // Random total fat between 0 and 50 grams
            protein: Double.random(in: 0...50), // Random protein between 0 and 50 grams
            sugar: Double.random(in: 0...50), // Random sugar between 0 and 50 grams
            cholesterol: Double.random(in: 0...300), // Random cholesterol between 0 and 300 mg
            sodium: Int.random(in: 0...2000), // Random sodium between 0 and 2000 mg
            calcium: Int.random(in: 0...1000), // Random calcium between 0 and 1000 mg
            iodine: Int.random(in: 0...150), // Random iodine between 0 and 150 mcg
            iron: Int.random(in: 0...30), // Random iron between 0 and 30 mg
            magnesium: Int.random(in: 0...400), // Random magnesium between 0 and 400 mg
            potassium: Int.random(in: 0...3000), // Random potassium between 0 and 3000 mg
            zinc: Int.random(in: 0...40), // Random zinc between 0 and 40 mg
            vitaminA: Int.random(in: 0...10000), // Random vitamin A between 0 and 10000 IU
            vitaminC: Int.random(in: 0...2000), // Random vitamin C between 0 and 2000 mg
            vitaminD: Int.random(in: 0...1000), // Random vitamin D between 0 and 1000 IU
            vitaminE: Int.random(in: 0...30), // Random vitamin E between 0 and 30 mg
            vitaminK: Int.random(in: 0...300), // Random vitamin K between 0 and 300 mcg
            vitaminB1: Double.random(in: 0...5), // Random vitamin B1 between 0 and 5 mg
            vitaminB2: Double.random(in: 0...5), // Random vitamin B2 between 0 and 5 mg
            vitaminB3: Int.random(in: 0...50), // Random vitamin B3 between 0 and 50 mg
            vitaminB5: Int.random(in: 0...100), // Random vitamin B5 between 0 and 100 mg
            vitaminB6: Double.random(in: 0...5), // Random vitamin B6 between 0 and 5 mg
            vitaminB7: Int.random(in: 0...300), // Random vitamin B7 between 0 and 300 mcg
            vitaminB9: Int.random(in: 0...1000), // Random vitamin B9 between 0 and 1000 mcg
            vitaminB12: Double.random(in: 0...5) // Random vitamin B12 between 0 and 5 mcg
        )
        return meal
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
