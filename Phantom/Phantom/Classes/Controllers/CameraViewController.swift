//
//  CameraViewController.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/10/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, CameraTopViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, CircleViewDelegate, PostViewControllerDelegate {
    
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
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            // stop the session
            self.session.stopRunning()
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
    
    // MARK: Circle View Delegate
    
    // the preview of the view from the camera
    @IBOutlet weak var cameraPreviewView: CameraPreviewView!
    
    // the capture button
    @IBOutlet weak var circleView: CircleView! {
        didSet {
            circleView.delegate = self
        }
    }
    
    func circleViewDidClickButton(view: CircleView) {
        
        let connection = self.stillImageOutput.connectionWithMediaType(AVMediaTypeVideo)
        self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(connection) { (buffer, error) -> Void in
            
            guard let buffer = buffer else {
                return
            }
            
            // we have the data
            if let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer) {
                let image = UIImage(data: data)
                self.performSegueWithIdentifier("captureSegue", sender: image)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "captureSegue" {
            let vc = segue.destinationViewController as? PostViewController
            vc?.delegate = self
            if let image = sender as? UIImage {
                vc?.image = image
            }
        }
    }
    
    // MARK: PostView Controller Delegate
    
    func postViewControllerDidSaveObject(controller: PostViewController) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.dismissCurrentViewController()
        }
        self.navigationController?.popViewControllerAnimated(true)
        CATransaction.commit()
    }
    
    // MARK: AVFoundation
    
    private var stillImageOutput: AVCaptureStillImageOutput!
    private var videoOutput: AVCaptureVideoDataOutput!

    private var session: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPreset640x480
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
    
    private var hasBeenSetUp = false;
    
    /// Starts the AVCapture Session
    private func startSession() {
        
        if hasBeenSetUp {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                self.session.startRunning()
            }
            return
        }
        
        hasBeenSetUp = true
        
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
            self.stillImageOutput = AVCaptureStillImageOutput()
            
            if self.session.canAddOutput(self.stillImageOutput) {
                self.session.addOutput(self.stillImageOutput)
            }
            
            self.videoOutput = AVCaptureVideoDataOutput()
            let queue = dispatch_queue_create("video queue", nil)
            self.videoOutput.setSampleBufferDelegate(self, queue: queue)
            
            if self.session.canAddOutput(self.videoOutput) {
                self.session.addOutput(self.videoOutput)
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
