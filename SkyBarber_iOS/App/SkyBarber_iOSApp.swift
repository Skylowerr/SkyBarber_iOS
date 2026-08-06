//
//  SkyBarber_iOSApp.swift
//  SkyBarber_iOS
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if NSClassFromString("XCTestCase") == nil {
            FirebaseApp.configure()
        }
        return true
    }
}

@main
struct SkyBarberApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
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
                                // KULLANICI ROLÜNE GÖRE YÖNLENDİRME
                                if currentUser.role == .admin {
                                    AdminMainView(currentUser: currentUser, authViewModel: authViewModel)
                                } else {
                                    // BURAYA authViewModel PARAMETRESİNİ EKLEDİK
                                    HomeView(authViewModel: authViewModel, currentUser: currentUser)
                                }
                            } else {
                                AuthView(viewModel: authViewModel)
                            }
                        }            .preferredColorScheme(.dark)
        }
    }
}
