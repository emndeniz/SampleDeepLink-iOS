//
//  UniversalLinkTests.swift
//  SampleDeeplinkUITests
//
//  Created by Mehmet Emin Deniz on 18.12.2023.
//

import XCTest

final class UniversalLinkTests: XCTestCase {

    private var app = XCUIApplication()

    override func setUpWithError() throws {
        app.launchArguments = ["UITEST"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func test_givenAppURL_whenItsClicked_thenExpectedToSeeAppRunning() throws {
        let url = "https://www.emindeniz.rf.gd"
        UITestHelpers.shared.openFromSpotlight(url)

        //TODO: Verify something!
        XCTAssertEqual(app.state, .runningForeground)
    }

}
