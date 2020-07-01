//
//  UserNode.swift
//  connect.test
//
//  Created by Тарас Минин on 01/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import SpriteKit

final class UserNode: BasePersonNode {

    private let memberInfo: RoomMember

    private lazy var streamNode: CameraCaptureNode = {
        let node = CameraCaptureNode()

        return node
    }()

    init(info: RoomMember) {
        self.memberInfo = info
        super.init()

        let audioZone = hearingZoneNode()
        audioZone.zPosition = -1
        addChild(audioZone)

        if let image = info.icon {
            let node = buildNode(with: image)
            addToCircle(node)
        }
        circleNodeName = UserNode.nodeName
        addToCircle(streamNode)

        #if targetEnvironment(simulator)
        print("Video capture on simulator unavailable")
        #else
        streamNode.startVideoStream()
        #endif
    }

    private func hearingZoneNode() -> SKNode {
        let circle = SKShapeNode(circleOfRadius: RoomSceneLayoutConstants.audioSharingRadius)
        circle.name = "Audio sharing zone"
        circle.fillColor = UIColor.audioShareZone
        circle.strokeColor = .clear

        return circle
    }
}

extension UserNode: PersonNodeIdentifiable {

    static let nodeName = "User"
    var uid: String { return memberInfo.uid }
}
