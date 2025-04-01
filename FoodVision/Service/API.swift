import Foundation
import SwiftUI
import UIKit
import FirebaseAuth

class API {
    let URL_BASE = "http://45.93.136.230:8080"
    @AppStorage("height") var height = 170
    @AppStorage("currweight") var currweight = 70
    @AppStorage("birthdate") var bday = Date()
    @AppStorage("gender") var gender = "Male"
    @AppStorage("targetweight") var targetweight = 60
    // Upload a single image as raw bytes
    func upload(_ image: Data) async throws -> MealDataPoint {
        let url = URL(string: "\(URL_BASE)/upload/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.httpBody = image

        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response)
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let uiImage = UIImage(data: image)
            let decodedData = try decoder.decode(MealDataPointResponse.self, from: data)
            return MealDataPoint(image: uiImage, foodName: decodedData.foodName, calories: decodedData.calories, transFat: decodedData.transFat,
                                 saturatedFat: decodedData.saturatedFat, totalFat: decodedData.totalFat, protein: decodedData.protein,
                                 sugar: decodedData.sugar, cholesterol: decodedData.cholesterol, sodium: decodedData.sodium,
                                 calcium: decodedData.calcium, iodine: decodedData.iodine, iron: decodedData.iron,
                                 magnesium: decodedData.magnesium, potassium: decodedData.potassium, zinc: decodedData.zinc,
                                 vitaminA: decodedData.vitaminA, vitaminC: decodedData.vitaminC, vitaminD: decodedData.vitaminD,
                                 vitaminE: decodedData.vitaminE, vitaminK: decodedData.vitaminK, vitaminB1: decodedData.vitaminB1,
                                 vitaminB2: decodedData.vitaminB2, vitaminB3: decodedData.vitaminB3, vitaminB5: decodedData.vitaminB5,
                                 vitaminB6: decodedData.vitaminB6, vitaminB7: decodedData.vitaminB7, vitaminB9: decodedData.vitaminB9, vitaminB12: decodedData.vitaminB12)
        } catch {
            throw ParsingError.invalidData
        }
    }

    func chat(_ pages: [DiaryDailyDataPoint]) async throws -> String {
        return try await uploadMultiple(pages, endpoint: "/chat/")
    }

    func report(_ pages: [DiaryDailyDataPoint]) async throws -> String {
        return try await uploadMultiple(pages, endpoint: "/report/")
    }

    // Helper to handle multiple file uploads with Firebase token
    private func uploadMultiple(_ pages: [DiaryDailyDataPoint], endpoint: String) async throws -> String {
        let url = URL(string: "\(URL_BASE)\(endpoint)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Populate user profile
        let userProfile = populateUserProfile()
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        // Create a combined request object
        let requestBody = ReportRequest(
            userProfile: userProfile,
            pages: makePages(pages: pages)
        )

        // Serialize to JSON
        let jsonData = try encoder.encode(requestBody)
        request.httpBody = jsonData

        // Send the request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Validate the response
        try validate(response)

        // Handle the response data if needed
        if let responseString = String(data: data, encoding: .utf8) {
            return responseString
        } else {
            throw URLError(.cannotParseResponse)
        }
    }

    // Helper to validate HTTP responses
    private func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
    
    private func populateUserProfile() -> UserProfile{
        return UserProfile(height: height, currentWeight: currweight, birthday: bday, gender: gender, targetWeight: targetweight)
    }
    
    private func makePages(pages: [DiaryDailyDataPoint]) -> [DiaryDailyPageForRequest] {
        var result: [DiaryDailyPageForRequest] = []
        for i in pages {
            let page = DiaryDailyPageForRequest(date: i.date, calories: i.calories, transFat: i.transFat, saturatedFat: i.saturatedFat,
                                                totalFat: i.totalFat, protein: i.protein, sugar: i.sugar, cholesterol: i.cholesterol,
                                                sodium: i.sodium, calcium: i.calcium, iodine: i.iodine, iron: i.iron, magnesium: i.magnesium,
                                                potassium: i.potassium, zinc: i.zinc, vitaminA: i.vitaminA, vitaminC: i.vitaminC,
                                                vitaminD: i.vitaminD, vitaminE: i.vitaminE, vitaminK: i.vitaminK, vitaminB1: i.vitaminB1,
                                                vitaminB2: i.vitaminB2, vitaminB3: i.vitaminB3, vitaminB5: i.vitaminB5, vitaminB6: i.vitaminB6,
                                                vitaminB7: i.vitaminB7, vitaminB9: i.vitaminB9, vitaminB12: i.vitaminB12)
            result.append(page)
        }
        return result
    }
}

enum ParsingError: Error {
    case invalidData
}

struct UserProfile: Codable{
    let height: Int
    let currentWeight: Int
    let birthday: Date
    let gender: String
    let targetWeight: Int
}

struct DiaryDailyPageForRequest: Codable {
    let date: String
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
}

struct ReportRequest: Codable {
    let userProfile: UserProfile
    let pages: [DiaryDailyPageForRequest]
}


struct MealDataPointResponse: Codable {
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
}
