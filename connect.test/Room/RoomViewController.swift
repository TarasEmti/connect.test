//
//  RoomViewController.swift
//  connect.test
//
//  Created by Тарас Минин on 29/06/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import UIKit
import SpriteKit

class RoomViewController: UIViewController {

    private lazy var roomSceneView: SKView = {
        let view = SKView()
        view.showsFPS = true
        view.showsNodeCount = true
        view.backgroundColor = UIColor.red
        view.ignoresSiblingOrder = true

        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .yellow
        view.maximumZoomScale = 8
        view.minimumZoomScale = 1.0
        view.bouncesZoom = true
        view.zoomScale = 3.0
        view.bounces = true

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.addSubview(roomSceneView)

        let roomScene = RoomScene(size: CGSize(width: 1125, height: 2436))
        scrollView.contentSize = UIScreen.main.bounds.size
        roomSceneView.presentScene(roomScene)

        roomScene.scaleMode = .aspectFit
        roomScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.frame = view.bounds
        roomSceneView.frame = scrollView.bounds
    }
}

extension RoomViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return roomSceneView
    }
}

final class RoomScene: SKScene {
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "office_cover")
        background.position = .zero
        background.zPosition = -1
        let backgroundScale = size.height / background.size.height
        background.xScale = backgroundScale
        background.yScale = backgroundScale
        addChild(background)

        let userNode = SKShapeNode(circleOfRadius: 40)
        userNode.fillColor = .red
        userNode.position = .zero
        addChild(userNode)
    }
}

protocol PersonCircular {
    var icon: UIImage { get set }
    var audioSource: String? { get }
    var videoSource: String? { get }
}

final class UserCircular: SKNode {

}
