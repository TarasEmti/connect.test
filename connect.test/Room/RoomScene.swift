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
        super.init(size: Layout.sceneSize)

        scaleMode = .aspectFit
        anchorPoint = CGPoint(x: 0.0, y: 0.5)
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
        let node = SKShapeNode(circleOfRadius: Layout.personNodeRadius)
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

    private func findSpawnLocation() -> CGPoint {

        // Assume we spawn new members only on upper half of scene
        let pointX = arc4random() % UInt32((Layout.sceneSize.width - Layout.personNodeRadius))
        let pointY = arc4random() % UInt32((Layout.sceneSize.height / 2 - Layout.personNodeRadius))

        // warning: Logic to check if spawn place us possible

        return CGPoint(x: CGFloat(pointX), y: CGFloat(pointY))
    }
}

extension RoomScene: RoomSceneInteractive {
    func addUserNode() {
        userNode.position = findSpawnLocation()
        addChild(userNode)
    }

    func addPersonNode(info: RoomMember) {
        let node = RoomMemberNode(info: info)
        node.position = findSpawnLocation()
        addChild(node)
    }

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


final class UserNode: SKNode {

    override init() {
        super.init()

        addChild(hearingZoneNode())
        addChild(avatarCircle())
    }

    private func avatarCircle() -> SKNode {
        let circle = SKShapeNode(circleOfRadius: Layout.personNodeRadius)
        circle.name = "User"
        circle.strokeColor = .blue
        circle.fillColor = .red

        return circle
    }

    private func hearingZoneNode() -> SKNode {
        let circle = SKShapeNode(circleOfRadius: Layout.audioSharingRadius)
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

extension UserNode: PersonNodeIdentifiable {

    static let nodeName = "User"

    var uid: String {
        return "0"
    }
}

protocol PersonNodeIdentifiable {
    static var nodeName: String { get }
    var uid: String { get }
}

final class RoomMemberNode: SKNode {

    private let memberInfo: RoomMember

    init(info: RoomMember) {
        self.memberInfo = info
        super.init()

        addChild(avatarCircle())
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func avatarCircle() -> SKNode {
        let circle = SKShapeNode(circleOfRadius: Layout.personNodeRadius)
        circle.name = RoomMemberNode.nodeName
        circle.strokeColor = .blue
        circle.fillColor = .red

        if let image = memberInfo.icon {
            let texture = SKTexture(image: image)
            let imageNode = SKSpriteNode(texture: texture)
            addChild(imageNode)
        } else {
            let labelNode = SKLabelNode(text: memberInfo.name)
            addChild(labelNode)
        }

        return circle
    }
}

extension RoomMemberNode: PersonNodeIdentifiable {
    static let nodeName: String = "Room Member"

    var uid: String {
        return memberInfo.uid
    }
}


struct Layout {
    static let personNodeRadius: CGFloat = 40
    static let audioSharingRadius: CGFloat = 160
    static let sceneSize = CGSize(width: 1125, height: 2436)
}
