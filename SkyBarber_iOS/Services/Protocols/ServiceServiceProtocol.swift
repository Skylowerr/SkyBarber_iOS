//
//  ServiceServiceProtocol.swift
//  SkyBarber_iOS
//

import Foundation

protocol ServiceServiceProtocol {
    // Müşteri İşlemleri
    func fetchServices() async throws -> [Service]
    func bookAppointment(appointment: Appointment) async throws
    func fetchUserAppointments(userId: String) async throws -> [Appointment]
    func cancelAppointment(appointmentId: String) async throws
    
    // Admin İşlemleri (YENİ)
    func fetchAllAppointments() async throws -> [Appointment]
    func addService(service: Service) async throws
    func updateService(service: Service) async throws
    func deleteService(serviceId: String) async throws
}
