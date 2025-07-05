//

import Foundation

enum FayError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case keychainSaveError
    case keychainRetrieveError
    case keychainDuplicate
    case keychainUpdate
    case keychainDelete
    case missingData
    case tokenRefresh
    case invalidToken
    
    var errorDescription: String? {
            switch self {
                //can give more descriptive text for each error here if needed
            case .missingData:
                return "Data missing"
            default:
                return "Error"
            }
        }
}

class AuthNetworking {
    private let authManager: AuthManager
    
    init(authManager: AuthManager) {
        self.authManager = authManager
    }
    
    //This loadAuthorized with 401 handling is only needed if we implement refresh tokens

    func loadAuthorized<T: Decodable>(_ request: URLRequest, allowRetry: Bool = true) async throws -> T {
        let request = try await authorizedRequest(from: request)
        let (data, _) = try await URLSession.shared.data(for: request)
                        
        
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    return try decoder.decode(T.self, from: data)
                } catch let DecodingError.typeMismatch(type, context) {
                    print("Type mismatch for type \(type): \(context.debugDescription)")
                    print("Coding path: \(context.codingPath)")
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Missing key: \(key.stringValue) – \(context.debugDescription)")
                    print("Coding path: \(context.codingPath)")
                } catch let error {
                    print("Decoding error: \(error)")
                }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try decoder.decode(T.self, from: data)
        
        return response
    }
    
    private func authorizedRequest(from request: URLRequest) async throws -> URLRequest {
        var urlRequest = request
        guard let token = try await authManager.validToken() else {
            throw FayError.invalidToken
        }
        urlRequest.setValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
        return urlRequest
    }
    
    func getAppointments() async throws -> [Appointment] {
        let endpoint = "https://node-api-for-candidates.onrender.com/appointments"
        
        guard let url = URL(string: endpoint) else {
            throw FayError.invalidURL
        }
        
        let urlRequest = URLRequest(url: url)
        let appointments: AppointmentResponse = try await loadAuthorized(urlRequest)
        
        return appointments.appointments
    }

//    func isAuthorized() async -> Bool {
//        do {
//            let _ = try await authManager.validRefreshToken()
//        }
//        catch {
//            return false
//        }
//        return true
//    }
}
