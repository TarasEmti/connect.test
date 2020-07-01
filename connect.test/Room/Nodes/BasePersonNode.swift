//
//  BasePersonNode.swift
//  connect.test
//
//  Created by Тарас Минин on 01/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import SpriteKit

class BasePersonNode: SKNode {

    private let cirleNode: SKNode

    override init() {

        let radius = RoomSceneLayoutConstants.personNodeRadius

        let circle = SKShapeNode(circleOfRadius: radius)
        circle.name = UserNode.nodeName
        circle.strokeColor = UIColor.audioEnabledStroke
        circle.fillColor = UIColor.roomMember
        cirleNode = circle

        super.init()

        addChild(circle)
        createPhysicsBody(radius: radius)
    }

    private func createPhysicsBody(radius: CGFloat) {
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.collisionBitMask = 0x1 << 0
        physicsBody?.categoryBitMask = 0x1 << 0
        physicsBody?.affectedByGravity = false
    }

    var circleNodeName: String? {
        get { cirleNode.name }
        set { cirleNode.name = newValue }
    }

    func addToCircle(_ node: SKNode) {
        cirleNode.addChild(node)
    }

    func buildNode(with image: UIImage) -> SKNode {
        let texture = SKTexture(image: image)
        let imageNode = SKSpriteNode(texture: texture)
        imageNode.size = cirleNode.frame.size

        return imageNode
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
