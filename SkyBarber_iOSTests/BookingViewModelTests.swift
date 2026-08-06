import XCTest
@testable import SkyBarber_iOS

@MainActor
final class BookingViewModelTests: XCTestCase {
    var viewModel: BookingViewModel!
    var mockService: MockServiceService!

    override func setUp() {
        super.setUp()
        mockService = MockServiceService()
        viewModel = BookingViewModel(serviceService: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testBookAppointment_SuccessfullyAddsToDatabase() async {
        // Given (Hazırlık)
        let mockUser = User(id: "user1", fullName: "Emirhan Sky", email: "test@gmail.com", phoneNumber: "123456", role: .customer)
        let mockServiceItem = Service(id: "s1", title: "Saç Kesimi", price: 200, duration: 30, iconName: "scissors")
        
        // Randevu oluşturabilmek için önce ViewModel'de bir saat seçildiğini simüle ediyoruz
        viewModel.selectedTimeSlot = "14:00"
        
        // When (Eylem)
        await viewModel.bookAppointment(service: mockServiceItem, user: mockUser)
        
        // Then (Sonuç)
        XCTAssertTrue(viewModel.isBookingSuccess, "Randevu işlemi başarılı olarak işaretlenmeli")
        XCTAssertFalse(viewModel.isLoading, "Yükleme durumu bitmeli")
        XCTAssertNil(viewModel.errorMessage, "Hata mesajı olmamalı")
        
        // Mock servise gerçekten kaydedilmiş mi diye teyit ediyoruz
        let savedAppointments = try? await mockService.fetchUserAppointments(userId: "user1")
        XCTAssertEqual(savedAppointments?.count, 1, "Mock servise 1 randevu eklenmiş olmalı")
        XCTAssertEqual(savedAppointments?.first?.timeSlot, "14:00", "Kaydedilen saat doğru olmalı")
    }
    
    func testBookAppointment_FailsWhenNoTimeSlotSelected() async {
        // Given
        let mockUser = User(id: "user1", fullName: "Emirhan", email: "test@test.com", phoneNumber: "123", role: .customer)
        let mockServiceItem = Service(id: "s1", title: "Saç Kesimi", price: 200, duration: 30, iconName: "scissors")
        
        // Bilerek saat SEÇMİYORUZ
        viewModel.selectedTimeSlot = nil
        
        // When
        await viewModel.bookAppointment(service: mockServiceItem, user: mockUser)
        
        // Then
        XCTAssertFalse(viewModel.isBookingSuccess, "Saat seçilmediği için başarılı olmamalı")
        XCTAssertEqual(viewModel.errorMessage, "Please select a time slot.", "Doğru hata mesajını ekrana basmalı")
    }
}
