import XCTest
@testable import SkyBarber_iOS

@MainActor
final class AuthViewModelTests: XCTestCase {
    var viewModel: AuthViewModel!
    var mockAuthService: MockAuthService! // Senin projendeki mevcut servis

    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthService()
        viewModel = AuthViewModel(authService: mockAuthService)
    }

    override func tearDown() {
        viewModel = nil
        mockAuthService = nil
        super.tearDown()
    }

    func testLogin_Successful_SetsCurrentUser() async {
        // Given & When (Senin mock servisteki doğru şifreler)
        await viewModel.login(email: "test@gmail.com", password: "123456")
        
        // Then
        XCTAssertNotNil(viewModel.currentUser, "Doğru bilgilerle giriş yapıldığında currentUser nil olmamalı")
        XCTAssertEqual(viewModel.currentUser?.fullName, "Emirhan Sky", "Mock servisteki isim gelmeli")
        XCTAssertNil(viewModel.errorMessage, "Başarılı girişte hata mesajı olmamalı")
    }
    
    func testLogin_Failure_SetsErrorMessage() async {
        // Given & When (Yanlış şifre ile deniyoruz)
        await viewModel.login(email: "yanlis@gmail.com", password: "wrong")
        
        // Then
        XCTAssertNil(viewModel.currentUser, "Yanlış girişte oturum açılmamalı")
        XCTAssertNotNil(viewModel.errorMessage, "Hata mesajı ekrana basılmalı")
    }

    func testLogout_ClearsCurrentUser() async {
        // Given (Önce başarılı giriş yapıyoruz)
        await viewModel.login(email: "test@gmail.com", password: "123456")
        XCTAssertNotNil(viewModel.currentUser)
        
        // When
        await viewModel.logout()
        
        // Then
        XCTAssertNil(viewModel.currentUser, "Çıkış yapıldıktan sonra oturum temizlenmeli")
    }
}
