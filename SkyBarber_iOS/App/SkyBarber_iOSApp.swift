//
//  SkyBarber_iOSApp.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 13.07.2026.
//

import SwiftUI

@main
struct SkyBarberApp: App {
    // Bu bizim ana oturum yöneticimiz
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if let currentUser = authViewModel.currentUser {
                    HomeView(currentUser: currentUser)
                } else {
                    // authViewModel'ı buraya parametre olarak gönderiyoruz!
                    AuthView(viewModel: authViewModel)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
