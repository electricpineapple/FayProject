//

import Foundation

struct LoginRequestBody: Codable {
    let username: String
    let password: String
}

struct AccessToken: Codable {
    let access: String
}

protocol Authentication {
    func login(username: String, password: String) async throws
    func logout() async throws
}

class UnauthNetworking: Authentication {
    private let tokenStorage: TokenStorage
    
    init(tokenStorage: TokenStorage) {
        self.tokenStorage = tokenStorage
    }
    
    func loadUnauthorized<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try decoder.decode(T.self, from: data)

        return response
    }
    
    func login(username: String, password: String) async throws {
        let endpoint = "https://node-api-for-candidates.onrender.com/signin"
        
        guard let url = URL(string: endpoint) else {
            throw FayError.invalidURL
        }
        
        let body = LoginRequestBody(username: username, password: password)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FayError.invalidResponse
        }
        
        let token = try JSONDecoder().decode(Token.self, from: data)
        //Could return the expiration time in the token payload as well to avoid manually entering time here
        //Could also just round trip the 401 but we can save the call if we know its expired locally
        let accessDate = Date().addingTimeInterval(15 * 60)
        
        let datedToken = Token(
            access: token.access,
            accessExpires: accessDate,
        )
        
        try await tokenStorage.saveTokenToStorage(datedToken)
    }
    
    func logout() async throws {
        try await tokenStorage.removeTokenFromStorage()
    }
}
