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
        let (data, urlResponse) = try await URLSession.shared.data(for: request)
        
//        guard let httpResponse = urlResponse as? HTTPURLResponse else {
//            throw FayError.invalidResponse
//        }
//        
//        switch httpResponse.statusCode {
//        case 401:
//            if allowRetry {
//                _ = try await authManager.refreshToken()
//                return try await loadAuthorized(request, allowRetry: false)
//            }
//            
//            throw FayError.invalidToken
//        default:
//            break
//        }
                
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
        urlRequest.setValue("Bearer \(token.access)", forHTTPHeaderField: "Authorization")
        return urlRequest
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
