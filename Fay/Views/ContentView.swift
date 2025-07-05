//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Text("1")
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
    }
}

#Preview {
    ContentView()
}
