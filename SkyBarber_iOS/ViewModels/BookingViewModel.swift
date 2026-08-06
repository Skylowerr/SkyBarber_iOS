import Foundation
import Combine

@MainActor
class BookingViewModel: ObservableObject {
    @Published var selectedDate = Date()
    @Published var selectedTimeSlot: String?
    @Published var availableTimeSlots: [String] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isBookingSuccess = false
    
    private let serviceService: ServiceServiceProtocol
    private var bookedSlotsForSelectedDate: [String] = []
    
    let allTimeSlots = [
        "09:00", "10:00", "11:00", "12:00",
        "13:00", "14:00", "15:00", "16:00",
        "17:00", "18:00", "19:00", "20:00"
    ]
    
    init(serviceService: ServiceServiceProtocol = FirebaseStoreService()) {
        self.serviceService = serviceService
        Task {
            await fetchBookedSlotsAndGenerateAvailable()
        }
    }
    
    // View tarafında çağrılan fonksiyonlar
    func onDateChanged() {
        Task {
            await fetchBookedSlotsAndGenerateAvailable()
        }
    }
    
    func resetStatus() {
        isBookingSuccess = false
        errorMessage = nil
        selectedTimeSlot = nil
    }
    
    func fetchBookedSlotsAndGenerateAvailable() async {
        let calendar = Calendar.current
        let now = Date()
        
        let isToday = calendar.isDateInToday(selectedDate)
        let currentHour = calendar.component(.hour, from: now)
        let currentMinute = calendar.component(.minute, from: now)
        
        self.availableTimeSlots = allTimeSlots.filter { slot in
            if isToday {
                let components = slot.split(separator: ":").compactMap { Int($0) }
                if components.count == 2 {
                    let slotHour = components[0]
                    let slotMinute = components[1]
                    
                    if slotHour < currentHour || (slotHour == currentHour && slotMinute <= currentMinute) {
                        return false
                    }
                }
            }
            
            if bookedSlotsForSelectedDate.contains(slot) {
                return false
            }
            
            return true
        }
    }
    
    func bookAppointment(service: Service, user: User) async {
        guard let timeSlot = selectedTimeSlot else {
            errorMessage = "Please select a time slot."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let calendar = Calendar.current
        let timeComponents = timeSlot.split(separator: ":").compactMap { Int($0) }
        
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        if timeComponents.count == 2 {
            dateComponents.hour = timeComponents[0]
            dateComponents.minute = timeComponents[1]
        }
        
        let exactAppointmentDate = calendar.date(from: dateComponents) ?? selectedDate
        
        let newAppointment = Appointment(
            id: UUID().uuidString,
            userId: user.id,
            userName: user.fullName,
            serviceId: service.id,
            serviceTitle: service.title,
            date: exactAppointmentDate,
            timeSlot: timeSlot,
            status: .pending
        )
        
        do {
            try await serviceService.bookAppointment(appointment: newAppointment)
            isLoading = false
            isBookingSuccess = true
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
}
