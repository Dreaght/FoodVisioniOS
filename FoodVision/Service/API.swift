import Foundation
import SwiftUI
import UIKit
import FirebaseAuth


extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

class API {
    let URL_BASE = "http://45.93.136.230:8081"
    @AppStorage("height") var height = 170
    @AppStorage("currweight") var currweight = 70
    @AppStorage("birthdate") var bday = Date()
    @AppStorage("sex") var gender = "Male"
    @AppStorage("targetweight") var targetweight = 60
    let currentUser = Auth.auth().currentUser

    
    func upload(_ imageData: Data) async throws -> [Region] {
        guard let currentUser = currentUser else {
            throw ParsingError.noUser
        }
        
        let token = try await currentUser.getIDToken(forcingRefresh: false)
        let url = URL(string: "\(URL_BASE)/upload")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"food.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Debug logs
        print("[Upload] URL: \(url)")
        print("[Upload] Token: \(token.prefix(10))...")
        print("[Upload] Boundary: \(boundary)")
        print("[Upload] Image size: \(imageData.count) bytes")
        print("[Upload] Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 120
        config.timeoutIntervalForResource = 300
        let session = URLSession(configuration: config)
        let (data, response) = try await session.data(for: request)

        // Add response debug
        if let httpResponse = response as? HTTPURLResponse {
            print("[Upload] Status Code: \(httpResponse.statusCode)")
        }
        print("[Upload] Raw Response Body: \(String(data: data, encoding: .utf8) ?? "nil")")
        
        try validate(response)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(UploadResponse.self, from: data).regions
    }
    
    func chat(_ pages: [DiaryDailyDataPoint],_ question: String) async throws -> String {
        print("Starting chat")
        
        guard let currentUser = currentUser else {
            print("No user is signed in.")
            throw ParsingError.noUser
        }

        // Prepare the payload (like curl would do)
        let payload = try prepareChatPayload(pages: pages, question: question)
        print(payload)
        let token = try await currentUser.getIDToken(forcingRefresh: false)
        let url = URL(string: "\(URL_BASE)/chat")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpBody = payload.data(using: .utf8)
        print("[chat] Token: \(token.prefix(10))...")
        // Send the request
        let (data, response) = try await URLSession.shared.data(for: request)
        // Validate the response
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        // Convert the response data to a String and return
        if let responseString = String(data: data, encoding: .utf8) {
            return responseString
        } else {
            throw URLError(.cannotParseResponse)
        }
    }


    func report(_ pages: [DiaryDailyDataPoint]) async throws -> UIImage {
        // Upload and get the response data
        guard let currentUser = currentUser else {
            print("No user is signed in.")
            throw ParsingError.noUser
        }

        // Prepare the payload as a string (similar to the `curl --data "your_payload"`)
        let payload = try preparePayload(pages: pages)

        let token = try await currentUser.getIDToken(forcingRefresh: false)
        let url = URL(string: "\(URL_BASE)/report")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpBody = payload.data(using: .utf8)

        // Send the request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Validate the response to ensure it's an image
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        // Check if the response data can be converted to a UIImage
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "ImageErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not convert data to UIImage"])
        }
        
        return image
    }

    private func prepareChatPayload(pages: [DiaryDailyDataPoint], question: String) throws -> String {
        // Get today's date
        let calendar = Calendar.current
        let today = Date()
        
        // Prepare the date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Create an array to hold the last 7 days' data
        var reportPages: [ReportPage] = []
        
        // Loop through the last 7 days
        for i in 0..<7 {
            // Calculate the date for the current iteration
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                let dateString = dateFormatter.string(from: date)
                
                // Find the corresponding page for that date
                if let page = pages.first(where: { $0.date == dateString }) {
                    // If found, map the data
                    reportPages.append(ReportPage(
                        pageData: MealsData(
                            breakfast: page.breakfast.map { MealDataPointResponse(name: $0.foodName, calories: Double($0.calories), transFat: $0.transFat, saturatedFat: $0.saturatedFat, totalFat: $0.totalFat, protein: $0.protein, sugar: $0.sugar, cholesterol: $0.cholesterol, sodium: Double($0.sodium), calcium: Double($0.calcium), iodine: Double($0.iodine), iron: Double($0.iron), magnesium: Double($0.magnesium), potassium: Double($0.potassium), zinc: Double($0.zinc), vitaminA: Double($0.vitaminA), vitaminC: Double($0.vitaminC), vitaminD: Double($0.vitaminD), vitaminE: Double($0.vitaminE), vitaminK: Double($0.vitaminK), vitaminB1: $0.vitaminB1, vitaminB2: $0.vitaminB2, vitaminB3: Double($0.vitaminB3), vitaminB5: Double($0.vitaminB5), vitaminB6: $0.vitaminB6, vitaminB7: Double($0.vitaminB7), vitaminB9: Double($0.vitaminB9), vitaminB12: $0.vitaminB12) },
                            lunch: page.lunch.map { MealDataPointResponse(name: $0.foodName, calories: Double($0.calories), transFat: $0.transFat, saturatedFat: $0.saturatedFat, totalFat: $0.totalFat, protein: $0.protein, sugar: $0.sugar, cholesterol: $0.cholesterol, sodium: Double($0.sodium), calcium: Double($0.calcium), iodine: Double($0.iodine), iron: Double($0.iron), magnesium: Double($0.magnesium), potassium: Double($0.potassium), zinc: Double($0.zinc), vitaminA: Double($0.vitaminA), vitaminC: Double($0.vitaminC), vitaminD: Double($0.vitaminD), vitaminE: Double($0.vitaminE), vitaminK: Double($0.vitaminK), vitaminB1: $0.vitaminB1, vitaminB2: $0.vitaminB2, vitaminB3: Double($0.vitaminB3), vitaminB5: Double($0.vitaminB5), vitaminB6: $0.vitaminB6, vitaminB7: Double($0.vitaminB7), vitaminB9: Double($0.vitaminB9), vitaminB12: $0.vitaminB12) },
                            dinner: page.dinner.map { MealDataPointResponse(name: $0.foodName, calories: Double($0.calories), transFat: $0.transFat, saturatedFat: $0.saturatedFat, totalFat: $0.totalFat, protein: $0.protein, sugar: $0.sugar, cholesterol: $0.cholesterol, sodium: Double($0.sodium), calcium: Double($0.calcium), iodine: Double($0.iodine), iron: Double($0.iron), magnesium: Double($0.magnesium), potassium: Double($0.potassium), zinc: Double($0.zinc), vitaminA: Double($0.vitaminA), vitaminC: Double($0.vitaminC), vitaminD: Double($0.vitaminD), vitaminE: Double($0.vitaminE), vitaminK: Double($0.vitaminK), vitaminB1: $0.vitaminB1, vitaminB2: $0.vitaminB2, vitaminB3: Double($0.vitaminB3), vitaminB5: Double($0.vitaminB5), vitaminB6: $0.vitaminB6, vitaminB7: Double($0.vitaminB7), vitaminB9: Double($0.vitaminB9), vitaminB12: $0.vitaminB12) }
                        ),
                        date: page.date
                    ))
                } else {
                    // If not found, append an empty pageData
                    reportPages.append(ReportPage(pageData: MealsData(breakfast: [], lunch: [], dinner: []), date: dateString))
                }
            }
        }
        
        // Create a UserProfile instance
        let userData = populateUserProfile()
        
        struct ChatPayload: Codable {
            let data: [ReportPage]
            let question: String
            let userData: UserProfile // Include user data
        }
        
        // Create the payload
        let payload = ChatPayload(data: reportPages, question: question, userData: userData)
        
        // Serialize to JSON
        let jsonData = try JSONEncoder().encode(payload)
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            throw NSError(domain: "EncodingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode JSON"])
        }
        
        return jsonString
    }
    
    func calculateAge(birthDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: birthDate, to: Date())
        return components.year ?? 0
    }
    
    private func preparePayload(pages: [DiaryDailyDataPoint]) throws -> String {

        let userData = populateUserProfile()
        // Map `DiaryDailyDataPoint` to `ReportPage`
        let reportPages = pages.map { page in
            ReportPage(
                pageData: MealsData(breakfast: page.breakfast.map {
                    MealDataPointResponse(name: $0.foodName, calories: Double($0.calories), transFat: $0.transFat,
                                          saturatedFat: $0.saturatedFat, totalFat: $0.totalFat, protein: $0.protein,
                                          sugar: $0.sugar, cholesterol: $0.cholesterol, sodium: Double($0.sodium),
                                          calcium: Double($0.calcium), iodine: Double($0.iodine), iron: Double($0.iron),
                                          magnesium: Double($0.magnesium), potassium: Double($0.potassium),
                                          zinc: Double($0.zinc), vitaminA: Double($0.vitaminA), vitaminC: Double($0.vitaminC),
                                          vitaminD: Double($0.vitaminD), vitaminE: Double($0.vitaminE),
                                          vitaminK: Double($0.vitaminK), vitaminB1: $0.vitaminB1, vitaminB2: $0.vitaminB2,
                                          vitaminB3: Double($0.vitaminB3), vitaminB5: Double($0.vitaminB5),
                                          vitaminB6: $0.vitaminB6, vitaminB7: Double($0.vitaminB7),
                                          vitaminB9: Double($0.vitaminB9), vitaminB12: $0.vitaminB12) },
                                    lunch: page.lunch.map {
                                        MealDataPointResponse(name: $0.foodName, calories: Double($0.calories), transFat: $0.transFat,
                                                              saturatedFat: $0.saturatedFat, totalFat: $0.totalFat, protein: $0.protein,
                                                              sugar: $0.sugar, cholesterol: $0.cholesterol, sodium: Double($0.sodium),
                                                              calcium: Double($0.calcium), iodine: Double($0.iodine), iron: Double($0.iron),
                                                              magnesium: Double($0.magnesium), potassium: Double($0.potassium),
                                                              zinc: Double($0.zinc), vitaminA: Double($0.vitaminA), vitaminC: Double($0.vitaminC),
                                                              vitaminD: Double($0.vitaminD), vitaminE: Double($0.vitaminE),
                                                              vitaminK: Double($0.vitaminK), vitaminB1: $0.vitaminB1, vitaminB2: $0.vitaminB2,
                                                              vitaminB3: Double($0.vitaminB3), vitaminB5: Double($0.vitaminB5),
                                                              vitaminB6: $0.vitaminB6, vitaminB7: Double($0.vitaminB7),
                                                              vitaminB9: Double($0.vitaminB9), vitaminB12: $0.vitaminB12) },
                                    dinner: page.dinner.map {
                                        MealDataPointResponse(name: $0.foodName, calories: Double($0.calories), transFat: $0.transFat,
                                                              saturatedFat: $0.saturatedFat, totalFat: $0.totalFat, protein: $0.protein,
                                                              sugar: $0.sugar, cholesterol: $0.cholesterol, sodium: Double($0.sodium),
                                                              calcium: Double($0.calcium), iodine: Double($0.iodine), iron: Double($0.iron),
                                                              magnesium: Double($0.magnesium), potassium: Double($0.potassium),
                                                              zinc: Double($0.zinc), vitaminA: Double($0.vitaminA), vitaminC: Double($0.vitaminC),
                                                              vitaminD: Double($0.vitaminD), vitaminE: Double($0.vitaminE),
                                                              vitaminK: Double($0.vitaminK), vitaminB1: $0.vitaminB1, vitaminB2: $0.vitaminB2,
                                                              vitaminB3: Double($0.vitaminB3), vitaminB5: Double($0.vitaminB5),
                                                              vitaminB6: $0.vitaminB6, vitaminB7: Double($0.vitaminB7),
                                                              vitaminB9: Double($0.vitaminB9), vitaminB12: $0.vitaminB12) }),
                date: page.date
            )
        }

        struct ReportPayload: Codable {
            let data: [ReportPage]
            let userData: UserProfile
        }
        
        let payload = ReportPayload(data: reportPages, userData: userData)
        
        let jsonData = try JSONEncoder().encode(payload)
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            throw NSError(domain: "EncodingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode JSON"])
        }

        return jsonString
    }
    
    // Helper to handle multiple file uploads with Firebase token
    private func uploadMultiple(_ pages: [DiaryDailyDataPoint], endpoint: String) async throws -> (Data, URLResponse) {
        do {
            let token = try await currentUser!.getIDToken(forcingRefresh: true)
            let url = URL(string: "\(URL_BASE)\(endpoint)")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            // Populate user profile
            let userProfile = populateUserProfile()
            
            let encoder = JSONEncoder()
            // Create a combined request object
            let requestBody = ReportRequest(
                userProfile: userProfile,
                data: makePages(pages: pages)
            )
            
            // Serialize to JSON
            let jsonData = try encoder.encode(requestBody)
            request.httpBody = jsonData
            
            logRequest(request)
            
            // Send the request
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Log the response for debugging
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
                if let responseBody = String(data: data, encoding: .utf8) {
                    print("Response body: \(responseBody)")
                }
            }
            
            // Validate the response
            try validate(response)
            
            return (data, response)
        } catch {
            print("Error during token retrieval or request: \(error.localizedDescription)")
            throw ParsingError.invalidData
        }
    }

    func logRequest(_ request: URLRequest) {
        print("HTTP Method: \(request.httpMethod ?? "N/A")")
        print("URL: \(request.url?.absoluteString ?? "N/A")")
        
        if let headers = request.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }
        
        if let body = request.httpBody {
            if let bodyString = String(data: body, encoding: .utf8) {
                print("Body: \(bodyString)")
            } else {
                print("Body: [Data not convertible to String]")
            }
        }
    }
    
    
    // Helper to validate HTTP responses
    private func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
    
    private func populateUserProfile() -> UserProfile{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: bday)
        
        let userData = UserProfile(gender: gender, weight: currweight, height: height, age: calculateAge(birthDate: bday), goalWeight: targetweight, birthDate: dateString)
        // Map `DiaryDailyDataPoint` to `ReportPage`
        return userData
    }
    
    private func makePages(pages: [DiaryDailyDataPoint]) -> [DiaryDailyPageForRequest] {
        var result: [DiaryDailyPageForRequest] = []
        for i in pages {
            let page = DiaryDailyPageForRequest(date: i.date, breakfast: mealDataPointToRequest(meal: i.breakfast), lunch: mealDataPointToRequest(meal: i.lunch), dinner: mealDataPointToRequest(meal: i.dinner))
            result.append(page)
        }
        return result
    }
    
    private func mealDataPointToRequest(meal: [MealDataPoint]) -> [MealDataPointResponse] {
        var result: [MealDataPointResponse] = []
        for i in meal {
            let food = MealDataPointResponse(name: i.foodName, calories: Double(i.calories), transFat: i.transFat, saturatedFat: i.saturatedFat, totalFat: i.totalFat, protein: i.protein, sugar: i.sugar, cholesterol: i.cholesterol, sodium: Double(i.sodium), calcium: Double(i.calcium), iodine: Double(i.iodine), iron: Double(i.iron), magnesium: Double(i.magnesium), potassium: Double(i.potassium), zinc: Double(i.zinc), vitaminA: Double(i.vitaminA), vitaminC: Double(i.vitaminC), vitaminD: Double(i.vitaminD), vitaminE: Double(i.vitaminE), vitaminK: Double(i.vitaminK), vitaminB1: i.vitaminB1, vitaminB2: i.vitaminB2, vitaminB3: Double(i.vitaminB3), vitaminB5: Double(i.vitaminB5), vitaminB6: i.vitaminB6, vitaminB7: Double(i.vitaminB7), vitaminB9: Double(i.vitaminB9), vitaminB12: i.vitaminB12)
            result.append(food)
        }
        return result
    }
}

enum ParsingError: Error {
    case invalidData
    case noUser
}

struct UserProfile: Codable{
    let gender: String
    let weight: Int
    let height: Int
    let age: Int
    let goalWeight: Int
    let birthDate: String
}

struct ReportPage: Codable {
    let pageData: MealsData
    let date: String
}

struct MealsData: Codable {
    let breakfast: [MealDataPointResponse]
    let lunch: [MealDataPointResponse]
    let dinner: [MealDataPointResponse]
}

struct DiaryDailyPageForRequest: Codable {
    let date: String
    let breakfast: [MealDataPointResponse]
    let lunch: [MealDataPointResponse]
    let dinner: [MealDataPointResponse]
}

struct ReportRequest: Codable {
    let userProfile: UserProfile
    let data: [DiaryDailyPageForRequest]
}

struct UploadResponse: Codable {
    let regions: [Region]
}

struct Region: Codable {
    let start: Coordinates
    let end: Coordinates
    let nutrition: MealDataPointResponse
}

struct Coordinates: Codable {
    let X: Double
    let Y: Double
}

struct MealDataPointResponse: Codable {
    let name: String // name of the food
    
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
}
