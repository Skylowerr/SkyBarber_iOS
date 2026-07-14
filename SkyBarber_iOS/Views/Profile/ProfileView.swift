import SwiftUI

// 1. Define the Tab types clearly using a Swift Enum
enum ProfileTab {
    case upcoming
    case past
}

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel // Global session brain to handle logout
    @StateObject private var viewModel = ProfileViewModel()
    
    let currentUser: User
    
    // 2. State variable restricted to only our Enum values (Type-Safe)
    @State private var selectedTab: ProfileTab = .upcoming
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header & Back/Logout Buttons
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.appAccent)
                    }
                    Spacer()
                    Text("My Profile")
                        .font(.title3.bold())
                        .foregroundColor(.appTextPrimary)
                    Spacer()
                    
                    // Logout Action
                    Button(action: {
                        Task {
                            await authViewModel.logout()
                        }
                    }) {
                        Image(systemName: "power")
                            .font(.title3)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // User Quick Info Card
                HStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.appAccent)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(currentUser.fullName)
                            .font(.title3.bold())
                            .foregroundColor(.appTextPrimary)
                        Text(currentUser.email)
                            .font(.subheadline)
                            .foregroundColor(.appTextSecondary)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.appCardBackground)
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Custom Segmented Picker with Enum mapping
                HStack(spacing: 0) {
                    Button(action: { selectedTab = .upcoming }) {
                        VStack(spacing: 8) {
                            Text("Upcoming")
                                .font(.headline)
                                .foregroundColor(selectedTab == .upcoming ? .appAccent : .appTextSecondary)
                            Rectangle()
                                .fill(selectedTab == .upcoming ? Color.appAccent : Color.clear)
                                .frame(height: 2)
                        }
                    }
                    
                    Button(action: { selectedTab = .past }) {
                        VStack(spacing: 8) {
                            Text("History")
                                .font(.headline)
                                .foregroundColor(selectedTab == .past ? .appAccent : .appTextSecondary)
                            Rectangle()
                                .fill(selectedTab == .past ? Color.appAccent : Color.clear)
                                .frame(height: 2)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Dynamic Appointment List with Loading Handler
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .tint(.appAccent)
                    Spacer()
                } else {
                    // Match the correct ViewModel array with active tab
                    let listToShow = selectedTab == .upcoming ? viewModel.upcomingAppointments : viewModel.pastAppointments
                    
                    if listToShow.isEmpty {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 50))
                                .foregroundColor(.appTextSecondary.opacity(0.5))
                            Text("No appointments found.")
                                .font(.headline)
                                .foregroundColor(.appTextSecondary)
                        }
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(listToShow) { appointment in
                                    AppointmentCard(appointment: appointment) {
                                        Task {
                                            await viewModel.cancelAppointment(id: appointment.id, userId: currentUser.id)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            // Fetch appointments dynamically on page load
            await viewModel.loadAppointments(for: currentUser.id)
        }
    }
}

// MARK: - Appointment Card Component (SOLID - Single Responsibility)
struct AppointmentCard: View {
    let appointment: Appointment
    var onCancel: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(appointment.serviceTitle)
                    .font(.headline)
                    .foregroundColor(.appTextPrimary)
                Spacer()
                
                // Status Badge
                Text(appointment.status.rawValue.uppercased())
                    .font(.caption2.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.15))
                    .foregroundColor(statusColor)
                    .cornerRadius(6)
            }
            
            Divider()
                .background(Color.appTextSecondary.opacity(0.2))
            
            HStack(spacing: 15) {
                Label(appointment.date.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                Label(appointment.timeSlot, systemImage: "clock")
            }
            .font(.subheadline)
            .foregroundColor(.appTextSecondary)
            
            // Show cancel button only if the appointment is pending and in the future
            if appointment.status == .pending && appointment.date >= Date() {
                Button(action: onCancel) {
                    Text("Cancel Appointment")
                        .font(.subheadline.bold())
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color.appCardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.appTextSecondary.opacity(0.1), lineWidth: 1)
        )
    }
    
    var statusColor: Color {
        switch appointment.status {
        case .confirmed: return .green
        case .pending: return .appAccent
        case .cancelled: return .red
        }
    }
}

#Preview {
    ProfileView(
        currentUser: User(
            id: "mock_user_123",
            fullName: "Emirhan Sky",
            email: "test@gmail.com",
            phoneNumber: "+905555555555",
            role: .customer
        )
    )
    .preferredColorScheme(.dark)
    .environmentObject(AuthViewModel()) // Kırmızı hata almamak için bu şart aga!
}
