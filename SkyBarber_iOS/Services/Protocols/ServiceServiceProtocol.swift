//
//  ServiceServiceProtocol.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 14.07.2026.
//

import Foundation

protocol ServiceServiceProtocol {
    func fetchServices() async throws -> [Service]
    func bookAppointment(appointment: Appointment) async throws
    func fetchUserAppointments(userId: String) async throws -> [Appointment]
}
