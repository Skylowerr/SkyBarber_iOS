import XCTest
@testable import SkyBarber_iOS

@MainActor
final class BookingViewModelTests: XCTestCase {
    var viewModel: BookingViewModel!
    var mockService: MockServiceService!

    override func setUpWithError() throws {
        mockService = MockServiceService()
        viewModel = BookingViewModel(serviceService: mockService)
    }

    // tearDownWithError metodunu sildik, arka plan Task'larının çakışmasını engelliyor!

    func test_bookAppointment_withoutTimeSlot_shouldSetErrorMessage() async {
        // Given
        let dummyUser = User(id: "u1", fullName: "Test User", email: "t@t.com", phoneNumber: "123", role: .customer)
        let dummyService = Service(id: "s1", title: "Haircut", price: 300, duration: 30, iconName: "scissors")

        // When
        await viewModel.bookAppointment(service: dummyService, user: dummyUser)

        // Then
        XCTAssertFalse(viewModel.isBookingSuccess)
        XCTAssertEqual(viewModel.errorMessage, "Please select a time slot.")
    }

    func test_bookAppointment_success_shouldSetIsBookingSuccessTrue() async {
        // Given
        let dummyUser = User(id: "u1", fullName: "Test User", email: "t@t.com", phoneNumber: "123", role: .customer)
        let dummyService = Service(id: "s1", title: "Haircut", price: 300, duration: 30, iconName: "scissors")
        
        viewModel.selectedTimeSlot = "14:00"

        // When
        await viewModel.bookAppointment(service: dummyService, user: dummyUser)

        // Then
        XCTAssertTrue(viewModel.isBookingSuccess)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    func test_resetStatus_shouldClearState() {
        // Given
        viewModel.isBookingSuccess = true
        viewModel.errorMessage = "Some error"
        viewModel.selectedTimeSlot = "14:00"

        // When
        viewModel.resetStatus()

        // Then
        XCTAssertFalse(viewModel.isBookingSuccess)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertNil(viewModel.selectedTimeSlot)
    }
}
