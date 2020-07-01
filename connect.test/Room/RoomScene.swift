//
//  RoomScene.swift
//  connect.test
//
//  Created by Тарас Минин on 30/06/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import SpriteKit

protocol RoomSceneDelegate: class {
    func showUserCard()
    func showPersonCard(uid: String)
}

final class RoomScene: SKScene {

    weak var roomDelegate: RoomSceneDelegate?

    private let backgroundImageName: String

    private lazy var userNode: SKNode = {
        let node = UserNode()

        return node
    }()

    private var userSpeed: Double {
        // Lets suppose we use movement speed equals to
        // half scene height for 1 second
        return Double(size.height) / 2
    }

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
            let touchLocation = touch.location(in: self)
            let touchedNodes = nodes(at: touchLocation)

            for node in touchedNodes {
                if node.name == UserNode.nodeName {
                    roomDelegate?.showUserCard()
                    
                    return
                }
            }
            if canMove(to: touchLocation) {
                move(to: touchLocation)
            }
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

    private func moveAction(of node: SKNode, speed: Double, to point: CGPoint) -> SKAction {
        let distance = node.position.distance(to: point)
        let animationTime = TimeInterval(distance / CGFloat(speed))
        let moveAction = SKAction.move(to: point, duration: animationTime)

        return moveAction
    }

    private func endPointNode() -> SKNode {
        let node = SKShapeNode(circleOfRadius: 40)
        node.fillColor = .clear
        node.lineWidth = 3.0
        node.strokeColor = .white


        let centreDot = SKShapeNode(circleOfRadius: 5)
        centreDot.fillColor = .white

        node.addChild(centreDot)

        return node
    }

    @objc
    private func remove(node: SKNode) {
        node.removeFromParent()
    }
}

extension RoomScene: RoomSceneInteractive {
    func addUserNode() {
        addChild(userNode)
    }

    func addPersonNode() {}

    func canMove(to point: CGPoint) -> Bool {
        return !userNode.hasActions()
    }

    func move(to point: CGPoint) {
        let action = moveAction(of: userNode, speed: userSpeed, to: point)

        let endNode = endPointNode()
        endNode.position = point
        addChild(endNode)

        userNode.run(action) {
            endNode.removeFromParent()
        }
    }
}

private extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let deltaX = point.x - self.x
        let deltaY = point.y - self.y
        let distance = sqrt(deltaX * deltaX + deltaY * deltaY)

        return CGFloat(distance)
    }
}


class UserNode: SKNode {

    static let nodeName = "User"

    override init() {
        super.init()

        addChild(hearingZoneNode())
        addChild(avatarCircle())
    }

    private func avatarCircle() -> SKNode {
        let circle = SKShapeNode(circleOfRadius: 40)
        circle.name = "User"
        circle.strokeColor = .blue
        circle.fillColor = .red

        return circle
    }

    private func hearingZoneNode() -> SKNode {
        let circle = SKShapeNode(circleOfRadius: 160)
        circle.name = "Audio zone"
        circle.fillColor = UIColor.white.withAlphaComponent(0.3)
        circle.strokeColor = .clear

        return circle
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
