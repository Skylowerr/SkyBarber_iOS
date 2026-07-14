//
//  FirebaseAuthService.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 14.07.2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthService: AuthServiceProtocol {
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    var currentUser: User?
    
    func login(email: String, password: String) async throws -> User {
        // 1. Firebase Auth ile giriş yap
        let result = try await auth.signIn(withEmail: email, password: password)
        let uid = result.user.uid
        
        // 2. Firestore'daki 'users' koleksiyonundan detayları çek
        let document = try await db.collection("users").document(uid).getDocument()
        
        guard let data = document.data() else {
            throw NSError(domain: "AuthError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User profile not found in database."])
        }
        
        // Ekran resmindeki şemaya göre eşleştiriyoruz (fullName ve phoneNumber yoksa güvenli fallback koyuyoruz)
        let user = User(
            id: uid,
            fullName: data["fullName"] as? String ?? (data["email"] as? String ?? "User"),
            email: data["email"] as? String ?? email,
            phoneNumber: data["phoneNumber"] as? String ?? "",
            role: User.UserRole(rawValue: data["role"] as? String ?? "customer") ?? .customer
        )
        
        self.currentUser = user
        return user
    }
    
    func register(email: String, password: String, fullName: String, phoneNumber: String) async throws -> User {
        // 1. Firebase Auth üzerinde yeni kullanıcı oluştur
        let result = try await auth.createUser(withEmail: email, password: password)
        let uid = result.user.uid
        
        let user = User(
            id: uid,
            fullName: fullName,
            email: email,
            phoneNumber: phoneNumber,
            role: .customer
        )
        
        // 2. Web şemanla tam uyumlu olacak şekilde verileri Firestore'a yazıyoruz
        let userData: [String: Any] = [
            "id": user.id,
            "email": user.email,
            "fullName": user.fullName,
            "phoneNumber": user.phoneNumber,
            "role": user.role.rawValue,
            "created_at": ISO8601DateFormatter().string(from: Date()) // Web tarafındaki formatla uyumlu timestamp
        ]
        
        try await db.collection("users").document(uid).setData(userData)
        
        self.currentUser = user
        return user
    }
    
    func logout() async throws {
        try auth.signOut()
        self.currentUser = nil
    }
}
