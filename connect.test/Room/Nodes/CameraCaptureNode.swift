//
//  CameraCaptureNode.swift
//  connect.test
//
//  Created by Тарас Минин on 01/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import AVFoundation
import SpriteKit

protocol VideoStreamNodeSupported {
    func startVideoStream()
    func stopVideoStream()
}

final class CameraCaptureNode: SKSpriteNode, VideoStreamNodeSupported {

    private let renderer = CameraLayerRenderer()

    init() {
        super.init(texture: nil, color: .black, size: .zero)

        do {
            try renderer.setupSession(with: self)
        } catch {
            print(error)
        }
    }

    func startVideoStream() {
        isHidden = false
        renderer.startSession()
    }

    func stopVideoStream() {
        isHidden = true
        renderer.stopSession()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CameraCaptureNode: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

        let imageBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!

        let rotate = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        let horizontalFlip = CGAffineTransform(scaleX: -1.0, y: 1.0)

        let ciimage = CIImage(cvPixelBuffer: imageBuffer)
            .transformed(by: rotate)
            .transformed(by: horizontalFlip)

        if let parent = parent {
            let parentSize = parent.frame.size
            if ciimage.extent.size.width < ciimage.extent.size.height {
                let scale = parentSize.width / ciimage.extent.size.width
                size = CGSize(width: parentSize.width, height: ciimage.extent.size.height * scale)
            } else {
                let scale = parentSize.height / ciimage.extent.size.height
                size = CGSize(width: ciimage.extent.size.width * scale, height: parentSize.height)
            }
        }

        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(ciimage, from: ciimage.extent)!
//
//        let minSide = min(size.width, size.height)
//        let newSize = CGSize(width: minSide, height: minSide)
//        let cropRect = CGRect(x: 0,
//                              y: 0,
//                              width: newSize.width,
//                              height: newSize.height)
//        let croppedImage = cgImage.cropping(to: CGRect(origin: .zero,
//                                                       size: newSize))!
//        let uiImage = UIGraphicsImageRenderer(size: newSize).image { (_) in
//            UIBezierPath(ovalIn: cropRect).addClip()
//            UIImage(cgImage: croppedImage).draw(in: CGRect(origin: .zero,
//                                                           size: newSize))
//        }

        // App crashing if we apply texture assigning to property.
        // You should always use SKAction
        let texture = SKTexture(cgImage: cgImage)
        let updateAction = SKAction.setTexture(texture)
        run(updateAction)
    }
}
