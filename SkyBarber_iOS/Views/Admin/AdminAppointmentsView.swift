import SwiftUI

struct AdminAppointmentsView: View {
    @StateObject private var viewModel = AdminAppointmentsViewModel()
    @ObservedObject var authViewModel: AuthViewModel
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Yükleniyor...")
                } else if viewModel.appointments.isEmpty {
                    Text("Henüz randevu yok.")
                        .foregroundColor(.gray)
                } else {
                    List(viewModel.appointments) { appointment in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(appointment.userName)
                                .font(.headline)
                            Text("\(appointment.serviceTitle) - \(appointment.timeSlot)")
                                .font(.subheadline)
                            Text(appointment.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text(appointment.status.rawValue.uppercased())
                                .font(.caption2)
                                .padding(5)
                                .background(statusColor(for: appointment.status))
                                .cornerRadius(5)
                        }
                    }
                }
            }
            .navigationTitle("Tüm Randevular")
            .toolbar {
                            // ADMIN ÇIKIŞ BUTONU
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    Task {
                                        await authViewModel.logout()
                                    }
                                }) {
                                    Image(systemName: "power")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                }
                            }
            }
            .onAppear {
                Task {
                    await viewModel.loadAllAppointments()
                }
            }
        }
    }
    
    private func statusColor(for status: Appointment.AppointmentStatus) -> Color {
        switch status {
        case .pending: return Color.orange.opacity(0.8)
        case .confirmed: return Color.green.opacity(0.8)
        case .cancelled: return Color.red.opacity(0.8)
        }
    }
}

#Preview {
    AdminAppointmentsView(
        authViewModel: AuthViewModel(authService: MockAuthService()) // <-- BURAYI EKLE
    )
}
