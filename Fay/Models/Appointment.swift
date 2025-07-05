//

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
}
