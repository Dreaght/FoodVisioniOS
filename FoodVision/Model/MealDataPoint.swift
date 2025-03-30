import Foundation
import UIKit

struct MealDataPoint {
    let id = UUID()
    var image: UIImage // image of the food
    let foodName: String // name of the food
    
    // basic nutritional information about the food
    let calories: Int           // in kcal
    let transFat: Double        // in grams g
    let saturatedFat: Double    // in grams g
    let totalFat: Double        // in grams g
    let protein: Double         // in grams g
    let sugar: Double           // in grams g
    let cholesterol: Double     // in milligrams mg
    let sodium: Int             // in milligrams mg
    
    // minerals
    // https://nutritionsource.hsph.harvard.edu/vitamins/
    let calcium: Int            // in milligrams mg
    let iodine: Int             // in micrograms mcg
    let iron: Int               // in milligrams mg
    let magnesium: Int          // in milligrams mg
    let potassium: Int          // in milligrams mg
    let zinc: Int               // in milligrams mg
    
    // vitamins
    // https://www.mealpro.net/blog/13-essential-vitamins/
    let vitaminA: Int           // in micrograms mcg
    let vitaminC: Int           // in milligrams mg
    let vitaminD: Int           // in Internation Units IU
    let vitaminE: Int           // in milligrams mg
    let vitaminK: Int           // in milligrams mg
    let vitaminB1: Double       // in milligrams mg
    let vitaminB2: Double       // in milligrams mg
    let vitaminB3: Int          // in milligrams mg
    let vitaminB5: Int          // in milligrams mg
    let vitaminB6: Double       // in milligrams mg
    let vitaminB7: Int          // in micrograms mcg
    let vitaminB9: Int          // in micrograms mcg
    let vitaminB12: Double      // in micrograms mcg
}
