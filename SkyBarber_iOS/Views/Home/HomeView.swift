import SwiftUI

struct HomeView: View {
    // 1. Inject ViewModels
    @StateObject private var viewModel = HomeViewModel()
    @State private var navigateToBooking = false
    
    // Pass User info down from active session
    let currentUser: User
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Header
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
                        
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.appAccent)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Promo Card
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
                    
                    // Services List with Loading State
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
                    
                    // Book Appointment Button
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
                // Fetch services when page loads (Modern swift load hook)
                await viewModel.loadServices()
            }
            .navigationDestination(isPresented: $navigateToBooking) {
                if let selectedService = viewModel.selectedService {
                    BookingView(currentUser: currentUser, selectedService: selectedService)
                }
            }
        }
    }
}

#Preview {
    HomeView(currentUser: User(id: "1", fullName: "Emirhan Sky", email: "test@gmail.com", phoneNumber: "123", role: .customer))
}
