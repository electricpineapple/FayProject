//

import SwiftUI

struct AppointmentRowView: View {
    @Binding var displayAppointment: DisplayAppointment

    var body: some View {
        ZStack {
            if displayAppointment.isFirst {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(.background)
                    .shadow(radius: 4, x: 4, y: 4)
                    .frame(maxWidth: .infinity, maxHeight: 140)
            }
            else {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.fayLightGray, lineWidth: 1)
                    .foregroundStyle(.background)
                    .frame(maxWidth: .infinity, maxHeight: 80)
            }
            VStack(alignment: .leading) {
                HStack(spacing: 16) {
                    ZStack {
                        Rectangle()
                            .foregroundStyle(.fayLightBlue)
                            .cornerRadius(4)
                            .frame(width: 48, height: 48)
                        Rectangle()
                            .foregroundStyle(.fayXLightGray)
                            .frame(width: 48, height: 28)
                            .padding(.top, 20)
                        VStack {
                            Text(displayAppointment.month)
                                .font(.custom("Manrope-SemiBold", size: 12))
                                .foregroundStyle(.accent)
                            Text(displayAppointment.day)
                                .font(.custom("Manrope-SemiBold", size: 18))
                        }
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        Text(displayAppointment.isFirst ? displayAppointment.time : displayAppointment.shortTime)
                            .font(.custom("Manrope-Bold", size: 14))
                        Text(displayAppointment.isFirst ? displayAppointment.typeDisplay : displayAppointment.shortTypeDisplay)
                            .font(.custom("Manrope-Medium", size: 12))
                            .foregroundStyle(.fayDarkGray)
                    }
                }
                if (displayAppointment.isFirst) {
                    Button {
                        Task {
                            print("Button Tapped")
                        }
                    } label: {
                        HStack {
                            Image("Videocamera")
                            Text("Join appointment")
                        }
                        .frame(maxWidth: .infinity, minHeight: 30)
                        
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    @Previewable @State var displayAppointment: DisplayAppointment = .init(appointment: Appointment(id: "1224", patientId: "34566", providerId: "999", status: "open", appointmentType: "type", start: Date(), end: Date(), durationInMinutes: 123, recurrenceType: "Monthly"))
    AppointmentRowView(displayAppointment: $displayAppointment)
}
