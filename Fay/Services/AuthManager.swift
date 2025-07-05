//

import Foundation

//I have implemented refresh tokens in my own apps
//I would extend to return a refresh token as well and shorten the expiration time of the auth token
//Check the git history for the commented out refresh logic
//Much of this could be simplified/inlined without the refresh token in the AuthNetworking
//I've commented out the refresh logic to remove extra overhead without the refresh token

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
        
//        return try await refreshToken()
    }
        
//    func validRefreshToken() async throws -> Token {
//        if let handle = refreshTask {
//            return try await handle.value
//        }
//        
//        let token = try await tokenStorage.getTokenFromStorage()
//        
//        guard !token.refreshExpired() else {
//            throw FayError.tokenRefresh
//        }
//        
//        return token
//    }
//    
//    func refreshToken() async throws -> Token {
//        if let refreshTask = refreshTask {
//            return try await refreshTask.value
//        }
//        
//        let task = Task { () throws -> Token in
//            defer { refreshTask = nil }
//            
//            let token = try await tokenStorage.getTokenFromStorage()
//            let newToken = try await unauthNetworking.refreshToken(withRefreshToken: token)
//
//            return newToken
//        }
//        
//        self.refreshTask = task
//        
//        return try await task.value
//    }
    
}
