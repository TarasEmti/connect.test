//
//  CameraCaptureNode.swift
//  connect.test
//
//  Created by Тарас Минин on 01/07/2020.
//  Copyright © 2020 Тарас Минин. All rights reserved.
//

import AVFoundation
import SpriteKit

final class CameraCaptureNode: SKSpriteNode {

    private let renderer = CameraLayerRenderer()

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)

        do {
            try renderer.setupSession(with: self)
            renderer.startSession()
        } catch {
            print(error)
        }
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
        let ciimage = CIImage(cvPixelBuffer: imageBuffer).transformed(by: rotate)

        if size != ciimage.extent.size {
            size = ciimage.extent.size
        }

        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(ciimage, from: ciimage.extent)!

        // App Crashing with both ways. Too frequent node texture update
        // Option 1
//        let uiImage = UIImage(cgImage: cgImage)
        // Option 2
//        self.texture = SKTexture(image: uiImage)
//        self.texture = SKTexture(cgImage: cgImage)
    }
}
