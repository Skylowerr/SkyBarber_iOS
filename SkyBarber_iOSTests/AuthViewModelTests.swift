import XCTest
@testable import SkyBarber_iOS

@MainActor
final class AuthViewModelTests: XCTestCase {
    var viewModel: AuthViewModel!
    var mockAuthService: MockAuthService!

    override func setUpWithError() throws {
        mockAuthService = MockAuthService()
        viewModel = AuthViewModel(authService: mockAuthService)
    }

    // tearDownWithError KALDIRILDI (SIGABRT Çökmesini Önler)

    func test_login_success_shouldSetCurrentUser() async {
        // Given
        let validEmail = "test@gmail.com"
        let validPassword = "123456"

        // When
        await viewModel.login(email: validEmail, password: validPassword)

        // Then
        XCTAssertNotNil(viewModel.currentUser)
        XCTAssertEqual(viewModel.currentUser?.email, validEmail)
        XCTAssertEqual(viewModel.currentUser?.fullName, "Emirhan Sky")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    func test_login_failure_shouldSetErrorMessage() async {
        // Given
        let invalidEmail = "test@gmail.com"
        let wrongPassword = "wrong_password"

        // When
        await viewModel.login(email: invalidEmail, password: wrongPassword)

        // Then
        XCTAssertNil(viewModel.currentUser)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "Invalid credentials.")
        XCTAssertFalse(viewModel.isLoading)
    }

    func test_logout_shouldClearCurrentUser() async {
        // Given
        await viewModel.login(email: "test@gmail.com", password: "123456")
        XCTAssertNotNil(viewModel.currentUser)

        // When
        await viewModel.logout()

        // Then
        XCTAssertNil(viewModel.currentUser)
    }
}
