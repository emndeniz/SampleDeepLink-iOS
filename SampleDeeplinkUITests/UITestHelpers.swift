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
    private let spotlight = XCUIApplication(bundleIdentifier: "com.apple.Spotlight")

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
        // Note: 'Address' needs to be localized if the simulator language is not english
        let searchBar = safari.descendants(matching: .any).matching(identifier: "Address").firstMatch
        searchBar.tap()

        // Enter the URL
        safari.typeText(url)

        // Simulate "Return" key tap
        safari.typeText("\n")

        // Tap "Open" on confirmation dialog
        // Note: 'Open' needs to be localized if the simulator language is not english
        safari.buttons["Open"].tap()

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

    /// Opens universal link with spotlight
    /// - Parameter urlString: universal link
    func openFromSpotlight(_ urlString: String) {
        // Press home to access spotlight with swipe action
        XCUIDevice.shared.press(.home)
        spotlight.swipeDown()
        sleep(1)

        // Clear whatever on the spotlight
        let textField = spotlight.textFields["SpotlightSearchField"]
        textField.tap(withNumberOfTaps: 3, numberOfTouches: 1)
        textField.clearText()

        // Type the url we want to launch
        textField.typeText(urlString)

        // Note: 'Continue' needs to be localized if the simulator language is not english
        if spotlight.buttons["Continue"].exists {
            spotlight.buttons["Continue"].tap()
        }
        sleep(1)

        // Unfortunately correct cell to search can be change due to spotlight decision
        // Only certain approach is to check cells and find the one matching
        // "https://some-adress..., https://some-adress..." format
        let labelString = ", " + urlString
        for cell in spotlight.collectionViews.cells.allElementsBoundByIndex where cell.label.contains(labelString) {
            cell.tap()
            break
        }
    }
}

extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }

        self.tap()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
    }
}
