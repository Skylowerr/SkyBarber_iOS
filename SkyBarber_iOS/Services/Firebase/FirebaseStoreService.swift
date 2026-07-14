//
//  FirebaseStoreService.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 14.07.2026.
//

import Foundation
import FirebaseFirestore

class FirebaseStoreService: ServiceServiceProtocol {
    private let db = Firestore.firestore()
    
    func fetchServices() async throws -> [Service] {
        let snapshot = try await db.collection("services").getDocuments()
        
        return snapshot.documents.compactMap { doc -> Service? in
            let data = doc.data()
            return Service(
                id: doc.documentID,
                title: data["title"] as? String ?? (data["name"] as? String ?? "Unknown Service"), // 'name' veya 'title' kontrolü
                price: data["price"] as? Double ?? 0.0,
                duration: data["duration"] as? Int ?? 30,
                iconName: data["iconName"] as? String ?? "scissors"
            )
        }
    }
    
    func bookAppointment(appointment: Appointment) async throws {
        let appointmentData: [String: Any] = [
            "id": appointment.id,
            "userId": appointment.userId,
            "userName": appointment.userName,
            "serviceId": appointment.serviceId,
            "serviceTitle": appointment.serviceTitle,
            "date": Timestamp(date: appointment.date),
            "timeSlot": appointment.timeSlot,
            "status": appointment.status.rawValue
        ]
        
        // Firestore 'appointments' koleksiyonuna kaydet
        try await db.collection("appointments").document(appointment.id).setData(appointmentData)
    }
    
    func fetchUserAppointments(userId: String) async throws -> [Appointment] {
        let snapshot = try await db.collection("appointments")
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc -> Appointment? in
            let data = doc.data()
            let timestamp = data["date"] as? Timestamp ?? Timestamp()
            
            return Appointment(
                id: doc.documentID,
                userId: data["userId"] as? String ?? "",
                userName: data["userName"] as? String ?? "",
                serviceId: data["serviceId"] as? String ?? "",
                serviceTitle: data["serviceTitle"] as? String ?? "",
                date: timestamp.dateValue(),
                timeSlot: data["timeSlot"] as? String ?? "",
                status: Appointment.AppointmentStatus(rawValue: data["status"] as? String ?? "pending") ?? .pending
            )
        }
    }
    
    func cancelAppointment(appointmentId: String) async throws {
        // Firestore randevu durumunu güncelle
        try await db.collection("appointments").document(appointmentId).updateData([
            "status": Appointment.AppointmentStatus.cancelled.rawValue
        ])
    }
}
