//
//  CameraViewController.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/10/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.redColor()
        
        //        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        //        let _ = try? AVCaptureDeviceInput(device: backCamera)

        switch (AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)) {
            case .NotDetermined: requestAccessForCamera()
            case .Denied: fallthrough
            case .Restricted: break
            case .Authorized: break
            
        }
    }
    
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
        
    }

}
