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
    
    // Veritabanındaki (Web) key'ler ile Swift modelini eşleştiriyoruz
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name" // Web tarafındaki isimlendirme
        case email
        case phoneNumber
        case role
    }
    
    // User roles to distinguish admin permissions
    enum UserRole: String, Codable {
        case customer
        case admin
    }
}
