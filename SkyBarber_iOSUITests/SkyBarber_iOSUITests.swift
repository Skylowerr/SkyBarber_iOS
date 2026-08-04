import XCTest

final class SkyBarber_iOSUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func test_loginScreen_elementsExist() throws {
        // CustomTextField içindeki İngilizce placeholder değerlerini arıyoruz
        let emailTextField = app.textFields["Email Address"]
        let passwordSecureField = app.secureTextFields["Password"]

        // 5 saniye tolerate
        XCTAssertTrue(emailTextField.waitForExistence(timeout: 5.0), "Email Address alanı bulunamadı!")
        XCTAssertTrue(passwordSecureField.exists, "Password alanı bulunamadı!")
    }
}
