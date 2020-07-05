//
//  RoomSceneInteractive.swift
//  connect.test
//
//  Created by Тарас Минин on 30/06/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import UIKit

protocol RoomSceneInteractive: VideoStreamNodeSupported {
    var roomDelegate: RoomSceneDelegate? { get set }

    func startVideoStream()
    func stopVideoStream()

    func addUserNode(info: RoomMember)
    func addGuestNode(info: RoomMember)
    func removeGuestNode(info: RoomMember)

    // Returns false if path is unavailable
    func moveUser(to point: CGPoint) -> Bool
}
