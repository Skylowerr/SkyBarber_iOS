import XCTest

final class SkyBarber_iOSUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func test_LoginFlow_FillsFieldsAndTapsLogin() throws {
        // 1. E-posta alanını doğrudan içindeki silik yazıdan (Placeholder) buluyoruz!
        let emailTextField = app.textFields["Email Address"]
        XCTAssertTrue(emailTextField.waitForExistence(timeout: 5.0), "E-posta alanı bulunamadı aga!")
        
        emailTextField.tap()
        emailTextField.typeText("test@gmail.com")
        
        // 2. Şifre alanını da doğrudan kendi adıyla buluyoruz
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists, "Şifre alanı bulunamadı!")
        
        passwordTextField.tap()
        passwordTextField.typeText("123456")
        
        // Klavyeyi kapatmak için boşluğa tıkla
        app.tap()
        
        // 3. Giriş Yap butonu (Buna daha önce doğru şekilde ID vermiştik, o yüzden ID ile bulabiliriz)
        let loginButton = app.buttons["loginButton"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 2.0), "Giriş butonu ekranda yok!")
        
        loginButton.tap()
    }
}
