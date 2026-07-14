import Foundation
import Combine

@MainActor
class BookingViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var isSuccess = false
    @Published var errorMessage: String?
    
    private let serviceService: ServiceServiceProtocol
    
    // Berber dükkanının standart tüm saatleri
    private let allTimeSlots = [
        "09:00", "10:00", "11:00",
        "13:00", "14:00", "15:00",
        "16:00", "17:00", "18:00"
    ]
    
    init(serviceService: ServiceServiceProtocol = FirebaseStoreService()) {
        self.serviceService = serviceService
    }
    
    /// Seçilen tarihe göre sadece gelecekteki uygun saat dilimlerini döner
    func getAvailableSlots(for date: Date) -> [String] {
        let calendar = Calendar.current
        
        // 1. Seçilen gün bugün mü kontrol et
        if calendar.isDateInToday(date) {
            // Şu anki saati al (Örn: "12:30" ise hour = 12, minute = 30)
            let now = Date()
            let currentHour = calendar.component(.hour, from: now)
            let currentMinute = calendar.component(.minute, from: now)
            
            // Tüm slotları tek tek filtrele
            return allTimeSlots.filter { slot in
                let parts = slot.split(separator: ":")
                guard parts.count == 2,
                      let slotHour = Int(parts[0]),
                      let slotMinute = Int(parts[1]) else { return false }
                
                // Slot saati şu anki saatten büyükse OK
                if slotHour > currentHour {
                    return true
                }
                // Saatler eşitse dakikaya bak (Örn: slot 12:30, şu an 12:15 ise alınabilir)
                else if slotHour == currentHour {
                    return slotMinute > currentMinute
                }
                
                return false
            }
        }
        
        // 2. Seçilen gün gelecek bir günse, tüm saatleri serbest bırak
        return allTimeSlots
    }
    
    func bookAppointment(user: User, service: Service, date: Date, timeSlot: String) async {
        isLoading = true
        errorMessage = nil
        
        // Pazar günü kontrolü
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
