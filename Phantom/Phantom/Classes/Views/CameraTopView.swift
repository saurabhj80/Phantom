//
//  CameraTopView.swift
//  Phantom
//
//  Created by Saurabh Jain on 11/13/15.
//  Copyright © 2015 Saurabh Jain. All rights reserved.
//

import UIKit

/// Camera Top View Delegate
protocol CameraTopViewDelegate: class {
    func cameraTopView(view: CameraTopView, didPressCancelButton sender: UIButton)
}

class CameraTopView: UIView {

    // Delegate
    weak var delegate: CameraTopViewDelegate?
    
    // IBAction
    @IBAction func cancelButtonClicked(sender: UIButton!) {
        delegate?.cameraTopView(self, didPressCancelButton: sender)
    }

}
