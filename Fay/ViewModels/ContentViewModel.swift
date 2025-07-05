//

import Observation

@Observable class ContentViewModel: Authentication {
    private let authNetworking: AuthNetworking
    private let authentication: Authentication
    private var _loginViewModel: LoginViewModel?
    private(set) var loginViewModel: LoginViewModel {
        get { return _loginViewModel! } //if we didn't set this up right, fail fast
        set { _loginViewModel = newValue }
    }

    init(authNetworking: AuthNetworking, authentication: Authentication) {
        self.authNetworking = authNetworking
        self.authentication = authentication
        
        loginViewModel = LoginViewModel(authentication: self) //the optional work above lets self be the delegate
    }
    
    var appointments: [Appointment] = []
    var errorMessage: String? = nil
    var isAuthenticated: Bool = false

    func getAppointments() async {
        do {
            self.appointments = try await authNetworking.getAppointments()
        }
        catch {
            //Probably would customize this to be a nicer message
            errorMessage = error.localizedDescription
        }
    }
    
    func login(username: String, password: String) async throws {
        try await authentication.login(username: username, password: password)
        self.isAuthenticated = true
    }
    
    func logout() async throws {
        try await authentication.logout()
        self.isAuthenticated = false
    }
}
