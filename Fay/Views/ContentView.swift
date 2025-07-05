//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    private var appointments: [Appointment] = []
    @Bindable var contentViewModel: ContentViewModel
    
    init(contentViewModel: ContentViewModel) {
        self.contentViewModel = contentViewModel
    }
    
    var body: some View {
        if (contentViewModel.isAuthenticated) {
            TabView {
                VStack {
                    HStack{
                        Text("Appointments")
                            .font(.custom("Manrope-ExtraBold", size: 24))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.all)
                        Button {
                            print("Button Tapped")
                        } label: {
                            HStack {
                                Image("New")
                                Text("New")
                                    .font(.custom("Manrope-Bold", size: 14))
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 8,
                                    style: .continuous
                                )
                                .stroke(Color(.fayLightGray), lineWidth: 0.75)
                            )
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                    .padding()
                    
                    //If used more I would probably generalized even more, having the group possibly in the component,
                    //able to pass in the content and tab labels and such
                    TopTabComponent(selectedTab: $selectedTab)
                    Spacer()
                    Group {
                        switch selectedTab {
                        case 0:
                            List($contentViewModel.appointments) { appointment in
                                Text(appointment.id)
                            }
                        default:
                            Text("Default")
                        }
                    }
                    Spacer()
                }
                .tabItem {
                    Image("Calendar")
                    Text("Appointments")
                }
                
                Text("2")
                    .tabItem {
                        Image("Chats")
                        Text("Chat")
                    }
                
                Text("3")
                    .tabItem {
                        Image("Notebook")
                        Text("Journal")
                    }
                
                Text("4")
                    .tabItem {
                        Image("User")
                        Text("Profile")
                    }
            }
            .task {
                await contentViewModel.getAppointments()
            }
        }
        else {
            LoginView(loginViewModel: contentViewModel.loginViewModel)
        }
            
    }
}
