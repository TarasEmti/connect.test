//
//  RoomMemberNode.swift
//  connect.test
//
//  Created by Тарас Минин on 01/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import SpriteKit

final class RoomMemberNode: BasePersonNode {

    private let memberInfo: RoomMember

    init(info: RoomMember) {
        self.memberInfo = info
        super.init()

        if let image = info.icon {
            let node = buildNode(with: image)
            addToCircle(node)
        }
        circleNodeName = RoomMemberNode.nodeName
        createPhysicsBody(radius: RoomSceneLayoutConstants.personNodeRadius)
    }

    private func createPhysicsBody(radius: CGFloat) {
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.affectedByGravity = false
    }
}

extension RoomMemberNode: PersonNodeIdentifiable {
    static let nodeName: String = "Room Member"

    var uid: String {
        return memberInfo.uid
    }
}
