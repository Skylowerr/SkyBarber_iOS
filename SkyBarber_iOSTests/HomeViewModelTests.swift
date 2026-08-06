import XCTest
@testable import SkyBarber_iOS

@MainActor
final class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    var mockService: MockServiceService!

    override func setUp() {
        super.setUp()
        mockService = MockServiceService()
        viewModel = HomeViewModel(serviceService: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testLoadServices_PopulatesServicesList() async {
        // When (Eylem)
        await viewModel.loadServices()
        
        // Then (Sonuç)
        XCTAssertFalse(viewModel.isLoading, "İşlem bitince yükleme durumu kapanmalı")
        XCTAssertFalse(viewModel.services.isEmpty, "Hizmetler listesi dolmalı (Mock servis verileri gelmeli)")
        XCTAssertNil(viewModel.errorMessage, "Hata mesajı olmamalı")
    }
    
    func testSelectService_SetsSelectedService() {
        // Given
        let mockServiceItem = Service(id: "s1", title: "Saç Kesimi", price: 200, duration: 30, iconName: "scissors")
        
        // When
        viewModel.selectService(mockServiceItem)
        
        // Then
        XCTAssertNotNil(viewModel.selectedService, "Seçilen servis boş olmamalı")
        XCTAssertEqual(viewModel.selectedService?.id, "s1", "Seçilen servisin ID'si doğru atanmalı")
        XCTAssertEqual(viewModel.selectedService?.title, "Saç Kesimi", "Seçilen servisin adı doğru atanmalı")
    }
}
