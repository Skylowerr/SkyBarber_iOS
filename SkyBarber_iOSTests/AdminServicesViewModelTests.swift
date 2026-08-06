//
//  AdminServicesViewModelTests.swift
//  SkyBarber_iOSTests
//
//  Created by Emirhan Gökçe on 6.08.2026.
//

import XCTest
@testable import SkyBarber_iOS

@MainActor
final class AdminServicesViewModelTests: XCTestCase {
    var viewModel: AdminServicesViewModel!
    var mockService: MockServiceService!

    override func setUp() {
        super.setUp()
        mockService = MockServiceService()
        viewModel = AdminServicesViewModel(serviceService: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testLoadServices_SuccessfullyFetchesServices() async {
        await viewModel.loadServices()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.services.isEmpty, "Mock veriler başarıyla ViewModel'e yüklenmeli")
    }

    func testSaveService_AddsNewService() async {
        let isSuccess = await viewModel.saveService(id: nil, title: "Yeni VIP Bakım", price: 500, duration: 60, iconName: "star")
        
        XCTAssertTrue(isSuccess, "Kayıt işlemi başarılı dönmeli")
        
        let allServices = try? await mockService.fetchServices()
        XCTAssertTrue(allServices?.contains(where: { $0.title == "Yeni VIP Bakım" }) ?? false, "Hizmet mock servise eklenmiş olmalı")
    }

    func testDeleteService_RemovesService() async {
            await viewModel.loadServices()
            let initialCount = viewModel.services.count
            
            guard initialCount > 0 else { return }
            
            let offsets = IndexSet(integer: 0)
            viewModel.deleteService(at: offsets)
            
            // Mock servisindeki gecikmeyi tolere edebilmek için bekleme süresini 1.5 saniyeye çıkardık
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            
            XCTAssertEqual(viewModel.services.count, initialCount - 1, "Listeden bir hizmet silinmiş olmalı")
        }
}
