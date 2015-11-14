//
//  CameraPreviewView.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/13/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit
import AVFoundation

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
