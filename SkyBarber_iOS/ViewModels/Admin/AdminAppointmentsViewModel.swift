import Foundation
import Combine

@MainActor
class AdminAppointmentsViewModel: ObservableObject {
    @Published var appointments: [Appointment] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let serviceService: ServiceServiceProtocol
    
    init(serviceService: ServiceServiceProtocol = FirebaseStoreService()) {
        self.serviceService = serviceService
    }
    
    func loadAllAppointments() async {
        isLoading = true
        errorMessage = nil
        do {
            self.appointments = try await serviceService.fetchAllAppointments()
            self.isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
}
