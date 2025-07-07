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
    case unauthenticated
    
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
        let (data, urlResponse) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            throw FayError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 401:
            //Handle the case of token is stored but has expired
            throw FayError.unauthenticated
        default:
            break
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
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

    func isAuthorized() async -> Bool {
        do {
            let _ = try await authManager.validToken()
        }
        catch {
            return false
        }
        return true
    }
}
