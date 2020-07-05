//
//  RoomScene.swift
//  connect.test
//
//  Created by Тарас Минин on 30/06/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import SpriteKit
import GameplayKit

final class RoomScene: SKScene {

    weak var roomDelegate: RoomSceneDelegate?

    private let backgroundImageName: String

    private lazy var graph = GKObstacleGraph(
        obstacles: [],
        bufferRadius: Float(RoomSceneLayoutConstants.personNodeRadius)
    )

    private var userNode: UserNode!

    private var userSpeed: Double {
        // Lets suppose we use movement speed equals to
        // half scene height for 2 seconds
        return Double(size.height) / 4
    }

    init(backgroundImageName: String) {
        self.backgroundImageName = backgroundImageName
        super.init(size: RoomSceneLayoutConstants.sceneSize)

        scaleMode = .aspectFit
        anchorPoint = CGPoint(x: 0.0, y: 0.5)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        initializeBackground(imageName: backgroundImageName)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            let touchedNodes = nodes(at: touchLocation)

            for node in touchedNodes {
                if node.name == UserNode.nodeName {
                    roomDelegate?.showUserCard()
                    
                    return
                } else if node.name == RoomMemberNode.nodeName {
                    roomDelegate?.showPersonCard(uid: (node.parent as! PersonNodeIdentifiable).uid)

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
        background.zPosition = NodePosition.background.zPosition

        let backgroundScale = size.height / background.size.height
        background.xScale = backgroundScale
        background.yScale = backgroundScale

        addChild(background)
    }

    private func moveAction(from start: CGPoint, speed: Double, to end: CGPoint) -> SKAction {

        let distance = start.distance(to: end)
        let animationTime = TimeInterval(distance / CGFloat(speed))
        let moveAction = SKAction.move(to: end, duration: animationTime)

        return moveAction
    }

    private func endPointNode() -> SKNode {
        let node = SKShapeNode(circleOfRadius: RoomSceneLayoutConstants.personNodeRadius)
        node.fillColor = .clear
        node.lineWidth = 3.0
        node.strokeColor = .white
        node.zPosition = NodePosition.endNode.zPosition

        let centreDot = SKShapeNode(circleOfRadius: RoomSceneLayoutConstants.personNodeRadius / 10)
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
        let pointX = arc4random() % UInt32((RoomSceneLayoutConstants.sceneSize.width - RoomSceneLayoutConstants.personNodeRadius))
        let pointY = arc4random() % UInt32((RoomSceneLayoutConstants.sceneSize.height / 2 - RoomSceneLayoutConstants.personNodeRadius))

        // Can add some logic to check if spawn place us available (no crossing)

        return CGPoint(x: CGFloat(pointX), y: CGFloat(pointY))
    }
}

extension RoomScene {
    private enum NodePosition: Int {
        case background = -1
        case endNode
        case user
        case roomMember

        var zPosition: CGFloat {
            return CGFloat(self.rawValue)
        }
    }
}

extension RoomScene: RoomSceneInteractive {
    func addUserNode(info: RoomMember) {
        let node = UserNode(info: info)
        node.position = CGPoint(x: RoomSceneLayoutConstants.personNodeRadius * 6,
                                y: size.height / 2 - RoomSceneLayoutConstants.personNodeRadius * 6)
        node.zPosition = NodePosition.user.zPosition
        self.userNode = node
        addChild(node)
    }

    func addPersonNode(info: RoomMember) {
        let node = RoomMemberNode(info: info)
        node.zPosition = NodePosition.roomMember.zPosition
        node.position = findSpawnLocation()
        addChild(node)

        let obstacles = SKNode.obstacles(fromNodePhysicsBodies: [node])
        graph.addObstacles(obstacles)
    }

    func removePersonNode(info: RoomMember) {
        enumerateChildNodes(withName: RoomMemberNode.nodeName) { (node, pointer) in
            guard
                let idNode = node as? PersonNodeIdentifiable,
                idNode.uid == info.uid else {
                return
            }
            node.removeAllActions()
            node.removeFromParent()
        }
    }

    func canMove(to point: CGPoint) -> Bool {
        return !userNode.hasActions()
    }

    func connectNode(atPoint point: CGPoint, in graph: GKObstacleGraph<GKGraphNode2D>) -> GKGraphNode2D {
        let vector = simd_float2(x: Float(point.x),
                                 y: Float(point.y))
        let node = GKGraphNode2D(point: vector)
        graph.connectUsingObstacles(node: node)

        return node
    }

    func move(to point: CGPoint) {
        let startNode = connectNode(atPoint: userNode.position, in: graph)
        let endNode = connectNode(atPoint: point, in: graph)

        defer { graph.remove([startNode, endNode])}

        let path = graph.findPath(from: startNode, to: endNode) as! [GKGraphNode2D]

        var moveActions: [SKAction] = []
        var start: CGPoint = userNode.position
        for point in path {
            let end = CGPoint(x: CGFloat(point.position.x),
                              y: CGFloat(point.position.y))
            let move = moveAction(from: start,
                                  speed: userSpeed,
                                  to: end)
            moveActions.append(move)
            start = end
        }

        let endPoint = endPointNode()
        endPoint.position = point
        addChild(endPoint)

        userNode.imitatePulse()

        let actionSequence = SKAction.sequence(moveActions)
        actionSequence.timingMode = .easeIn

        userNode.run(actionSequence) {
            endPoint.removeFromParent()
        }
    }

    func startVideoStream() {
        userNode.startVideoStream()
    }

    func stopVideoStream() {
        userNode.stopVideoStream()
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
