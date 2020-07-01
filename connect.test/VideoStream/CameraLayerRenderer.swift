//
//  CameraLayerRenderer.swift
//  connect.test
//
//  Created by Тарас Минин on 01/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

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
            output.connection(with: .video)?.videoOrientation = .portrait

            let layer = AVCaptureVideoPreviewLayer(session: session)
            layer.videoGravity = .resizeAspectFill

            previewLayer = layer
        } catch {
            print(error.localizedDescription)
        }
    }

    func startSession() {
        captureQueue.async {
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

