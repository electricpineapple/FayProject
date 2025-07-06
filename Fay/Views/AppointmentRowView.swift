//

import SwiftUI

struct AppointmentRowView: View {
    
    @Binding var appointment: Appointment
    var isFirst: Bool = false
    
    var body: some View {
        ZStack {
            if isFirst {
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
                            Text("NOV")
                                .font(.custom("Manrope-SemiBold", size: 12))
                                .foregroundStyle(.accent)
                            Text("12")
                                .font(.custom("Manrope-SemiBold", size: 18))
                        }
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        Text("11:00 AM - 12:00 PM (PT)")
                            .font(.custom("Manrope-Bold", size: 14))
                        Text("Follow up with Jane Williams, RD")
                            .font(.custom("Manrope-Medium", size: 12))
                            .foregroundStyle(.fayDarkGray)
                    }
                }
                if (isFirst) {
                    Button {
                        Task {
                            
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
    @Previewable @State var appointment: Appointment = .init(id: "1224", patientId: "34566", providerId: "999", status: "open", appointmentType: "type", start: "start", end: "end", durationInMinutes: 123, recurrenceType: "Monthly")
    AppointmentRowView(appointment: $appointment, isFirst: false)
}
