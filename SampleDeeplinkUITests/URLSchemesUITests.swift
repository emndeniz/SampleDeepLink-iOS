//
//  SampleDeeplinkUITests.swift
//  SampleDeeplinkUITests
//
//  Created by Mehmet Emin Deniz on 16.11.2023.
//

import XCTest
import UIKit

final class URLSchemesUITests: XCTestCase {

    private var app = XCUIApplication()

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func test_givenListURLProvidedWithoutQuerry_whenAppLaunched_thenExpectedToSeeListScreenWithDefaultUserLabel() throws {

        let url = "com.example.sample://list"
        assertScreenViews(url: url,
                          screenNameText: "Screen: List Screen",
                          userTypeText: "User Type: Default User")
    }

    func test_givenListURLProvidedWithPremium_whenAppLaunched_thenExpectedToSeeListScreenWithPremiumUserLabel() throws {

        let url = "com.example.sample://list?premium"
        assertScreenViews(url: url,
                          screenNameText: "Screen: List Screen",
                          userTypeText: "User Type: Premium User 🤑")
    }

    func test_givenDetailURLProvidedWithPaid_whenAppLaunched_thenExpectedToSeeDetailScreenWithPaidUserLabel() throws {

        let url = "com.example.sample://detail?paid"
        assertScreenViews(url: url,
                          screenNameText: "Screen: Detail Screen",
                          userTypeText: "User Type: Paid User 💰")
    }


    func test_givenURLProvidedWithDefaults_whenAppLaunched_thenExpectedToSeeHomeScreenWithDefaultUserLabel() throws {

        let url = "com.example.sample://"
        assertScreenViews(url: url,
                          screenNameText: "Screen: Home Screen",
                          userTypeText: "User Type: Default User")
    }


}


extension URLSchemesUITests {
    private func assertScreenViews(url:String,
                                   screenNameText:String,
                                   userTypeText:String) {

        UITestHelpers.shared.openWithSafari(app: app, url: url)

        let counterLabel = app.staticTexts[AccessibilityIdentifiers.ContentView.counter.rawValue]

        UITestHelpers.shared.waitFor(element: counterLabel)

        let lastURLLabel = app.staticTexts[AccessibilityIdentifiers.ContentView.lastUrl.rawValue]

        let screenName = app.staticTexts[AccessibilityIdentifiers.ContentView.screenName.rawValue]
        let userType = app.staticTexts[AccessibilityIdentifiers.ContentView.userType.rawValue]

        XCTAssertEqual(lastURLLabel.label, url)
        XCTAssertEqual(screenName.label, screenNameText)
        XCTAssertEqual(userType.label, userTypeText)
    }
}
