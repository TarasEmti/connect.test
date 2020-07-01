//
//  UserRoomMember.swift
//  connect.test
//
//  Created by Тарас Минин on 01/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import UIKit

struct UserRoomMember: RoomMember {

    let name: String
    let icon: UIImage?
    let uid: String

    init() {
        name = "Connect.Club Developer"
        icon = nil
        uid = "User"
    }
}
