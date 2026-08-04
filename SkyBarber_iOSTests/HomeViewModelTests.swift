import XCTest
@testable import SkyBarber_iOS

@MainActor
final class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    var mockService: MockServiceService!

    override func setUpWithError() throws {
        mockService = MockServiceService()
        viewModel = HomeViewModel(serviceService: mockService)
    }

    // tearDownWithError KALDIRILDI (SIGABRT Çökmesini Önler)

    func test_loadServices_success_shouldPopulateServicesFromMock() async {
        // When
        await viewModel.loadServices()

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.services.count, 4)
        XCTAssertEqual(viewModel.services.first?.title, "Haircut")
        XCTAssertEqual(viewModel.services.first?.price, 300.0)
        XCTAssertNil(viewModel.errorMessage)
    }

    func test_selectService_shouldSetSelectedService() {
        // Given
        let dummyService = Service(
            id: "1",
            title: "Haircut",
            price: 300.0,
            duration: 30,
            iconName: "scissors"
        )

        // When
        viewModel.selectService(dummyService)

        // Then
        XCTAssertEqual(viewModel.selectedService?.id, "1")
        XCTAssertEqual(viewModel.selectedService?.title, "Haircut")
    }
}
