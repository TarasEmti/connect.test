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

    private lazy var cameraView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.layer.masksToBounds = true

        return view
    }()

    let renderer = CameraLayerRenderer()

    // MARK: - Properties

    private let roomFactory = RoomSceneFactory()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background

        scrollView.addSubview(roomSceneView)
        view.addSubview(scrollView)

        presentRoom()

        view.addSubview(cameraView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        renderer.setupAVCapture()
        cameraView.layer.addSublayer(renderer.previewLayer)
        renderer.previewLayer.frame = cameraView.bounds
        renderer.startSession()
    }

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.frame = view.bounds
        roomSceneView.frame = scrollView.bounds

        cameraView.frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 200))
        cameraView.layer.cornerRadius = 100
        cameraView.center = view.center
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

import AVKit

final class CameraLayerRenderer: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {

    let session = AVCaptureSession()
    var captureDevice: AVCaptureDevice!
    var captureQueue: DispatchQueue!
    var previewLayer: CALayer!

    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (isGranted) in
                if !isGranted {
                    print("Show error with link to settings")
                }
            }
        case .denied, .restricted:
            print("Show error with link to settings")
        case .authorized:
            break
        @unknown default:
            fatalError("handle new AVCaptureDevice authorisation status")
        }
    }

    func setupAVCapture() {

        session.sessionPreset = .medium
        let discovery = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                         mediaType: .video,
                                                         position: .front)
        guard let frontalCamera: AVCaptureDevice = discovery.devices.first else {
            assertionFailure("Device don't have frontal camera")
            return
        }
        captureDevice = frontalCamera

        setupSession()
    }

    func setupSession() {
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)

            if session.canAddInput(input) {
                session.addInput(input)
            }

            let output = AVCaptureVideoDataOutput()
            output.alwaysDiscardsLateVideoFrames = true

            captureQueue = DispatchQueue(label: "Video_output")
            output.setSampleBufferDelegate(self, queue: captureQueue)

            if session.canAddOutput(output) {
                session.addOutput(output)
            }

            //output.connection(with: .video)?.isEnabled = true
            output.connection(with: .video)?.videoOrientation = .portrait

            let layer = AVCaptureVideoPreviewLayer(session: session)
            layer.videoGravity = .resizeAspectFill

            previewLayer = layer
        } catch {
            print(error.localizedDescription)
        }
    }

    func startSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }

    func stopSession() {
        session.stopRunning()
    }

    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("what to do here?")
    }
}
