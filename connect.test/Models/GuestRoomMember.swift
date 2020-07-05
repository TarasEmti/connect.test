//
//  OtherRoomMember.swift
//  connect.test
//
//  Created by Тарас Минин on 01/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import UIKit

struct GuestRoomMember: RoomMember {

    let name: String
    let icon: UIImage?
    let uid: String

    init(name: String) {
        self.name = name
        icon = UIImage(named: "avatar")

        let letters = "abcdefghijklmnopqrstuvwxyz0123456789"
        let uidLengh = 6
        uid = String((0..<uidLengh).map { _ in letters.randomElement()! })
    }
}
