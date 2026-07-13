//
//  Theme.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 14.07.2026.
//

import SwiftUI

extension Color {
    static let appBackground = Color(hex: "0F172A") // Koyu Gece Mavisi / Siyah tonu
    static let appCardBackground = Color(hex: "1E293B") // Kartlar için biraz daha açık ton
    static let appAccent = Color(hex: "F59E0B") // Berber jantiliği için Altın/Turuncu tonu (Gold)
    static let appTextPrimary = Color.white
    static let appTextSecondary = Color(hex: "94A3B8") // Gri tonu
}

// Kolayca Hex kodu kullanabilmek için yardımcı eklenti
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
