//
//  HomeView.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 14.07.2026.
//

import SwiftUI

struct HomeView: View {
    // Tasarımın durumsal halleri (İleride HomeViewModel'e bağlanacak)
    @State private var selectedServiceId: String? = nil
    @State private var navigateToBooking = false
    
    // Geçici sahte veriler (Hata vermemesi için)
    let services = [
        (id: "1", title: "Saç Kesimi", price: 300.0, duration: 30, icon: "scissors"),
        (id: "2", title: "Sakal Tıraşı", price: 150.0, duration: 20, icon: "mustard"), // Janti tıraş bıçağı ikonu niyetine
        (id: "3", title: "Saç & Sakal Kombin", price: 400.0, duration: 50, icon: "comb"),
        (id: "4", title: "Cilt Bakımı & Maske", price: 200.0, duration: 30, icon: "face.smiling")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Üst Bar (Header)
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Merhaba Emirhan,")
                                .font(.subheadline)
                                .foregroundColor(.appTextSecondary)
                            Text("Tarzını Seç ✂️")
                                .font(.title.bold())
                                .foregroundColor(.appTextPrimary)
                        }
                        Spacer()
                        
                        // Profil Butonu
                        Button(action: {}) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 36))
                                .foregroundColor(.appAccent)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Kampanya Kartı (Web'deki gibi şık durması için)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Haftalık Fırsat")
                            .font(.caption)
                            .bold()
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.appBackground)
                            .foregroundColor(.appAccent)
                            .cornerRadius(4)
                        
                        Text("Saç + Sakal + Maske Kombini")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        
                        Text("Bu haftaya özel sadece 500 TL!")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(LinearGradient(colors: [.appAccent, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    Text("Hizmetlerimiz")
                        .font(.headline)
                        .foregroundColor(.appTextPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    // Hizmetler Listesi
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(services, id: \.id) { service in
                                Button(action: {
                                    selectedServiceId = service.id
                                }) {
                                    ServiceCardView(
                                        title: service.title,
                                        price: service.price,
                                        duration: service.duration,
                                        iconName: service.icon,
                                        isSelected: selectedServiceId == service.id
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Randevu Al Butonu
                    Button(action: {
                        if selectedServiceId != nil {
                            navigateToBooking = true
                        }
                    }) {
                        Text("Randevu Ayarla")
                            .font(.headline)
                            .foregroundColor(.appBackground)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(selectedServiceId != nil ? Color.appAccent : Color.appTextSecondary.opacity(0.3))
                            .cornerRadius(12)
                            .shadow(color: selectedServiceId != nil ? Color.appAccent.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
                    }
                    .disabled(selectedServiceId == nil)
                    .padding(.horizontal)
                    .padding(.bottom, 15)
                }
            }
            .navigationDestination(isPresented: $navigateToBooking) {
                BookingView() // Randevu ekranına yönlendirme yapıyoruz
            }
        }
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}
