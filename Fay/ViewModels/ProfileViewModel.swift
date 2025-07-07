//

import Observation

@Observable class ProfileViewModel {
    let authentication: Authentication
    
    init(authentication: Authentication) {
        self.authentication = authentication
    }
    
    func logout() async {
        do {
            try await authentication.logout()
        } catch {
            print("Error logging out: \(error)")
        }
    }
}
