//
//  RoomBackground.swift
//  connect.test
//
//  Created by Тарас Минин on 30/06/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

enum RoomBackground {
    case office

    var imageName: String {
        switch self {
        case .office: return "office_cover"
        }
    }
}
