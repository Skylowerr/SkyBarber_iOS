import Foundation
import FirebaseFirestore

class FirebaseStoreService: ServiceServiceProtocol {
    private let db = Firestore.firestore()
    
    // Tarihleri Web formatına çevirmek için formatter'lar
    private var isoFormatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }
    
    private var simpleDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    // MARK: - Service İşlemleri
    
    func fetchServices() async throws -> [Service] {
        let snapshot = try await db.collection("services").getDocuments()
        return snapshot.documents.compactMap { doc -> Service? in
            let data = doc.data()
            return Service(
                id: doc.documentID,
                title: data["name"] as? String ?? (data["title"] as? String ?? "Unknown Service"), // Web "name" kullanıyor
                price: data["price"] as? Double ?? 0.0,
                duration: data["duration"] as? Int ?? 30, // Web'de yoksa varsayılan
                iconName: data["iconName"] as? String ?? "scissors" // Web'de yoksa varsayılan
            )
        }
    }
    
    func addService(service: Service) async throws {
        let serviceData: [String: Any] = [
            "id": service.id,
            "name": service.title,
            "price": service.price,
            "duration": service.duration,
            "iconName": service.iconName,
            "created_at": isoFormatter.string(from: Date()) // Web formatında ISO String
        ]
        try await db.collection("services").document(service.id).setData(serviceData)
    }
    
    func updateService(service: Service) async throws {
        let serviceData: [String: Any] = [
            "name": service.title,
            "price": service.price,
            "duration": service.duration,
            "iconName": service.iconName,
            "title": FieldValue.delete() // Eskiden kalan title'ı temizler
        ]
        try await db.collection("services").document(service.id).updateData(serviceData)
    }
    
    func deleteService(serviceId: String) async throws {
        try await db.collection("services").document(serviceId).delete()
    }
    
    // MARK: - Appointment İşlemleri
    
    func bookAppointment(appointment: Appointment) async throws {
        let appointmentData: [String: Any] = [
            "id": appointment.id,
            "customerEmail": appointment.userId, // Web müşteri mailini baz alıyor, userId yerine bunu yazıyoruz
            "serviceId": appointment.serviceId,
            "serviceName": appointment.serviceTitle,
            "date": simpleDateFormatter.string(from: appointment.date), // "yyyy-MM-dd" formatında string
            "time": appointment.timeSlot, // Web 'time' kullanıyor
            "price": 0, // Web tarafı price bekliyor (Opsiyonel olarak ilgili servisin fiyatını buraya çekebilirsin)
            "status": appointment.status.rawValue,
            "created_at": isoFormatter.string(from: Date())
        ]
        
        try await db.collection("appointments").document(appointment.id).setData(appointmentData)
    }
    
    func fetchUserAppointments(userId: String) async throws -> [Appointment] {
        // Müşteri kendi emaili (userId) ile eşleşenleri çeker
        let snapshot = try await db.collection("appointments").whereField("customerEmail", isEqualTo: userId).getDocuments()
        return parseAppointments(from: snapshot)
    }
    
    func cancelAppointment(appointmentId: String) async throws {
        try await db.collection("appointments").document(appointmentId).updateData([
            "status": Appointment.AppointmentStatus.cancelled.rawValue
        ])
    }
    
    func fetchAllAppointments() async throws -> [Appointment] {
        let snapshot = try await db.collection("appointments").getDocuments()
        return parseAppointments(from: snapshot)
    }
    
    // Yardımcı Okuma Fonksiyonu
    private func parseAppointments(from snapshot: QuerySnapshot) -> [Appointment] {
        return snapshot.documents.compactMap { doc -> Appointment? in
            let data = doc.data()
            
            // String tarihi iOS Date nesnesine çeviriyoruz
            let dateString = data["date"] as? String ?? ""
            let date = simpleDateFormatter.date(from: dateString) ?? Date()
            
            return Appointment(
                id: doc.documentID,
                userId: data["customerEmail"] as? String ?? "",
                userName: data["customerEmail"] as? String ?? "", // Ekranda email görünsün
                serviceId: data["serviceId"] as? String ?? "",
                serviceTitle: data["serviceName"] as? String ?? "",
                date: date,
                timeSlot: data["time"] as? String ?? "",
                status: Appointment.AppointmentStatus(rawValue: data["status"] as? String ?? "pending") ?? .pending
            )
        }
    }
}
