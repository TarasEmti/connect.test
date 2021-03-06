//
//  connect_testUITests.swift
//  connect.testUITests
//
//  Created by Тарас Минин on 29/06/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import XCTest

class connect_testUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let addRoomMemberButton = app.buttons["add room member"]
        XCTAssert(addRoomMemberButton.exists, "Add guest button shuld be on screen")

        let enableVideoButton = app.buttons["enable video"]
        XCTAssert(enableVideoButton.exists, "Add guest button shuld be on screen")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
