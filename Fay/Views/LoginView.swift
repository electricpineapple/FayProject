//

import SwiftUI

struct LoginView: View {
    @Bindable var loginViewModel: LoginViewModel
    
    var body: some View {
        Form {
            VStack {
                Text("Log in")
                    .font(.custom("Manrope-ExtraBold", size: 24))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                if let message = loginViewModel.errorMessage {
                    Text(message)
                        .font(.custom("Manrope-Bold", size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.red)
                        .padding(.bottom, 10)
                }
                Text("Username")
                    .font(.custom("Manrope-Bold", size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)

                TextField("Username", text: $loginViewModel.username)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)

                Text("Password")
                    .font(.custom("Manrope-Bold", size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)

                SecureField("Password", text: $loginViewModel.password)
                    .textFieldStyle(.roundedBorder)
                    

                Spacer()
                Button {
                    Task {
                        await loginViewModel.login()
                    }
                } label: {
                    Text("Login")
                        .frame(maxWidth: .infinity, minHeight: 30)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(24)
        }
        .formStyle(.columns)
    }
}

#Preview {
    LoginView(loginViewModel: LoginViewModel(authentication: UnauthNetworking(tokenStorage: KeychainTokenStorage())))
}
