//
//  RoomScene.swift
//  connect.test
//
//  Created by Тарас Минин on 30/06/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import SpriteKit

final class RoomScene: SKScene {

    let backgroundImageName: String
    var userNode: SKNode!

    init(backgroundImageName: String) {
        self.backgroundImageName = backgroundImageName
        super.init(size: CGSize(width: 1125, height: 2436))

        scaleMode = .aspectFit
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        initializeBackground(imageName: backgroundImageName)
        addUserNode()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            userNode.position = location
        }
    }

    private func initializeBackground(imageName: String) {

        let background = SKSpriteNode(imageNamed: imageName)
        background.position = .zero
        background.zPosition = -1

        let backgroundScale = size.height / background.size.height
        background.xScale = backgroundScale
        background.yScale = backgroundScale

        addChild(background)
    }
}

extension RoomScene: RoomSceneInteractive {
    func addUserNode() {
        let userNode = SKShapeNode(circleOfRadius: 40)
        userNode.fillColor = .red
        userNode.position = .zero
        self.userNode = userNode
        addChild(userNode)
    }

    func addPersonNode() {}

    func canMove(to point: CGPoint) -> Bool {
        return true
    }

    func move(to point: CGPoint) {}
}
