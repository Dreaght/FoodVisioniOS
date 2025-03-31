import Foundation
import FirebaseAuth

class API {
    let URL_BASE = "http://45.93.136.230:8080"

    // Upload a single image as raw bytes
    func upload(_ image: Data) async throws -> String {
        let url = URL(string: "\(URL_BASE)/upload/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.httpBody = image

        request.setValue(try await getFirebaseToken(), forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response)
        return String(decoding: data, as: UTF8.self)
    }

    // Send multiple images using multipart/form-data
    func chat(_ images: [Data]) async throws -> String {
        return try await uploadMultiple(images, endpoint: "/chat/")
    }

    func report(_ images: [Data]) async throws -> String {
        return try await uploadMultiple(images, endpoint: "/report/")
    }

    // Helper to handle multiple file uploads with Firebase token
    private func uploadMultiple(_ images: [Data], endpoint: String) async throws -> String {
        let url = URL(string: "\(URL_BASE)\(endpoint)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(try await getFirebaseToken(), forHTTPHeaderField: "Authorization")

        var body = Data()
        for (index, imageData) in images.enumerated() {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\(index)\"; filename=\"image\(index).jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response)
        return String(decoding: data, as: UTF8.self)
    }

    // Get Firebase authentication token
    private func getFirebaseToken() async throws -> String {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
        }
        return try await withCheckedThrowingContinuation { continuation in
            user.getIDToken { token, error in
                if let token = token {
                    continuation.resume(returning: "Bearer \(token)")
                } else {
                    continuation.resume(throwing: error ?? NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve token"]))
                }
            }
        }
    }

    // Helper to validate HTTP responses
    private func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
}
