//
//  RoomViewController.swift
//  connect.test
//
//  Created by Тарас Минин on 29/06/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import UIKit
import SpriteKit

final class RoomSceneFactory {
    func buildRoomScene(background: RoomBackground) -> RoomSceneInteractive {
        let scene = RoomScene(backgroundImageName: background.rawValue)

        return scene
    }
}

class RoomViewController: UIViewController {

    // MARK: - Subviews

    private lazy var roomSceneView: SKView = {
        let view = SKView()
        view.showsFPS = true
        view.showsNodeCount = true
        view.backgroundColor = self.view.backgroundColor
        view.ignoresSiblingOrder = true

        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = self.view.backgroundColor
        view.maximumZoomScale = 8.0
        view.zoomScale = 3.0
        view.delegate = self
        view.contentSize = UIScreen.main.bounds.size

        return view
    }()

    // MARK: - Properties

    private let roomFactory = RoomSceneFactory()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background

        scrollView.addSubview(roomSceneView)
        view.addSubview(scrollView)

        presentRoom()
    }

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.frame = view.bounds
        roomSceneView.frame = scrollView.bounds
    }

    // MARK: - Private methods

    private func presentRoom() {
        let room = roomFactory.buildRoomScene(background: .office)
        roomSceneView.presentScene(room as? SKScene)
    }
}

extension RoomViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return roomSceneView
    }
}

protocol PersonCircular {
    var icon: UIImage { get set }
    var audioSource: String? { get }
    var videoSource: String? { get }
}
