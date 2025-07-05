//

import Foundation

//I have implemented refresh tokens in my own apps
//I would extend to return a refresh token as well and shorten the expiration time of the auth token
//Check the git history for the commented out refresh logic

actor AuthManager {
    private var refreshTask: Task<Token, Error>?
    private let unauthNetworking: UnauthNetworking
    private let tokenStorage: TokenStorage
    
    init(unauthNetworking: UnauthNetworking, tokenStorage: TokenStorage) {
        self.unauthNetworking = unauthNetworking
        self.tokenStorage = tokenStorage
    }
        
    func validToken() async throws -> Token? {
        if let handle = refreshTask {
            return try await handle.value
        }
        
        let token = try await tokenStorage.getTokenFromStorage()
        
        if !token.accessExpired() {
            return token
        }
        
        return nil
    }
    
}
