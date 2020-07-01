//
//  CameraLayerRenderer.swift
//  connect.test
//
//  Created by Тарас Минин on 01/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import AVKit

final class CameraLayerRenderer: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {

    private let session = AVCaptureSession()
    private var captureDevice: AVCaptureDevice!
    private var captureQueue: DispatchQueue!

    func setupSession(with delegate: AVCaptureVideoDataOutputSampleBufferDelegate) throws {
        do {
            captureDevice = try findFrontalCamera()
            captureQueue = DispatchQueue(label: "Video_output")

            // Capture Input
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if session.canAddInput(input) {
                session.addInput(input)
            }

            // Capture Output
            let output = AVCaptureVideoDataOutput()
            output.alwaysDiscardsLateVideoFrames = true
            output.setSampleBufferDelegate(delegate, queue: captureQueue)
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
        } catch {
            throw error
        }
    }

    private func findFrontalCamera() throws -> AVCaptureDevice {
        session.sessionPreset = .medium
        let discovery = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                         mediaType: .video,
                                                         position: .front)
        guard let frontalCamera: AVCaptureDevice = discovery.devices.first else {
            throw(CaptureError.deviceUnavailable)
        }
        return frontalCamera
    }

    func startSession() {
        captureQueue.async {
            self.session.startRunning()
        }
    }

    func stopSession() {
        session.stopRunning()
    }
}

extension CameraLayerRenderer {
    private enum CaptureError: Error {
        case deviceUnavailable
        case setupFailed
    }
}

extension CameraLayerRenderer {
    static func checkPermission(completion: @escaping((Bool) -> Void)) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (isGranted) in
                completion(isGranted)
            }
        case .denied, .restricted:
            completion(false)
        case .authorized:
            completion(true)
        @unknown default:
            fatalError("handle new AVCaptureDevice authorisation status")
        }
    }
}
