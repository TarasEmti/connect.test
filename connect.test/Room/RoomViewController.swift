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

final class RoomViewController: UIViewController {

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
        view.maximumZoomScale = 2
        view.delegate = self
        view.contentSize = RoomSceneLayoutConstants.sceneSize

        return view
    }()

    private lazy var cameraView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.layer.masksToBounds = true

        return view
    }()

    private lazy var addMockUserButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "add_room_member"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.clipsToBounds = true
        button.imageEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        button.backgroundColor = UIColor.background.withAlphaComponent(0.7)
        button.addTarget(self, action: #selector(addRoomMember), for: .touchUpInside)

        return button
    }()

    // MARK: - Properties

    private var roomScene = RoomSceneFactory().buildRoomScene(background: .office)
    private let cameraRenderer = CameraLayerRenderer()
    private var roomGuests: [RoomMember] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background

        scrollView.addSubview(roomSceneView)
        view.addSubview(scrollView)

        presentRoom()

        //view.addSubview(cameraView)
        view.addSubview(addMockUserButton)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        cameraRenderer.setupAVCapture()
//        cameraView.layer.addSublayer(cameraRenderer.previewLayer)
//        cameraRenderer.previewLayer.frame = cameraView.bounds
//        cameraRenderer.startSession()
    }

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.frame = view.bounds
        scrollView.minimumZoomScale = view.bounds.height / scrollView.contentSize.height
        roomSceneView.frame = CGRect(origin: .zero, size: scrollView.contentSize)

//        cameraView.frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 200))
//        cameraView.layer.cornerRadius = 100

        let buttonSize = CGSize(width: 40, height: 40)
        let offsetX: CGFloat = 16
        let offsetY: CGFloat = 16 + view.safeAreaInsets.bottom

        addMockUserButton.frame = CGRect(x: view.bounds.width - offsetX - buttonSize.width,
                                         y: view.bounds.height - offsetY - buttonSize.height,
                                         width: buttonSize.width,
                                         height: buttonSize.height)
        addMockUserButton.layer.cornerRadius = buttonSize.height / 2
    }

    // MARK: - Private methods

    private func presentRoom() {
        roomSceneView.presentScene(roomScene as? SKScene)
        roomScene.roomDelegate = self

        let user = UserRoomMember()
        roomScene.addUserNode(info: user)
    }

    @objc private func addRoomMember() {
        let num = roomGuests.count + 1
        let newMember = OtherRoomMember(name: "Guest \(num)")
        roomGuests.append(newMember)
        roomScene.addPersonNode(info: newMember)
    }
}

extension RoomViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return roomSceneView
    }
}

extension RoomViewController: RoomSceneDelegate {
    func showUserCard() {
        print("Calling User Info")
    }

    func showPersonCard(uid: String) {
        guard let guest = roomGuests.first(where: {$0.uid == uid}) else {
            assertionFailure("No Guest with ID = \(uid)")
            return
        }
        print("Guest Info:\nName: \(guest.name)\nuid: \(guest.uid)")
    }
}
