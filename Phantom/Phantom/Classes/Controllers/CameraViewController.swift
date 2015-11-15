//
//  CameraViewController.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/10/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, CameraTopViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, CameraPreviewViewDelegate {
    
    // hide the status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        switch (AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)) {
            case .NotDetermined: requestAccessForCamera()
            case .Denied: fallthrough
            case .Restricted: self.tabBarController?.selectedIndex = 0
            case .Authorized: requestAccessForCamera()
        }
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
    
    // the preview of the view from the camera
    @IBOutlet weak var cameraPreviewView: CameraPreviewView! {
        didSet {
            cameraPreviewView.delegate = self
        }
    }
    
    // Capture button clicked
    func cameraPreviewViewDidClickCaptureButton(view: CameraPreviewView) {
        
    }
    
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
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            
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
                        
            self.cameraPreviewView.session = self.session
            
            // Start the session
            self.session.startRunning()
        }
        
    }
    
    
    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        
    }
}
