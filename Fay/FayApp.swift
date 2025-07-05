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
        authManager = AuthManager(unauthNetworking: unauthNetworking, tokenStorage: tokenStorage)
        authNetworking = AuthNetworking(authManager: authManager)
        contentViewModel = ContentViewModel(authNetworking: authNetworking)
    }

    
    var body: some Scene {
        WindowGroup {
            ContentView(contentViewModel: contentViewModel)
        }
    }
}
