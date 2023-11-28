//
//  UITestHelpers.swift
//  SampleDeeplinkUITests
//
//  Created by Mehmet Emin Deniz on 28.11.2023.
//

import XCTest

final class UITestHelpers {

    static let shared = UITestHelpers()
    private init() {}

    private let safari: XCUIApplication = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")

    /// Opens safari with given url
    /// - Parameter url: URL of the deeplink.
    func openWithSafari(app: XCUIApplication, url: String) {
        if safari.state != .notRunning {
            // Safari can get in to bugs depending on too many tests.
            // Better to kill at at the beginning.
            safari.terminate()
            _ = safari.wait(for: .notRunning, timeout: 5)
        }

        safari.launch()

        // Ensure that safari is running
        _ = safari.wait(for: .runningForeground, timeout: 30)

        // Access the search bar of the safari
        let searchBar = safari.descendants(matching: .any).matching(identifier: "Address"/*.localized()*/).firstMatch
        searchBar.tap()

        // Enter the URL
        safari.typeText(url)

        // Simulate "Return" key tap
        safari.typeText("\n")

        // Tap "Open" on confirmation dialog
        let localizedOpen = "Open"//.localized()
        safari.buttons[localizedOpen].tap()

        // Wait for the app to start
        _ = app.wait(for: .runningForeground, timeout: 5)
    }

    func waitFor(element: XCUIElement,
                 failIfNotExist: Bool = true,
                         timeOut: TimeInterval = 15.0) {
        if !element.waitForExistence(timeout: timeOut) {
            if failIfNotExist {
                XCTFail("Could not find \(element.description) within \(timeOut) seconds")
            }
        }
    }

}
