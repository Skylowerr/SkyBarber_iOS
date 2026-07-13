//
//  TimeSlotGrid.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 14.07.2026.
//

import SwiftUI

struct TimeSlotGrid: View {
    let slots: [String]
    @Binding var selectedSlot: String?
    
    // 3'lü kolon tasarımı
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(slots, id: \.self) { slot in
                Button(action: {
                    selectedSlot = slot
                }) {
                    Text(slot)
                        .font(.subheadline.bold())
                        .foregroundColor(selectedSlot == slot ? Color.appBackground : Color.appTextPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(selectedSlot == slot ? Color.appAccent : Color.appCardBackground)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedSlot == slot ? Color.appAccent : Color.appTextSecondary.opacity(0.1), lineWidth: 1)
                        )
                }
            }
        }
    }
}
