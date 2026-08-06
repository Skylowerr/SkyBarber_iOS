import SwiftUI

struct AdminMainView: View {
    let currentUser: User
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            // authViewModel'i İÇERİ GÖNDERİYORUZ
            AdminAppointmentsView(authViewModel: authViewModel)
                .tabItem {
                    Label("Randevular", systemImage: "calendar")
                }
            
            AdminServicesView()
                .tabItem {
                    Label("Hizmetler", systemImage: "scissors")
                }
        }
    }
}
