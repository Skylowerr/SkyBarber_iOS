import XCTest

final class SkyBarber_iOSUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func test_loginScreen_elementsExist() throws {
        let emailTextField = app.textFields["E-posta"]
        let passwordSecureField = app.secureTextFields["Şifre"]
        let loginButton = app.buttons["Giriş Yap"]

        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(passwordSecureField.exists)
        XCTAssertTrue(loginButton.exists)
    }
}
