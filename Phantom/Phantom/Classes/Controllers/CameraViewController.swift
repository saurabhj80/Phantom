//
//  CameraViewController.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/10/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        
        switch (AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)) {
            case .NotDetermined: requestAccessForCamera()
            case .Denied: fallthrough
            case .Restricted: self.tabBarController?.selectedIndex = 0
            case .Authorized: requestAccessForCamera()
        }
    }
    
    // hide the status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: AVFoundation
    
    private var session: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetMedium
        return session
    }()
    
    /// Requests access for the given camera
    private func requestAccessForCamera() {
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo) { (success) in
            if success {
                self.startSession()
            }
        }
    }
    
    /// Starts the AVCapture Session
    private func startSession() {
        
        // Back Camera
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // input device
        guard let inputDevice = try? AVCaptureDeviceInput(device: backCamera) else {
            
            // if we did not get the input device, then return
            return
        }
        
        // add the input
        session.addInput(inputDevice)
        
        // add output
        let output = AVCaptureStillImageOutput()
        session.addOutput(output)
        
        let queue = dispatch_queue_create("camera", nil)
        //output.setSampleBufferDelegate(self, queue: queue)
        
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = AVLayerVideoGravityResizeAspect
        layer.frame = self.view.bounds
        self.view.layer.addSublayer(layer)
        
        // Start the session
        session.startRunning()
    }
    
    
    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        
    }

}
