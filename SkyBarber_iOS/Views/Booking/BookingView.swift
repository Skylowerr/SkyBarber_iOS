//
//  BookingView.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 14.07.2026.
//

import SwiftUI

struct BookingView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Tasarım durumları (İleride BookingViewModel'e bağlanacak)
    @State private var selectedDate = Date()
    @State private var selectedTime: String? = nil
    @State private var showSuccessAlert = false
    
    // Berber dükkanının çalışma saatleri
    let timeSlots = [
        "09:00", "10:00", "11:00",
        "13:00", "14:00", "15:00",
        "16:00", "17:00", "18:00"
    ]
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Özel Geri Butonlu Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.appAccent)
                    }
                    Spacer()
                    Text("Randevu Tarihi")
                        .font(.title3.bold())
                        .foregroundColor(.appTextPrimary)
                    Spacer()
                    // Dengeli durması için hayali boşluk
                    Spacer().frame(width: 24)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // 1. Takvim Alanı (Web'deki takvim seçici)
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Tarih Seçin")
                                .font(.headline)
                                .foregroundColor(.appTextSecondary)
                            
                            DatePicker("Tarih", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                                .datePickerStyle(.graphical)
                                .accentColor(.appAccent)
                                .padding()
                                .background(Color.appCardBackground)
                                .cornerRadius(16)
                                .preferredColorScheme(.dark) // Koyu moda zorluyoruz takvimi
                        }
                        .padding(.horizontal)
                        
                        // 2. Saat Dilimi Alanı
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Saat Seçin")
                                .font(.headline)
                                .foregroundColor(.appTextSecondary)
                            
                            TimeSlotGrid(slots: timeSlots, selectedSlot: $selectedTime)
                        }
                        .padding(.horizontal)
                    }
                }
                
                // 3. Randevuyu Tamamla Butonu
                Button(action: {
                    if selectedTime != nil {
                        showSuccessAlert = true
                    }
                }) {
                    Text("Randevuyu Onayla")
                        .font(.headline)
                        .foregroundColor(.appBackground)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(selectedTime != nil ? Color.appAccent : Color.appTextSecondary.opacity(0.3))
                        .cornerRadius(12)
                }
                .disabled(selectedTime == nil)
                .padding(.horizontal)
                .padding(.bottom, 15)
            }
        }
        .navigationBarBackButtonHidden(true) // Varsayılan geri butonunu gizliyoruz
        .alert(isPresented: $showSuccessAlert) {
            Alert(
                title: Text("Başarılı! 🎉"),
                message: Text("Randevunuz başarıyla oluşturuldu. Koltuk sizi bekler!"),
                dismissButton: .default(Text("Ana Sayfaya Dön"), action: {
                    dismiss()
                })
            )
        }
    }
}

#Preview {
    BookingView()
        .preferredColorScheme(.dark)
}
