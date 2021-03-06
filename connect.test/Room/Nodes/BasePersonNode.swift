//
//  BasePersonNode.swift
//  connect.test
//
//  Created by Тарас Минин on 01/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import SpriteKit

class BasePersonNode: SKNode {

    private let circleNode: SKNode

    override init() {

        let radius = RoomSceneLayoutConstants.personNodeRadius

        let circle = SKShapeNode(circleOfRadius: radius)
        circle.name = UserNode.nodeName
        circle.strokeColor = UIColor.audioEnabledStroke
        circle.fillColor = UIColor.roomMember
        self.circleNode = circle

        super.init()

        addChild(circle)
    }

    var circleNodeName: String? {
        get { circleNode.name }
        set { circleNode.name = newValue }
    }

    func addToCircle(_ node: SKNode) {
        circleNode.addChild(node)
    }

    func buildNode(with image: UIImage) -> SKNode {
        let texture = SKTexture(image: image)
        let imageNode = SKSpriteNode(texture: texture)
        let size = CGSize(width: RoomSceneLayoutConstants.personNodeRadius*2,
                          height: RoomSceneLayoutConstants.personNodeRadius*2)
        imageNode.size = size

        return imageNode
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

