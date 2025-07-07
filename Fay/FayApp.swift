//

import SwiftUI

@main
struct FayApp: App {
    let tokenStorage: TokenStorage
    let unauthNetworking: UnauthNetworking
    let authManager: AuthManager
    let authNetworking: AuthNetworking
    let contentViewModel: ContentViewModel
    
    init() {
        tokenStorage = KeychainTokenStorage()
        unauthNetworking = UnauthNetworking(tokenStorage: tokenStorage)
        authManager = AuthManager(tokenStorage: tokenStorage)
        authNetworking = AuthNetworking(authManager: authManager)
        contentViewModel = ContentViewModel(authNetworking: authNetworking, authentication: unauthNetworking)
        
    }

    var body: some Scene {
        WindowGroup {
            ContentView(contentViewModel: contentViewModel)
        }
    }
}
