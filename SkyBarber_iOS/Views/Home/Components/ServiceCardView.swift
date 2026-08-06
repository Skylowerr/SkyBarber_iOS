//
//  ServiceCardView.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 14.07.2026.
//

import SwiftUI

struct ServiceCardView: View {
    let title: String
    let price: Double
    let duration: Int // dakika cinsinden
    let iconName: String
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Hizmet İkonu
            ZStack {
                Circle()
                    .fill(isSelected ? Color.appBackground : Color.appBackground.opacity(0.5))
                    .frame(width: 50, height: 50)
                
                Image(systemName: iconName)
                    .font(.title3)
                    .foregroundColor(.appAccent)
            }
            
            // Hizmet Detayları
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.appTextPrimary)
                
                Text("\(duration) Dakika")
                    .font(.subheadline)
                    .foregroundColor(.appTextSecondary)
            }
            
            Spacer()
            
            // Fiyat Bilgisi
            Text("\(Int(price)) TL")
                .font(.headline)
                .foregroundColor(.appAccent)
                .bold()
        }
        .padding()
        .background(isSelected ? Color.appAccent.opacity(0.15) : Color.appCardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color.appAccent : Color.appTextSecondary.opacity(0.1), lineWidth: 1.5)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
    }
}

#Preview {
    ServiceCardView(
        title: "Saç & Sakal Kombin",
        price: 400.0,
        duration: 50,
        iconName: "scissors",
        isSelected: true
    )
    .padding()
    .background(Color.appBackground)
    .preferredColorScheme(.dark)
}
