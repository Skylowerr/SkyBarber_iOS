//
//  MockServiceService.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 14.07.2026.
//

import Foundation

class MockServiceService: ServiceServiceProtocol {
    private var appointments: [Appointment] = []
    
    // Hizmetleri dinamik hale getirdik ki sahte ekleme/silme yapabilelim
    private var services: [Service] = [
        Service(id: "1", title: "Haircut", price: 300.0, duration: 30, iconName: "scissors"),
        Service(id: "2", title: "Beard Shave", price: 150.0, duration: 20, iconName: "mustard"),
        Service(id: "3", title: "Hair & Beard Combo", price: 400.0, duration: 50, iconName: "comb"),
        Service(id: "4", title: "Facial Care & Mask", price: 200.0, duration: 30, iconName: "face.smiling")
    ]

    // MARK: - Müşteri İşlemleri
    
    func fetchServices() async throws -> [Service] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return services
    }

    func bookAppointment(appointment: Appointment) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        appointments.append(appointment)
    }

    func fetchUserAppointments(userId: String) async throws -> [Appointment] {
        return appointments.filter { $0.userId == userId }
    }
    
    func cancelAppointment(appointmentId: String) async throws {
        if let index = appointments.firstIndex(where: { $0.id == appointmentId }) {
            let oldAppt = appointments[index]
            let canceledAppt = Appointment(
                id: oldAppt.id,
                userId: oldAppt.userId,
                userName: oldAppt.userName,
                serviceId: oldAppt.serviceId,
                serviceTitle: oldAppt.serviceTitle,
                date: oldAppt.date,
                timeSlot: oldAppt.timeSlot,
                status: .cancelled
            )
            appointments[index] = canceledAppt
        }
    }

    // MARK: - Admin İşlemleri (Eksik Olan Kısım Burasıydı)
    
    func fetchAllAppointments() async throws -> [Appointment] {
        return appointments
    }
    
    func addService(service: Service) async throws {
        services.append(service)
    }
    
    func updateService(service: Service) async throws {
        if let index = services.firstIndex(where: { $0.id == service.id }) {
            services[index] = service
        }
    }
    
    func deleteService(serviceId: String) async throws {
        services.removeAll(where: { $0.id == serviceId })
    }
}
