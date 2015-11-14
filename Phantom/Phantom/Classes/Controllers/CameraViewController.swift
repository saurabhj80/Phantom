//
//  CameraViewController.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/10/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, CameraTopViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    
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
    
    // MARK: Top Cancel View
    
    @IBOutlet weak var topCancelView: CameraTopView! {
        didSet {
            topCancelView.delegate = self
        }
    }
    
    func cameraTopView(view: CameraTopView, didPressCancelButton sender: UIButton) {
        dismissCurrentViewController()
    }
    
    private func dismissCurrentViewController() {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            // stop the session
            self.session.stopRunning()
        }
        
        // change the index
        self.tabBarController?.selectedIndex = 0
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
            } else {
                self.dismissCurrentViewController()
            }
        }
    }
    
    /// Starts the AVCapture Session
    private func startSession() {
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            
            // Back Camera
            let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            
            // input device
            guard let inputDevice = try? AVCaptureDeviceInput(device: backCamera) else {
                
                // if we did not get the input device, then return
                return
            }
        
            // add the input
            if self.session.canAddInput(inputDevice) {
                self.session.addInput(inputDevice)
            }
            
            // add output
            let stillImageOutput = AVCaptureStillImageOutput()
            
            if self.session.canAddOutput(stillImageOutput) {
                self.session.addOutput(stillImageOutput)
            }
            
            let videoOutput = AVCaptureVideoDataOutput()
            let queue = dispatch_queue_create("video queue", nil)
            videoOutput.setSampleBufferDelegate(self, queue: queue)
            
            if self.session.canAddOutput(videoOutput) {
                self.session.addOutput(videoOutput)
            }
            
            
            let layer = AVCaptureVideoPreviewLayer(session: self.session)
            layer.videoGravity = AVLayerVideoGravityResizeAspect
            layer.frame = self.view.bounds
            self.view.layer.addSublayer(layer)
            
            // Start the session
            self.session.startRunning()
        }
        
    }
    
    
    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        
    }
}
