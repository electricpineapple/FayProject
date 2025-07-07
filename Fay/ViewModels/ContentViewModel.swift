//

import Observation
import Foundation

struct DisplayAppointment: Identifiable {
    let id: String
    let isFirst: Bool
    let month: String
    let day: String
    let time: String
    let shortTime: String
    let typeDisplay: String
    let shortTypeDisplay: String
    
    init(appointment: Appointment, isFirst: Bool = false) {
        id = appointment.id
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "MMM"
        month = formatter.string(from: appointment.start).uppercased()
        formatter.dateFormat = "d"
        day = formatter.string(from: appointment.start)
        formatter.dateFormat = "h:mm a"
        let firstHalfOfTime = formatter.string(from: appointment.start)
        formatter.dateFormat = "h:mm a (zzz)"
        let secondHalfOfTime = formatter.string(from: appointment.end)
        time = firstHalfOfTime + " - " + secondHalfOfTime
        formatter.dateFormat = "h a"
        shortTime = formatter.string(from: appointment.start)
        typeDisplay = appointment.appointmentType + " with Jane Williams, RD" //hard coded
        shortTypeDisplay = appointment.appointmentType
        self.isFirst = isFirst
    }
}

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
    var pastAppointments: [Appointment] = []
    var displayAppointments: [DisplayAppointment] = []
    var pastDisplayAppointments: [DisplayAppointment] = []
    var errorMessage: String? = nil
    var isAuthenticated: Bool = false

    func getAppointments() async {
        do {
            let retrievedAppointments = try await authNetworking.getAppointments()
            self.appointments = retrievedAppointments.filter { $0.status == "Scheduled" }
            self.displayAppointments = self.appointments.enumerated().map { (index, appointment) in
                DisplayAppointment(appointment: appointment, isFirst: index == 0)
            }
            self.pastAppointments = retrievedAppointments.filter { $0.status != "Scheduled" }
            self.pastDisplayAppointments = self.pastAppointments.map { DisplayAppointment(appointment: $0) }
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
