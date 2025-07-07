//

import SwiftUI

struct ProfileView: View {
    @Bindable var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Profile")
                .font(.custom("Manrope-ExtraBold", size: 24))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

            HStack {
                Image("ProfilePic")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding()
                VStack(alignment: .leading) {
                    Text("Erik Peterson")
                        .font(.custom("Manrope-Bold", size: 18))
                    Text("erik@thepetecollective.com")
                        .font(.custom("Manrope-Regular", size: 14))
                }
            }
            Text("Software engineer and manager with 15+ years of experience across a wide range of technologies. I am a curious and driven individual who works very well on a team. Specializing in iOS development with a deep history (Objective-C -> SwiftUI), I have experience in developing iOS applications, from conception to release on the iTunes App Store.")
                .font(.custom("Manrope-Regular", size: 14))
                .foregroundStyle(.fayDarkGray)
                .padding(.horizontal)
            Spacer()
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.fayLightGray, lineWidth: 1)
                    .frame(maxWidth: .infinity, maxHeight: 150)

                VStack(alignment: .leading) {
                    Text("Highlighted Apps")
                        .font(.custom("Manrope-Regular", size: 14))

                    HStack(spacing: 20) {
                        Image("IbottaApp")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        Image("SFApp")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding()
            }
            .padding()
            Button {
                Task {
                    await profileViewModel.logout()
                }
            } label: {
                HStack {
                    Text("Log out")
                }
                .frame(maxWidth: .infinity, minHeight: 30)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
        .padding()
    }
}
