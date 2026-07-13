//
//  Service.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 14.07.2026.
//

import Foundation

struct Service: Identifiable, Codable {
    let id: String
    let title: String
    let price: Double
    let duration: Int // In minutes
    let iconName: String
}
