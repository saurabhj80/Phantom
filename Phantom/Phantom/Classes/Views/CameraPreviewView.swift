//
//  CameraPreviewView.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/13/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraPreviewViewDelegate: class {
    func cameraPreviewViewDidClickCaptureButton(view: CameraPreviewView)
}

class CameraPreviewView: UIView, CircleViewDelegate {
    
    // delegate
    weak var delegate: CameraPreviewViewDelegate?
    
    // the base layer object of the view
    override class func layerClass() -> AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    // the AVCapture Session
    var session: AVCaptureSession? {
        get {
            return (self.layer as? AVCaptureVideoPreviewLayer)?.session
        } set {
            (self.layer as? AVCaptureVideoPreviewLayer)?.session = newValue
        }
    }
    
    // Bottom click button
    private var circleView = CircleView()
    
    // because we want auto layout to take effect
    override func layoutSubviews() {
        super.layoutSubviews()
        setUp()
    }
    
    // set up the view
    private func setUp() {
        if circleView.superview != nil {
            return
        }
        let frame = CGRectMake(CGRectGetMidX(bounds) - 25, CGRectGetMaxY(bounds) - 75, 50, 50)
        circleView.delegate = self
        circleView.backgroundColor = UIColor.clearColor()
        circleView.frame = frame
        addSubview(circleView)
    }
    
    // capture picture
    private func circleViewDidClickButton(view: CircleView) {
        delegate?.cameraPreviewViewDidClickCaptureButton(self)
    }
}

private protocol CircleViewDelegate: class {
    func circleViewDidClickButton(view: CircleView)
}

private class CircleView: UIView {
    
    // the base layer object of the view
    override class func layerClass() -> AnyClass {
        return CAShapeLayer.self
    }
    
    var baseLayer: CAShapeLayer {
        get {
            return (self.layer as! CAShapeLayer)
        }
    }
    
    // delegate
    weak var delegate: CircleViewDelegate?
    
    private override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        drawCircleLayer()
    }
    
    private func drawCircleLayer() {
        let path = UIBezierPath(arcCenter: CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds)), radius: CGRectGetWidth(bounds)/2, startAngle: 0, endAngle: CGFloat(2.0*M_PI), clockwise: true)
        baseLayer.path = path.CGPath
        baseLayer.strokeColor = UIColor.whiteColor().CGColor
        baseLayer.fillColor = UIColor(white: 1, alpha: 0.5).CGColor
        baseLayer.lineWidth = 2.0
    }
    
    private override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        delegate?.circleViewDidClickButton(self)
        super.touchesBegan(touches, withEvent: event)
    }
}


