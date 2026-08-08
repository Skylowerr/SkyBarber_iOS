# ✂️ SkyBarber iOS - Native Barber Appointment Automation

SkyBarber iOS is the native mobile counterpart of the SkyBarber platform, built for barber shop management and appointment automation. Built using Swift and SwiftUI with a clean MVVM architecture, it shares the same Firebase Firestore backend as the web application, follows enterprise-level architecture patterns, and ships with a fully automated CI pipeline and testing suite.

---

## 🚀 Distribution

- **Platform:** iOS (native app, no browser-based deployment)
- **Shared Backend:** Connects to the same Firebase Cloud Firestore project used by the [SkyBarber web app](https://skybarber.vercel.app), keeping data (appointments, services, users) in sync across both platforms.

---

## 🛠️ Architecture & Tech Stack

### App
- **Language:** Swift
- **UI Framework:** SwiftUI
- **Architecture Pattern:** MVVM (Model-View-ViewModel)
- **Modules:** `App`, `Core`, `Models`, `Services`, `ViewModels`, `Views`

### Backend Integration
- **Database:** Firebase Cloud Firestore (NoSQL Document Database) — shared with the web backend
- **Firebase SDK:** Swift Package Manager (Firebase, AppCheck, GoogleAppMeasurement, gRPC, etc.)
- **Configuration:** `GoogleService-Info.plist` (excluded from version control, injected securely in CI via GitHub Secrets)

### DevOps & Testing
- **CI Pipeline:** GitHub Actions, running on GitHub-hosted `macos-26` runners with Xcode 26
- **Unit Testing:** XCTest (business logic, ViewModels)
- **UI Testing:** XCTest UI Testing (XCUITest), driven through the iOS Simulator
- **Build Tool:** `xcodebuild`

---

## 🧪 Testing and Execution Commands

Tests run automatically against the iOS Simulator; no separate server needs to be started manually.

| Test Type | Target | Command | Description |
| :--- | :--- | :--- | :--- |
| **Unit Tests (XCTest)** | `SkyBarber_iOSTests` | `xcodebuild test -project SkyBarber_iOS.xcodeproj -scheme SkyBarber_iOS -destination 'platform=iOS Simulator,name=iPhone 17'` | Validates ViewModel logic (auth, booking, services, admin flows). |
| **UI Tests (XCUITest)** | `SkyBarber_iOSUITests` | Runs as part of the same `xcodebuild test` invocation | Simulates real user interaction across the app's UI flows. |
| **Local run (Xcode)** | — | `Cmd + U` in Xcode | Runs the full test suite locally for quick iteration. |

---

## ⚙️ Automated CI Pipeline Workflow

The CI pipeline triggers on every codebase synchronization (`push` or `pull_request` to `main` and `default` branches):

1. **Environment Setup:** Selects the appropriate Xcode 26 version on the `macos-26` runner.
2. **Dependency Resolution:** Resolves Swift Package Manager dependencies, including the Firebase SDK.
3. **Secure Configuration Injection:** Decodes and writes the `GoogleService-Info.plist` from an encrypted GitHub Secret so Firebase-dependent code builds and runs correctly in CI.
4. **Continuous Integration (CI):** Builds the app and runs the full **Unit & UI Testing Suite** on the iOS Simulator.
5. **Artifact Upload:** Uploads the `.xcresult` test bundle as a workflow artifact for inspection.

> **Note on deployment:** Unlike the web app, there is currently no automated Continuous Deployment (CD) step (e.g. no TestFlight/App Store upload yet). The pipeline focuses on CI — build verification and automated testing — with release distribution planned as a future addition.
