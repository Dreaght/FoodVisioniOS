import UIKit

struct MealDataPoint: Codable {
    var id = UUID()
    var imageData: Data? // Store image as Data
    let foodName: String // name of the food
    
    // Nutritional information
    let calories: Int
    let transFat: Double
    let saturatedFat: Double
    let totalFat: Double
    let protein: Double
    let sugar: Double
    let cholesterol: Double
    let sodium: Int
    
    // Minerals
    let calcium: Int
    let iodine: Int
    let iron: Int
    let magnesium: Int
    let potassium: Int
    let zinc: Int
    
    // Vitamins
    let vitaminA: Int
    let vitaminC: Int
    let vitaminD: Int
    let vitaminE: Int
    let vitaminK: Int
    let vitaminB1: Double
    let vitaminB2: Double
    let vitaminB3: Int
    let vitaminB5: Int
    let vitaminB6: Double
    let vitaminB7: Int
    let vitaminB9: Int
    let vitaminB12: Double
    
    // Computed property to convert Data back to UIImage
    var image: UIImage? {
        guard let data = imageData else { return nil }
        return UIImage(data: data)
    }
    
    // Initialize from UIImage
    init(id: UUID = UUID(), image: UIImage?, foodName: String, calories: Int, transFat: Double, saturatedFat: Double, totalFat: Double, protein: Double, sugar: Double, cholesterol: Double, sodium: Int, calcium: Int, iodine: Int, iron: Int, magnesium: Int, potassium: Int, zinc: Int, vitaminA: Int, vitaminC: Int, vitaminD: Int, vitaminE: Int, vitaminK: Int, vitaminB1: Double, vitaminB2: Double, vitaminB3: Int, vitaminB5: Int, vitaminB6: Double, vitaminB7: Int, vitaminB9: Int, vitaminB12: Double) {
        self.id = id
        self.foodName = foodName
        self.calories = calories
        self.transFat = transFat
        self.saturatedFat = saturatedFat
        self.totalFat = totalFat
        self.protein = protein
        self.sugar = sugar
        self.cholesterol = cholesterol
        self.sodium = sodium
        self.calcium = calcium
        self.iodine = iodine
        self.iron = iron
        self.magnesium = magnesium
        self.potassium = potassium
        self.zinc = zinc
        self.vitaminA = vitaminA
        self.vitaminC = vitaminC
        self.vitaminD = vitaminD
        self.vitaminE = vitaminE
        self.vitaminK = vitaminK
        self.vitaminB1 = vitaminB1
        self.vitaminB2 = vitaminB2
        self.vitaminB3 = vitaminB3
        self.vitaminB5 = vitaminB5
        self.vitaminB6 = vitaminB6
        self.vitaminB7 = vitaminB7
        self.vitaminB9 = vitaminB9
        self.vitaminB12 = vitaminB12
        
        // Convert UIImage to Data
        if let image = image {
            self.imageData = image.jpegData(compressionQuality: 1.0)
        } else {
            self.imageData = nil
        }
    }
}
