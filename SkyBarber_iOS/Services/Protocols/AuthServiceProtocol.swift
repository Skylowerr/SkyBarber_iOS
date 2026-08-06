//
//  AuthServiceProtocol.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 14.07.2026.
//

import Foundation

protocol AuthServiceProtocol {
    var currentUser: User? { get }
    
    func login(email: String, password: String) async throws -> User
    func register(email: String, password: String, fullName: String, phoneNumber: String) async throws -> User
    func logout() async throws
}
