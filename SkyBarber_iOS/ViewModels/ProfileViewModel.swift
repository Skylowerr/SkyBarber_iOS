//
//  ProfileViewModel.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 14.07.2026.
//

import Foundation
import Combine
@MainActor
class ProfileViewModel: ObservableObject {
    @Published var upcomingAppointments: [Appointment] = []
    @Published var pastAppointments: [Appointment] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let serviceService: ServiceServiceProtocol
    
    init(serviceService: ServiceServiceProtocol = MockServiceService()) {
        self.serviceService = serviceService
    }
    
    func loadAppointments(for userId: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let allAppointments = try await serviceService.fetchUserAppointments(userId: userId)
            let now = Date()
            
            // Tarih kıyaslaması ile randevuları ayırıyoruz
            self.upcomingAppointments = allAppointments.filter { $0.date >= now && $0.status != .cancelled }
            self.pastAppointments = allAppointments.filter { $0.date < now || $0.status == .cancelled }
            
            self.isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
    
    func cancelAppointment(id: String, userId: String) async {
        isLoading = true
        do {
            try await serviceService.cancelAppointment(appointmentId: id)
            // Listeyi yeniden yükle
            await loadAppointments(for: userId)
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
}
