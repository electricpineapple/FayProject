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
                            .padding()
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
                    
                    if let errorMessage = contentViewModel.errorMessage {
                        Text(errorMessage)
                            .font(.custom("Manrope-Bold", size: 14))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.red)
                            .padding(.leading, 30)
                    }
                    else {
                        
                        //If used more I would probably generalized even more, having the group possibly in the component,
                        //able to pass in the content and tab labels and such
                        TopTabComponent(selectedTab: $selectedTab)
                        Spacer()
                        Group {
                            switch selectedTab {
                            case 0:
                                List($contentViewModel.displayAppointments) { appointment in
                                    AppointmentRowView(displayAppointment: appointment)
                                        .listRowSeparator(.hidden)
                                }
                                .listStyle(.plain)
                                .refreshable {
                                    await contentViewModel.getAppointments()
                                }
                            case 1:
                                List($contentViewModel.pastDisplayAppointments) { appointment in
                                    AppointmentRowView(displayAppointment: appointment)
                                        .listRowSeparator(.hidden)
                                }
                                .listStyle(.plain)
                                .refreshable {
                                    await contentViewModel.getAppointments()
                                }
                            default:
                                Text("Default")
                            }
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
                
                ProfileView(profileViewModel: contentViewModel.profileViewModel)
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
                .task {
                    await contentViewModel.checkIsAuthenticated()
                }
        }
    }
}

#Preview {
    let tokenStorage = KeychainTokenStorage()
    let unauthNetworking = UnauthNetworking(tokenStorage: tokenStorage)
    let authManager = AuthManager(tokenStorage: tokenStorage)
    let authNetworking = AuthNetworking(authManager: authManager)
    let contentViewModel = ContentViewModel(authNetworking: authNetworking, authentication: unauthNetworking)
    
    ContentView(contentViewModel: contentViewModel)
}
