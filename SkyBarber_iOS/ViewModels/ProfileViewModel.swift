import Foundation
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var appointments: [Appointment] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedTab: ProfileTab = .upcoming
    
    enum ProfileTab {
        case upcoming
        case past
    }
    
    private let serviceService: ServiceServiceProtocol
    
    init(serviceService: ServiceServiceProtocol = FirebaseStoreService()) {
        self.serviceService = serviceService
    }
    
    // Gelecekteki veya henüz vakti geçmemiş aktif randevular
    var upcomingAppointments: [Appointment] {
        let now = Date()
        return appointments.filter { appointment in
            appointment.status != .cancelled && appointment.date >= now.addingTimeInterval(-3600)
        }.sorted(by: { $0.date < $1.date })
    }
    
    // Tarihi geçmiş veya iptal edilmiş randevular (View'deki .past ismiyle birebir eşlendi)
    var pastAppointments: [Appointment] {
        let now = Date()
        return appointments.filter { appointment in
            appointment.status == .cancelled || appointment.date < now.addingTimeInterval(-3600)
        }.sorted(by: { $0.date > $1.date })
    }
    
    func loadAppointments(userId: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            self.appointments = try await serviceService.fetchUserAppointments(userId: userId)
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
    
    func cancelAppointment(id: String, userId: String) async {
        do {
            try await serviceService.cancelAppointment(appointmentId: id)
            await loadAppointments(userId: userId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
