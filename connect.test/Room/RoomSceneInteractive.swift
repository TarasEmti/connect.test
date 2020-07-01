//
//  RoomSceneInteractive.swift
//  connect.test
//
//  Created by Тарас Минин on 30/06/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import UIKit

protocol RoomSceneInteractive {
    var roomDelegate: RoomSceneDelegate? { get set }

    func addUserNode(info: RoomMember)
    func addPersonNode(info: RoomMember)
    func removePersonNode(info: RoomMember)
    
    func canMove(to point: CGPoint) -> Bool
    func move(to point: CGPoint)
}
