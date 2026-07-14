import SwiftUI

struct HomeView: View {
    // 1. ViewModel'ları içeri alıyoruz
    @StateObject private var viewModel = HomeViewModel()
    
    // 2. Sayfa geçişlerini kontrol eden tetikleyicilerimiz (Burası yeni eklendi)
    @State private var navigateToBooking = false
    @State private var navigateToProfile = false // Profil ekranına geçiş için durum
    
    // Aktif oturumdaki kullanıcı bilgisi
    let currentUser: User
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    // --- ÜST BAR (HEADER) BAŞLANGICI ---
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome, \(currentUser.fullName)")
                                .font(.subheadline)
                                .foregroundColor(.appTextSecondary)
                            Text("Select a Service ✂️")
                                .font(.title.bold())
                                .foregroundColor(.appTextPrimary)
                        }
                        Spacer()
                        
                        // ANLAMADIĞIN DEĞİŞİKLİK BURASI AGA:
                        // Düz resmi sildik, yerine tıklanabilir ve bizi Profile uçuran bu butonu koyduk:
                        Button(action: {
                            navigateToProfile = true // Butona basılınca bu durumu 'true' yapıyoruz
                        }) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 36))
                                .foregroundColor(.appAccent)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    // --- ÜST BAR (HEADER) BİTİŞİ ---
                    
                    // Kampanya Kartı
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Weekly Offer")
                            .font(.caption)
                            .bold()
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.appBackground)
                            .foregroundColor(.appAccent)
                            .cornerRadius(4)
                        
                        Text("Hair + Beard + Facial Mask Combo")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        
                        Text("Only 500 TL for this week!")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(LinearGradient(colors: [.appAccent, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    Text("Services")
                        .font(.headline)
                        .foregroundColor(.appTextPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    // Hizmetler Listesi
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView("Loading services...")
                            .tint(.appAccent)
                            .foregroundColor(.appTextSecondary)
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(viewModel.services) { service in
                                    Button(action: {
                                        viewModel.selectService(service)
                                    }) {
                                        ServiceCardView(
                                            title: service.title,
                                            price: service.price,
                                            duration: service.duration,
                                            iconName: service.iconName,
                                            isSelected: viewModel.selectedService?.id == service.id
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Randevu Al Butonu
                    Button(action: {
                        if viewModel.selectedService != nil {
                            navigateToBooking = true
                        }
                    }) {
                        Text("Book Appointment")
                            .font(.headline)
                            .foregroundColor(.appBackground)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(viewModel.selectedService != nil ? Color.appAccent : Color.appTextSecondary.opacity(0.3))
                            .cornerRadius(12)
                    }
                    .disabled(viewModel.selectedService == nil || viewModel.isLoading)
                    .padding(.horizontal)
                    .padding(.bottom, 15)
                }
            }
            .task {
                await viewModel.loadServices()
            }
            // --- GEÇİŞ ROTASYONLARI (NAVIGATION DESTINATIONS) ---
            
            // 1. Randevu ekranına giden yol
            .navigationDestination(isPresented: $navigateToBooking) {
                if let selectedService = viewModel.selectedService {
                    BookingView(currentUser: currentUser, selectedService: selectedService)
                }
            }

            .navigationDestination(isPresented: $navigateToProfile) {
                ProfileView(currentUser: currentUser)
            }
        }
    }
}

#Preview {
    HomeView(currentUser: User(id: "1", fullName: "Emirhan Sky", email: "test@gmail.com", phoneNumber: "123", role: .customer))
}
