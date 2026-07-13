//
//  MockAuthService.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 14.07.2026.
//

import Foundation

class MockAuthService: AuthServiceProtocol {
    var currentUser: User?
    
    func login(email: String, password: String) async throws -> User {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        if email == "test@gmail.com" && password == "123456" {
            let user = User(id: "mock_user_123", fullName: "Emirhan Sky", email: email, phoneNumber: "+905555555555", role: .customer)
            self.currentUser = user
            return user
        } else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials."])
        }
    }
    
    func register(email: String, password: String, fullName: String, phoneNumber: String) async throws -> User {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        let user = User(id: UUID().uuidString, fullName: fullName, email: email, phoneNumber: phoneNumber, role: .customer)
        self.currentUser = user
        return user
    }
    
    func logout() async throws {
        self.currentUser = nil
    }
}
