//
//  Appointment.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 14.07.2026.
//

import Foundation

struct Appointment: Identifiable, Codable {
    let id: String
    let userId: String
    let userName: String
    let serviceId: String
    let serviceTitle: String
    let date: Date
    let timeSlot: String // e.g., "14:00"
    let status: AppointmentStatus
    
    enum AppointmentStatus: String, Codable {
        case pending
        case confirmed
        case cancelled
    }
}
