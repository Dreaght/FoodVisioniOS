import Foundation
import SwiftData

@Model
class DiaryDailyDataPoint: Identifiable, ObservableObject {
    static private var existingDates: [String: DiaryDailyDataPoint] = [:] // Dictionary to track existing instances
    
    private init(date: String) {
        self.date = date
    }
    
    static func create(date: String) -> DiaryDailyDataPoint {
        if let existingInstance = existingDates[date] {
            // Return the existing instance
            return existingInstance
        }
    
        // Create a new instance and store it
        let newInstance = DiaryDailyDataPoint(date: date)
        existingDates[date] = newInstance
        return newInstance
    }
    
    var id = UUID()
    @Attribute(.unique) var date: String = ""
    var breakfast: [MealDataPoint] = []
    var lunch: [MealDataPoint] = []
    var dinner: [MealDataPoint] = []
    
    // basic nutritional information about the food
    var calories: Double = 0           // in kcal
    var transFat: Double = 0        // in grams g
    var saturatedFat: Double = 0    // in grams g
    var totalFat: Double = 0        // in grams g
    var protein: Double = 0         // in grams g
    var sugar: Double = 0           // in grams g
    var cholesterol: Double = 0     // in milligrams mg
    var sodium: Double = 0             // in milligrams mg
    
    // minerals
    // https://nutritionsource.hsph.harvard.edu/vitamins/
    var calcium: Double = 0            // in milligrams mg
    var iodine: Double = 0             // in micrograms mcg
    var iron: Double = 0               // in milligrams mg
    var magnesium: Double = 0          // in milligrams mg
    var potassium: Double = 0          // in milligrams mg
    var zinc: Double = 0               // in milligrams mg
    
    // vitamins
    // https://www.mealpro.net/blog/13-essential-vitamins/
    var vitaminA: Double = 0           // in micrograms mcg
    var vitaminC: Double = 0           // in milligrams mg
    var vitaminD: Double = 0           // in Internation Units IU
    var vitaminE: Double = 0           // in milligrams mg
    var vitaminK: Double = 0           // in milligrams mg
    var vitaminB1: Double = 0       // in milligrams mg
    var vitaminB2: Double = 0       // in milligrams mg
    var vitaminB3: Double = 0          // in milligrams mg
    var vitaminB5: Double = 0          // in milligrams mg
    var vitaminB6: Double = 0       // in milligrams mg
    var vitaminB7: Double = 0          // in micrograms mcg
    var vitaminB9: Double = 0          // in micrograms mcg
    var vitaminB12: Double = 0      // in micrograms mcg
    
    func calculateDailyNutrition() {
        setAllToZero()
        for i in breakfast {
            addToDaily(meal: i)
        }
        for i in lunch {
            addToDaily(meal: i)
        }
        for i in dinner {
            addToDaily(meal: i)
        }
    }
    
    func addToBreakfast(meal: MealDataPoint) {
        self.breakfast.append(meal)
    }
    
    func addToLunch(meal: MealDataPoint) {
        self.lunch.append(meal)
    }
    
    func addToDinner(meal: MealDataPoint) {
        self.dinner.append(meal)
    }
    
    func deleteFromBreakfast(withID id: UUID) {
        breakfast.removeAll { $0.id == id }
    }
    
    func deleteFromLunch(withID id: UUID) {
        lunch.removeAll { $0.id == id }
    }
    
    func deleteFromDinner(withID id: UUID) {
        dinner.removeAll { $0.id == id }
    }
    
    func addToDaily(meal: MealDataPoint) {
        self.calories += meal.calories
        self.transFat += meal.transFat
        self.saturatedFat += meal.saturatedFat
        self.totalFat += meal.totalFat
        self.protein += meal.protein
        self.sugar += meal.sugar
        self.cholesterol += meal.cholesterol
        self.sodium += meal.sodium
        
        self.calcium += meal.calcium
        self.iodine += meal.iodine
        self.iron += meal.iron
        self.magnesium += meal.magnesium
        self.potassium += meal.potassium
        self.zinc += meal.zinc
        
        self.vitaminA += meal.vitaminA
        self.vitaminC += meal.vitaminC
        self.vitaminD += meal.vitaminD
        self.vitaminE += meal.vitaminE
        self.vitaminK += meal.vitaminK
        self.vitaminB1 += meal.vitaminB1
        self.vitaminB2 += meal.vitaminB2
        self.vitaminB3 += meal.vitaminB3
        self.vitaminB5 += meal.vitaminB5
        self.vitaminB6 += meal.vitaminB6
        self.vitaminB7 += meal.vitaminB7
        self.vitaminB9 += meal.vitaminB9
        self.vitaminB12 += meal.vitaminB12
    }
    
    func removeFromDaily(meal: MealDataPoint) {
        self.calories -= meal.calories
        self.transFat -= meal.transFat
        self.saturatedFat -= meal.saturatedFat
        self.totalFat -= meal.totalFat
        self.protein -= meal.protein
        self.sugar -= meal.sugar
        self.cholesterol -= meal.cholesterol
        self.sodium -= meal.sodium
        
        self.calcium -= meal.calcium
        self.iodine -= meal.iodine
        self.iron -= meal.iron
        self.magnesium -= meal.magnesium
        self.potassium -= meal.potassium
        self.zinc -= meal.zinc
        
        self.vitaminA -= meal.vitaminA
        self.vitaminC -= meal.vitaminC
        self.vitaminD -= meal.vitaminD
        self.vitaminE -= meal.vitaminE
        self.vitaminK -= meal.vitaminK
        self.vitaminB1 -= meal.vitaminB1
        self.vitaminB2 -= meal.vitaminB2
        self.vitaminB3 -= meal.vitaminB3
        self.vitaminB5 -= meal.vitaminB5
        self.vitaminB6 -= meal.vitaminB6
        self.vitaminB7 -= meal.vitaminB7
        self.vitaminB9 -= meal.vitaminB9
        self.vitaminB12 -= meal.vitaminB12
    }
    
    func setAllToZero() {
        self.calories = 0
        self.transFat = 0
        self.saturatedFat = 0
        self.totalFat = 0
        self.protein = 0
        self.sugar = 0
        self.cholesterol = 0
        self.sodium = 0
        
        self.calcium = 0
        self.iodine = 0
        self.iron = 0
        self.magnesium = 0
        self.potassium = 0
        self.zinc = 0
        
        self.vitaminA = 0
        self.vitaminC = 0
        self.vitaminD = 0
        self.vitaminE = 0
        self.vitaminK = 0
        self.vitaminB1 = 0
        self.vitaminB2 = 0
        self.vitaminB3 = 0
        self.vitaminB5 = 0
        self.vitaminB6 = 0
        self.vitaminB7 = 0
        self.vitaminB9 = 0
        self.vitaminB12 = 0
    }
}
