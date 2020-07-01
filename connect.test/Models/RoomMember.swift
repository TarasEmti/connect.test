//
//  RoomMember.swift
//  connect.test
//
//  Created by Тарас Минин on 01/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import UIKit

protocol RoomMember {
    var name: String { get }
    var icon: UIImage? { get }
    var uid: String { get }
}
