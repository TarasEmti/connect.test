//
//  EndpointNode.swift
//  connect.test
//
//  Created by Тарас Минин on 05/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import SpriteKit

final class EndpointNode: SKNode {

    override init() {
        super.init()

        let circle = SKShapeNode(circleOfRadius: RoomSceneLayoutConstants.personNodeRadius)
        circle.fillColor = .clear
        circle.lineWidth = 3.0
        circle.strokeColor = .white

        let centreDot = SKShapeNode(circleOfRadius: RoomSceneLayoutConstants.personNodeRadius / 10)
        centreDot.fillColor = .white

        circle.addChild(centreDot)

        addChild(circle)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
