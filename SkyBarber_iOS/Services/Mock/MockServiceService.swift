//
//  MockServiceService.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 14.07.2026.
//

import Foundation

class MockServiceService: ServiceServiceProtocol {
    private var appointments: [Appointment] = []
    
    func fetchServices() async throws -> [Service] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return [
            Service(id: "1", title: "Haircut", price: 300.0, duration: 30, iconName: "scissors"),
            Service(id: "2", title: "Beard Shave", price: 150.0, duration: 20, iconName: "mustard"),
            Service(id: "3", title: "Hair & Beard Combo", price: 400.0, duration: 50, iconName: "comb"),
            Service(id: "4", title: "Facial Care & Mask", price: 200.0, duration: 30, iconName: "face.smiling")
        ]
    }
    
    func bookAppointment(appointment: Appointment) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        appointments.append(appointment)
    }
    
    func fetchUserAppointments(userId: String) async throws -> [Appointment] {
        return appointments.filter { $0.userId == userId }
    }
}
