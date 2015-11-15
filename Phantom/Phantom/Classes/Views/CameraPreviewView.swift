//
//  CameraPreviewView.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/13/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit
import AVFoundation

/// The UIView subclass which renders the session from the AVCaptureSession
/**
- parameter foo: This is a param.
*/
class CameraPreviewView: UIView {
    
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
}

protocol CircleViewDelegate: class {
    func circleViewDidClickButton(view: CircleView)
}

@IBDesignable
class CircleView: UIView {
    
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
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        drawCircleLayer()
    }
    
    private func drawCircleLayer() {
        baseLayer.strokeColor = UIColor.whiteColor().CGColor
        baseLayer.fillColor = UIColor(white: 1, alpha: 0.5).CGColor
        baseLayer.lineWidth = 2.0
        let path = UIBezierPath(arcCenter: CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds)), radius: CGRectGetWidth(bounds)/2 - baseLayer.lineWidth, startAngle: 0, endAngle: CGFloat(2.0*M_PI), clockwise: true)
        baseLayer.path = path.CGPath
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        delegate?.circleViewDidClickButton(self)
        super.touchesBegan(touches, withEvent: event)
    }
}


