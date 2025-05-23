import Foundation
import UIKit

// BackendFoodProcessor class that detects food regions in an image
class BackendFoodProcessor {
    private let image: UIImage
    var foodRegions: [(Int, Int, Int, Int)] = []
    private var foodInfos: [MealDataPoint] = []
    init(frame: UIImage) {
        self.image = frame
    }
    
    // Asynchronously detects food regions from the image
    func detectFoods() async throws -> [(Int, Int, Int, Int)] {
        let api = API()
        
        // Get image dimensions
        let width = image.size.width
        let height = image.size.height
        
        do {
            let regions: [Region] = try await api.upload(image.pngData()!)
            print("Successfully detected food regions!")
            print(regions)

            for region in regions {
                // Unnormalize
                let x1 = Int(region.start.X * Double(width))
                let y1 = Int(region.start.Y * Double(height))
                let x2 = Int(region.end.X * Double(width))
                let y2 = Int(region.end.Y * Double(height))

                let coords = (x1, y1, x2, y2)
                foodRegions.append(coords)

                let mealInfo = region.nutrition
                let meal = MealDataPoint(
                    image: image,
                    foodName: mealInfo.name,
                    calories: mealInfo.calories,
                    transFat: mealInfo.transFat,
                    saturatedFat: mealInfo.saturatedFat,
                    totalFat: mealInfo.totalFat,
                    protein: mealInfo.protein,
                    sugar: mealInfo.sugar,
                    cholesterol: mealInfo.cholesterol,
                    sodium: mealInfo.sodium,
                    calcium: mealInfo.calcium,
                    iodine: mealInfo.iodine,
                    iron: mealInfo.iron,
                    magnesium: mealInfo.magnesium,
                    potassium: mealInfo.potassium,
                    zinc: mealInfo.zinc,
                    vitaminA: mealInfo.vitaminA,
                    vitaminC: mealInfo.vitaminC,
                    vitaminD: mealInfo.vitaminD,
                    vitaminE: mealInfo.vitaminE,
                    vitaminK: mealInfo.vitaminK,
                    vitaminB1: mealInfo.vitaminB1,
                    vitaminB2: mealInfo.vitaminB2,
                    vitaminB3: mealInfo.vitaminB3,
                    vitaminB5: mealInfo.vitaminB5,
                    vitaminB6: mealInfo.vitaminB6,
                    vitaminB7: mealInfo.vitaminB7,
                    vitaminB9: mealInfo.vitaminB9,
                    vitaminB12: mealInfo.vitaminB12
                )
                foodInfos.append(meal)
            }
        } catch {
            print(error)
            print("Failed to get food infos")
            throw ParsingError.invalidData
        }

        print("returning foodRegions: ")
        print(foodRegions)

        return foodRegions
    }

    
    func cropSelectedFood(seletedIndices: [Int]) -> [MealDataPoint] {
        // Extract fragments based on the regions
        var result: [MealDataPoint] = []
        
        for index in seletedIndices {
            let region = foodRegions[index]
            let rect = CGRect(origin: CGPoint(x: region.0, y: region.1), size: CGSize(width: region.2 - region.0, height: region.3 - region.1))
            if let fragment = cropImage(rect: rect) {
                foodInfos[index].imageData = fragment.toPNGData()
                let foodRegion = foodInfos[index]
                result.append(foodRegion)
            }
        }
        return result
    }
    
    // Crop the image based on the provided CGRect
    private func cropImage(rect: CGRect) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        // if CGImage is oriented then flip x and y
        let cropZone = CGFloat(cgImage.height) == image.size.width ?
                        CGRect(origin: CGPoint(x: rect.origin.y, y: rect.origin.x),
                               size: CGSize(width:  rect.size.height, height: rect.size.width)) : rect
        let croppedCGImage = cgImage.cropping(to: cropZone)
        if let croppedCGImage = croppedCGImage {
            return UIImage(cgImage: croppedCGImage, scale: image.scale, orientation: image.imageOrientation)
        }
        return nil
    }
    
}
