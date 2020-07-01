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
    var isPortrait:  Bool    { size.height > size.width }
    var isLandscape: Bool    { size.width > size.height }
    var breadth:     CGFloat { min(size.width, size.height) }
    var breadthSize: CGSize  { .init(width: breadth, height: breadth) }
    var breadthRect: CGRect  { .init(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        guard let cgImage = cgImage?
            .cropping(to: .init(origin: .init(x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : 0,
                                              y: isPortrait  ? ((size.height-size.width)/2).rounded(.down) : 0),
                                size: breadthSize)) else { return nil }
        let format = imageRendererFormat
        format.opaque = false
        return UIGraphicsImageRenderer(size: breadthSize, format: format).image { _ in
            UIBezierPath(ovalIn: breadthRect).addClip()
            UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation)
            .draw(in: .init(origin: .zero, size: breadthSize))
        }
    }
}
