//
//  AuthViewModel.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 14.07.2026.
//

import Foundation
import Combine

@MainActor // Ensures UI updates happen on the main thread
class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Dependency Injection: Decoupled from concrete implementations (SOLID)
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = MockAuthService()) {
        self.authService = authService
        self.currentUser = authService.currentUser
    }
    
    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await authService.login(email: email, password: password)
            self.currentUser = user
            self.isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
    
    func register(email: String, password: String, fullName: String, phoneNumber: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await authService.register(
                email: email,
                password: password,
                fullName: fullName,
                phoneNumber: phoneNumber
            )
            self.currentUser = user
            self.isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
    
    func logout() async {
        do {
            try await authService.logout()
            self.currentUser = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
