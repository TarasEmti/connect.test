//
//  RoomBackgroundTests.swift
//  connect.testTests
//
//  Created by Тарас Минин on 06/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import XCTest
@testable import connect_test

class RoomBackgroundTests: XCTestCase {

    var sut: [RoomBackground]!

    override func setUpWithError() throws {
        sut = RoomBackground.allCases
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testBackgroundImage() throws {
        for background in sut {
            let image = UIImage(named: background.imageName)
            XCTAssertNotNil(image, "No image found for resource \(background.imageName)")
        }
    }
}
