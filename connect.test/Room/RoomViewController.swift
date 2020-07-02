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
        view.maximumZoomScale = 3
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

    private lazy var enableVideoStremButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "enable_video"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.clipsToBounds = true
        button.imageEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        button.backgroundColor = UIColor.background.withAlphaComponent(0.7)
        button.addTarget(self, action: #selector(switchStream), for: .touchUpInside)

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

        scrollView.minimumZoomScale = view.bounds.height / scrollView.contentSize.height
        scrollView.addSubview(roomSceneView)
        view.addSubview(scrollView)

        presentRoom()
        view.addSubview(addMockUserButton)
        view.addSubview(enableVideoStremButton)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        CameraLayerRenderer.checkPermission { [weak self] (isGranted) in
            guard let self = self, !isGranted else { return }

            DispatchQueue.main.async {
                self.roomScene.stopVideoStream()
                self.showPermissionAlert()
            }
        }
    }

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.frame = view.bounds
        roomSceneView.frame = CGRect(origin: .zero, size: scrollView.contentSize)

        let buttonSize = CGSize(width: 50, height: 50)
        let offset: CGFloat = 16

        addMockUserButton.frame = CGRect(
            x: view.bounds.width - offset - buttonSize.width,
            y: view.bounds.height - offset - view.safeAreaInsets.bottom - buttonSize.height,
            width: buttonSize.width,
            height: buttonSize.height
        )
        addMockUserButton.layer.cornerRadius = buttonSize.height / 2

        enableVideoStremButton.frame = CGRect(
            x: addMockUserButton.frame.minX,
            y: addMockUserButton.frame.minY - buttonSize.height - offset,
            width: buttonSize.width,
            height: buttonSize.height
        )
        enableVideoStremButton.layer.cornerRadius = buttonSize.height / 2
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

    @objc private func switchStream() {
        if CameraLayerRenderer.isStreaming {
            roomScene.stopVideoStream()
        } else {
            roomScene.startVideoStream()
        }
    }

    func showPermissionAlert() {
        let alert = UIAlertController(title: "Warning", message: "Unable to start video stream. Please, check camera permission in settings", preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
            let urlString = UIApplication.openSettingsURLString
            let url = URL(string: urlString)!

            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(settingsAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
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
