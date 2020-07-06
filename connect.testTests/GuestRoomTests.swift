//
//  GuestRoomTests.swift
//  connect.testTests
//
//  Created by Тарас Минин on 06/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import XCTest
@testable import connect_test

class GuestRoomTests: XCTestCase {

    let guestName = "Test"
    var sut1: GuestRoomMember!
    var sut2: GuestRoomMember!

    override func setUpWithError() throws {
        sut1 = GuestRoomMember(name: guestName)
        sut2 = GuestRoomMember(name: guestName)
    }

    override func tearDownWithError() throws {
        sut1 = nil
        sut2 = nil
    }

    func testName() throws {
        XCTAssert(sut1.name == guestName, "Name is changed after init")
    }

    func testUid() throws {
        XCTAssert(sut1.uid != sut2.uid, "Guests can't have equal Uid")
    }
}
