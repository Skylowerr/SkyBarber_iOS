//
//  BookingViewModel.swift
//  SkyBarber_iOS
//
//  Created by Emirhan Gökçe on 14.07.2026.
//

import Foundation
import Combine

@MainActor
class BookingViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var isSuccess = false
    @Published var errorMessage: String?
    
    private let serviceService: ServiceServiceProtocol
    
    init(serviceService: ServiceServiceProtocol = MockServiceService()) {
        self.serviceService = serviceService
    }
    
    func bookAppointment(user: User, service: Service, date: Date, timeSlot: String) async {
        isLoading = true
        errorMessage = nil
        
        // Solid Business Rule: Quick validation example (No appointments on Sundays)
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        if weekday == 1 { // 1 = Sunday
            self.errorMessage = "We are closed on Sundays. Please pick another day!"
            self.isLoading = false
            return
        }
        
        let appointment = Appointment(
            id: UUID().uuidString,
            userId: user.id,
            userName: user.fullName,
            serviceId: service.id,
            serviceTitle: service.title,
            date: date,
            timeSlot: timeSlot,
            status: .pending
        )
        
        do {
            try await serviceService.bookAppointment(appointment: appointment)
            self.isSuccess = true
            self.isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
    
    func resetStatus() {
        isSuccess = false
        errorMessage = nil
    }
}
