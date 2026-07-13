//
//  User.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 14.07.2026.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullName: String
    let email: String
    let phoneNumber: String
    let role: UserRole
    
    // User roles to distinguish admin permissions (e.g., adding services)
    enum UserRole: String, Codable {
        case customer
        case admin
    }
}
