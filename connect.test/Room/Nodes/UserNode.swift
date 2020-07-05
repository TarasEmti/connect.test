//
//  UserNode.swift
//  connect.test
//
//  Created by Тарас Минин on 01/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import SpriteKit

final class UserNode: BasePersonNode, NodeMovable {

    private let memberInfo: RoomMember

    let moveSpeed: Double = 400

    private lazy var streamNode: CameraCaptureNode = {
        let node = CameraCaptureNode()

        return node
    }()

    private lazy var pulseNode: SKNode = {
        let pulseNode = SKShapeNode(circleOfRadius: RoomSceneLayoutConstants.personNodeRadius)
        pulseNode.strokeColor = .clear
        pulseNode.fillColor = UIColor.blue.withAlphaComponent(0.5)

        return pulseNode
    }()

    init(info: RoomMember) {
        self.memberInfo = info
        super.init()

        let audioZone = hearingZoneNode()
        audioZone.zPosition = -1
        addChild(audioZone)

        let userAudioCircle = SKShapeNode(circleOfRadius: RoomSceneLayoutConstants.personNodeRadius + 3)
        userAudioCircle.fillColor = .blue
        userAudioCircle.strokeColor = .blue
        addChild(userAudioCircle)

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

    func imitatePulse() {
        let targetNode = pulseNode.copy() as! SKNode
        addChild(targetNode)

        let scale = SKAction.scale(by: 1.4, duration: 0.4)
        scale.timingMode = .easeInEaseOut
        let wait = SKAction.wait(forDuration: 0.25)
        let fadeOut = SKAction.fadeOut(withDuration: 0.15)
        let fadeSeq = SKAction.sequence([wait, fadeOut])
        let pulseGroup = SKAction.group([scale, fadeSeq])

        targetNode.run(pulseGroup) {
            targetNode.removeFromParent()
        }
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

extension UserNode: VideoStreamNodeSupported {
    func startVideoStream() {
        streamNode.startVideoStream()
    }

    func stopVideoStream() {
        streamNode.stopVideoStream()
    }
}
