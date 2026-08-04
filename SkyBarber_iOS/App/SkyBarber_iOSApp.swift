//
//  SkyBarber_iOSApp.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 13.07.2026.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Test koşmuyorsa Firebase'i yapılandır (SIGABRT çökmesini önler)
        if NSClassFromString("XCTestCase") == nil {
            FirebaseApp.configure()
        }
        return true
    }
}

@main
struct SkyBarberApp: App {
    // AppDelegate entegrasyonu
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Test esnasında gerçek Firebase servisi yerine Mock servis enjekte ediyoruz
    @StateObject private var authViewModel: AuthViewModel = {
        if NSClassFromString("XCTestCase") != nil {
            return AuthViewModel(authService: MockAuthService())
        } else {
            return AuthViewModel(authService: FirebaseAuthService())
        }
    }()
    
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
