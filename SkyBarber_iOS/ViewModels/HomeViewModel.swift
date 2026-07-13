//
//  HomeViewModel.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 14.07.2026.
//

import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var services: [Service] = []
    @Published var selectedService: Service?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let serviceService: ServiceServiceProtocol
    
    init(serviceService: ServiceServiceProtocol = MockServiceService()) {
        self.serviceService = serviceService
    }
    
    func loadServices() async {
        isLoading = true
        errorMessage = nil
        
        do {
            self.services = try await serviceService.fetchServices()
            self.isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
    
    func selectService(_ service: Service) {
        selectedService = service
    }
}
