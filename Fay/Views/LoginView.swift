//

import SwiftUI

struct LoginView: View {
    @Bindable var loginViewModel: LoginViewModel
    
    var body: some View {
        Form {
            TextField("Username", text: $loginViewModel.username)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $loginViewModel.password)
            Button("Login") {
                Task {
                    await loginViewModel.login()
                }
            }
        }
    }
}
