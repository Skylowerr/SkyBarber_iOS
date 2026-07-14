//
//  SkyBarber_iOSApp.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 13.07.2026.
//

import SwiftUI
import FirebaseCore // <-- Bunu ekledik

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure() // Firebase'i burada ayağa kaldırıyoruz
        return true
    }
}

@main
struct SkyBarberApp: App {
    // AppDelegate entegrasyonu
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Uygulama seviyesindeki ana oturum yöneticisi (Artık gerçek FirebaseAuthService ile çalışacak!)
    @StateObject private var authViewModel = AuthViewModel(authService: FirebaseAuthService())
    
    var body: some Scene {
        WindowGroup {
            Group {
                if let currentUser = authViewModel.currentUser {
                    HomeView(currentUser: currentUser)
                } else {
                    AuthView(viewModel: authViewModel)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
