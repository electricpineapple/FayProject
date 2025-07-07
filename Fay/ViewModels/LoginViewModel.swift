//

import Foundation

@Observable class LoginViewModel {
    
    let authentication: Authentication
    
    init(authentication: Authentication) {
        self.authentication = authentication
    }
    
    var username: String = ""
    var password: String = ""
    var errorMessage: String? = nil

    func login() async {
        errorMessage = nil
        
        if username.isEmpty || password.isEmpty {
            errorMessage = "Username and password are required."
            return
        }
        
        if username != "john" && password != "12345" {
            errorMessage = "Invalid username or password."
            return
        }
        
        do {
            try await authentication.login(username: username, password: password)
        }
        catch {
            errorMessage = "Invalid username or password."
        }
    }
}
