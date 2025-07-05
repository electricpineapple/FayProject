//

import Observation

@Observable class ContentViewModel {
    private let authNetworking: AuthNetworking
    var appointments: [Appointment] = []
    var errorMessage: String? = nil

    init(authNetworking: AuthNetworking) {
        self.authNetworking = authNetworking
    }

    func getAppointments() async {
        do {
            self.appointments = try await authNetworking.getAppointments()
        }
        catch {
            //Probably would customize this to be a nicer message
            errorMessage = error.localizedDescription
        }
    }
    
}
