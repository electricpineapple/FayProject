//

import SwiftUI

struct TopTabComponent: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            VStack{
                Button("Upcoming"){
                    selectedTab = 0
                }
                .foregroundStyle(selectedTab == 0 ? .accent : .fayDarkGray)
                .font(.custom("Manrope-Bold", size: 14))
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(selectedTab == 0 ? .accent : .fayLightGray)
                
            }
            VStack{
                Button("Past"){
                    selectedTab = 1
                }
                .foregroundStyle(selectedTab == 1 ? .accent : .fayDarkGray)
                .font(.custom("Manrope-Bold", size: 14))
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(selectedTab == 1 ? .accent : .fayLightGray)
            }
        }
    }
}
