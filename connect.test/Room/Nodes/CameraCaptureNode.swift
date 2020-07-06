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

        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(ciimage, from: ciimage.extent)!

        let image = UIImage(cgImage: cgImage).circleMasked!

        if let parent = parent {
            let parentSize = parent.frame.size
            if size != parentSize {
                size = parentSize
            }
        }
        // App crashing if we apply texture assigning to property.
        // You should always use SKAction
        let texture = SKTexture(image: image)
        let updateAction = SKAction.setTexture(texture)
        run(updateAction)
    }
}

private extension UIImage {

    var isLandscape: Bool { size.width > size.height }
    var circleMasked: UIImage? {
        let originPoint = CGPoint(
            x: isLandscape ? ((size.width - size.height)/2) : 0,
            y: !isLandscape ? ((size.height - size.width)/2) : 0
        )
        let circleSide = min(size.width, size.height)
        let circleSize = CGSize(width: circleSide, height: circleSide)
        let circleRect = CGRect(origin: .zero, size: circleSize)

        guard let cgImage = cgImage?.cropping(to: CGRect(origin: originPoint,
                                                         size: circleSize)) else { return nil }

        let outputImage = UIGraphicsImageRenderer(size: circleSize).image { _ in
            UIBezierPath(ovalIn: circleRect).addClip()
            UIImage(cgImage: cgImage).draw(in: circleRect)
        }

        return outputImage
    }
}
