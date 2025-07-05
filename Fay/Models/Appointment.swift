//

struct AppointmentResponse: Codable {
    let appointments: [Appointment]
}

struct Appointment: Codable, Identifiable {
    let id: String
    let patientId: String
    let providerId: String
    let status: String
    let appointmentType: String
    let start: String
    let end: String
    let durationInMinutes: Int
    let recurrenceType: String
    
    enum CodingKeys: String, CodingKey {
        case id = "appointmentId" //I'm default snake-casing but I want this identifiable by id
        case patientId
        case providerId
        case status
        case appointmentType
        case start
        case end
        case durationInMinutes
        case recurrenceType
    }
}
