import Foundation
import Combine

@MainActor
class AdminServicesViewModel: ObservableObject {
    @Published var services: [Service] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let serviceService: ServiceServiceProtocol
    
    init(serviceService: ServiceServiceProtocol = FirebaseStoreService()) {
        self.serviceService = serviceService
    }
    
    func loadServices() async {
        isLoading = true
        do {
            self.services = try await serviceService.fetchServices()
            self.isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
    
    func deleteService(at offsets: IndexSet) {
        offsets.forEach { index in
            let service = services[index]
            Task {
                do {
                    try await serviceService.deleteService(serviceId: service.id)
                    await loadServices()
                } catch {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func saveService(id: String?, title: String, price: Double, duration: Int, iconName: String) async -> Bool {
        isLoading = true
        let isNew = id == nil
        let serviceId = id ?? UUID().uuidString
        let service = Service(id: serviceId, title: title, price: price, duration: duration, iconName: iconName)
        
        do {
            if isNew {
                try await serviceService.addService(service: service)
            } else {
                try await serviceService.updateService(service: service)
            }
            await loadServices()
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            return false
        }
    }
}
