import UIKit

struct MealDataPoint: Codable {
    var id = UUID()
    var imageData: Data? // Store image as Data
    let foodName: String // name of the food
    
    // Nutritional information
    let calories: Double
    let transFat: Double
    let saturatedFat: Double
    let totalFat: Double
    let protein: Double
    let sugar: Double
    let cholesterol: Double
    let sodium: Double
    
    // Minerals
    let calcium: Double
    let iodine: Double
    let iron: Double
    let magnesium: Double
    let potassium: Double
    let zinc: Double
    
    // Vitamins
    let vitaminA: Double
    let vitaminC: Double
    let vitaminD: Double
    let vitaminE: Double
    let vitaminK: Double
    let vitaminB1: Double
    let vitaminB2: Double
    let vitaminB3: Double
    let vitaminB5: Double
    let vitaminB6: Double
    let vitaminB7: Double
    let vitaminB9: Double
    let vitaminB12: Double
    
    // Computed property to convert Data back to UIImage
    var image: UIImage? {
        guard let data = imageData else { return nil }
        return UIImage(data: data)
    }
    
    // Initialize from UIImage
    init(id: UUID = UUID(), image: UIImage?, foodName: String, calories: Double, transFat: Double, saturatedFat: Double, totalFat: Double, protein: Double, sugar: Double, cholesterol: Double, sodium: Double, calcium: Double, iodine: Double, iron: Double, magnesium: Double, potassium: Double, zinc: Double, vitaminA: Double, vitaminC: Double, vitaminD: Double, vitaminE: Double, vitaminK: Double, vitaminB1: Double, vitaminB2: Double, vitaminB3: Double, vitaminB5: Double, vitaminB6: Double, vitaminB7: Double, vitaminB9: Double, vitaminB12: Double) {
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
